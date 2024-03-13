----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2023 06:28:59 PM
-- Design Name: 
-- Module Name: ID_Unity - Behavioral
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
entity ID_Unity is
    Port ( clk : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           reg_write : in STD_LOGIC;
           reg_dest : in STD_LOGIC;
           mpg_en : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           ext_op : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID_Unity;

architecture Behavioral of ID_Unity is

component Reg_file is
    Port ( clk : in STD_LOGIC;
       ra1 : in STD_LOGIC_VECTOR (2 downto 0);
       ra2 : in STD_LOGIC_VECTOR (2 downto 0);
       wa : in STD_LOGIC_VECTOR (2 downto 0);
       wd : in STD_LOGIC_VECTOR (15 downto 0);
       reg_write : in STD_LOGIC;
       mpg_en : in STD_LOGIC;
       rd1 : out STD_LOGIC_VECTOR (15 downto 0);
       rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal wa : STD_LOGIC_VECTOR(2 downto 0) := "000";
--signal to_be_ext : STD_LOGIC_VECTOR(6 downto 0) := "0000000";

begin

    wa <= instruction(9 downto 7) when reg_dest='0' else instruction(6 downto 4);
    func <= instruction(2 downto 0);
    sa <= instruction(3);
    
    --concatenez 0000000000(9 zero) la utlimii cei mai semnificativi 7 (6 downto 0) biti ai intructiunii daca ext_op este 0, 
    --adica la extinderea cu zero
    ext_imm <= "000000000" & instruction(6 downto 0) when ext_op = '0' 
        else instruction(6)& instruction(6) & instruction(6)& instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6 downto 0);
   --altfel, daca ext_op este 1, fac extinderea cu bitul 6(de 9 ori), care reprezinta si semnul si concatenez la ultimii 7 biti         
    reg_file_comp : REG_FILE port map ( clk => clk, ra1 => instruction(12 downto 10), ra2 => instruction(9 downto 7),
            wa => wa, wd => wd, reg_write => reg_write, mpg_en => mpg_en, rd1 => rd1, rd2 => rd2);

end Behavioral;