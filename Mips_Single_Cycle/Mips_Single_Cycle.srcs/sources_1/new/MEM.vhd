----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2023 05:44:10 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( alu_res : in STD_LOGIC_VECTOR (4 downto 0);
           clk : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           mem_write : in STD_LOGIC;
           mpg_en : in STD_LOGIC;
           mem_data : out STD_LOGIC_VECTOR(15 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (4 downto 0));
end MEM;

architecture Behavioral of MEM is
type TRAM is array(0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM:TRAM  := (x"0001", x"0011", x"0010", x"0100", x"0011", x"0001", x"0111", x"0011", x"1001", x"0010", others => x"0000");

begin
    
    alu_res_out <= alu_res;
    mem_data <= RAM(conv_integer(alu_res));
    
    process(clk, mpg_en, mem_write)
    begin
       if mpg_en = '1' then
                if rising_edge(clk) and mem_write = '1' then
                    RAM(conv_integer(alu_res)) <= rd2;
                end if;
            end if;
        end process;

end Behavioral;