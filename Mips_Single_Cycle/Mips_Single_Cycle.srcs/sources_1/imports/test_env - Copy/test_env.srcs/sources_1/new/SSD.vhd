----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 06:47:01 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal count : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal sel : STD_LOGIC_VECTOR (15 downto 14) := "00";
signal mux1_output : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin
    counter : process (clk) 
        begin
            if rising_edge(clk) then
                count <= count + 1;
            end if;
        end process counter;
        
        sel <= count(15 downto 14);
    
        mux1 : process(sel)
            begin
                case sel is
                    when "00" => mux1_output <= Digit0;
                    when "01" =>  mux1_output  <= Digit1;
                    when "10" => mux1_output  <= Digit2;
                    when others => mux1_output  <= Digit3;
                end case;
        end process;
        
        mux2: process(sel)
            begin
                case sel is
                    when "00" => an <= "1110";
                    when "01" => an <= "1101";
                    when "10" => an <= "1011";
                    when "11" => an <= "0111";
                    when others => an <= "XXXX";
                end case;
        end process;
        
        with mux1_output SELect
           cat<= "1111001" when "0001",   --1
                 "0100100" when "0010",   --2
                 "0110000" when "0011",   --3
                 "0011001" when "0100",   --4
                 "0010010" when "0101",   --5
                 "0000010" when "0110",   --6
                 "1111000" when "0111",   --7
                 "0000000" when "1000",   --8
                 "0010000" when "1001",   --9
                 "0001000" when "1010",   --A
                 "0000011" when "1011",   --b
                 "1000110" when "1100",   --C
                 "0100001" when "1101",   --d
                 "0000110" when "1110",   --E
                 "0001110" when "1111",   --F
                 "1000000" when others;   --0
end Behavioral;