----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2023 01:09:06 PM
-- Design Name: 
-- Module Name: UnitateExecutie - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UnitateExecutie is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           alu_src : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           alu_op : in STD_LOGIC_VECTOR (1 downto 0);
           zero : out STD_LOGIC;
           alu_res : out STD_LOGIC_VECTOR (15 downto 0);
           pcplus : in STD_LOGIC_VECTOR(15 downto 0);
           branch_addr : out STD_LOGIC_VECTOR(15 downto 0);
           greater_tz : out STD_LOGIC);
end UnitateExecutie;

architecture Behavioral of UnitateExecutie is

signal mux_out :STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal alu_ctrl:STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal aluResTemp : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal zeros : STD_LOGIC_VECTOR(15 downto 0);
--signal branch_addr_temp : STD_LOGIC_VECTOR(15 downto 0);
begin

    mux: process(rd2, ext_imm,alu_src) 
    begin 
        if alu_src='0' 
            then mux_out <= rd2;
        else mux_out <= ext_imm;
        end if;
    end process;
    
    alu_control : process(alu_op, func) 
    begin
              case alu_op is
                   when "00" => -- R type 
                       case func is
                           when "000" => alu_ctrl <= "000"; -- ADD
                           when "001" => alu_ctrl <= "001"; -- SUB
                           when "010" => alu_ctrl <= "010"; -- SLL
                           when "011" => alu_ctrl <= "011"; -- SRL
                           when "100" => alu_ctrl <= "100"; -- AND
                           when "101" => alu_ctrl<= "101"; -- OR
                           when "110" => alu_ctrl <= "110"; -- XOR
                           when "111" => alu_ctrl <= "111"; -- SLLV
                           when others => alu_ctrl <= (others => '0'); -- unknown
                       end case;
                   when "01" => alu_ctrl <= "000"; -- +
                   when "10" => alu_ctrl <= "001"; -- -
                   when "11" => alu_ctrl <= "110"; -- |
                   when others => alu_ctrl <= (others => '0'); -- unknown
               end case;
           end process;
    
    alu : process(alu_ctrl, sa, rd1, mux_out)
    begin
        case alu_ctrl is
            when "000" => aluResTemp <= rd1 + mux_out;
            when "001" => aluResTemp <= rd1 - mux_out;
            when "010" => 
                if sa = '0' then aluResTemp <= mux_out;
                elsif sa ='1' then aluResTemp <= mux_out(14 downto 0) & '0';
                end if;
            when "011" => 
                if sa = '0' then aluResTemp <= mux_out;
                elsif sa='1' then aluResTemp <= '0' & mux_out(15 downto 1);
                end if;
            when "100" => aluResTemp <= rd1 and mux_out;
            when "101" => aluResTemp <= rd1 or mux_out;
            when "110" => aluResTemp <= rd1 xor mux_out;
            when "111" => 
               case rd1 is
                when x"0001" => aluResTemp <= mux_out(14 downto 0) & "0";
                when x"0002" => aluResTemp <= mux_out(13 downto 0) & "00";
                when x"0003" => aluResTemp <= mux_out(12 downto 0) & "000";
                when x"0004" => aluResTemp <= mux_out(11 downto 0) & "0000";
                when x"0005" => aluResTemp <= mux_out(10 downto 0) & "00000";
                when x"0006" => aluResTemp <= mux_out(9 downto 0) & "000000";     
                when x"0007" => aluResTemp <= mux_out(8 downto 0) & "0000000";
                when x"0008" => aluResTemp <= mux_out(7 downto 0) & "00000000";
                when x"0009" => aluResTemp <= mux_out(6 downto 0) & "000000000";
                when x"000A" => aluResTemp <= mux_out(5 downto 0) & "0000000000";
                when x"000B" => aluResTemp <= mux_out(4 downto 0) & "00000000000";
                when x"000C" => aluResTemp <= mux_out (3 downto 0) & "000000000000";
                when x"000D" => aluResTemp <= mux_out(2 downto 0) & "0000000000000";
                when x"000E" => aluResTemp <= mux_out(1 downto 0) & "00000000000000";
                when x"000F" => aluResTemp <= mux_out(0) & "000000000000000";
                when x"0010" => aluResTemp <= x"0000";
                when others => aluResTemp <="XXXXXXXXXXXXXXXX";
                end case;
           when others => aluResTemp <= "XXXXXXXXXXXXXXXX";       
        end case;
    end process;
    
    zero <= '1' when aluResTemp = x"0000" else '0';
    greater_tz <= '1' when conv_integer(aluResTemp) > 0 else '0';
    
    alu_res <= aluResTemp;
    branch_addr <= ext_imm + pcplus;   
 
end Behavioral;