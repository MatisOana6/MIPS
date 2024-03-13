----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2023 07:11:35 PM
-- Design Name: 
-- Module Name: Reg_file - Behavioral
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

entity Reg_file is
    Port ( clk : in STD_LOGIC;
       ra1 : in STD_LOGIC_VECTOR (2 downto 0);
       ra2 : in STD_LOGIC_VECTOR (2 downto 0);
       wa : in STD_LOGIC_VECTOR (2 downto 0);
       wd : in STD_LOGIC_VECTOR (15 downto 0);
       reg_write : in STD_LOGIC;
       mpg_en : in STD_LOGIC;
       rd1 : out STD_LOGIC_VECTOR (15 downto 0);
       rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end Reg_file;

architecture Behavioral of Reg_file is

type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal reg_file : reg_array := (
                x"0000", 
                x"0001", 
                x"0002", 
                x"0003", 
                x"0004", 
                x"0005", 
                x"0006", 
                others => x"0000");

begin
    rd1 <= reg_file(conv_integer(ra1));
    rd2 <= reg_file(conv_integer(ra2));
    
    process(clk)
    begin
        if rising_edge(clk) then
            if mpg_en = '1' then
                if reg_write = '1' then
                    reg_file(conv_integer(wa)) <= wd;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;