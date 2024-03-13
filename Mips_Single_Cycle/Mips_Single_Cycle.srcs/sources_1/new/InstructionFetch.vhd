----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2023 06:51:10 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity InstructionFetch is
    Port ( clk : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           jump : in STD_LOGIC;
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jump_addr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc : out STD_LOGIC_VECTOR (15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is

signal sumator_out:STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
signal mux1_out: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
signal mux2_out: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
signal pc_out: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

type ROM is array (0 to 15) of std_logic_vector(15 downto 0);
signal s_rom : ROM := (b"000_000_000_001_0_000",   --0010     add $1, $0, $0       
                      b"001_000_100_0001010",    --220A       addi $4, $0, 10	
                      b"001_000_010_0000011",    --2103       addi $6, $0, 3
                      b"000_000_000_010_0_000",    --0020     add $2, $0, $0
                      b"000_000_000_101_0_000",    --0050     add $5, $0, $0	
                      b"100_001_100_0000110",    --8606       beq $1, $4, 6
                      b"010_010_011_0001010",  --498A         lw $3, 10($2)	
                      b"110_011_110_0000001",     --CF01      bne $3, $6, 1
                      b"000_101_011_101_0_000",   --15D0      add $5, $5, $3	
                      b"001_010_010_0000001",     --2901      addi $2, $2, 1
                      b"001_001_001_0000001",   --2481        addi $1, $1, 1	
                      b"111_0000000000101",    --E005         j 5		
                      b"011_000_101_0010100",   --6294        sw $5, 20($0)
                      others => b"0000000000000000");
begin

sumator_out <= pc_out + 1;

PC_process : process(clk, en, reset)
begin
    if rising_edge(clk) then
        if reset='1' then
            pc_out <= x"0000";
        elsif en='1' then
            pc_out <= mux2_out;
        end if;
       end if;
end process;

mux1 : process(clk, pcsrc,sumator_out,branch_addr)
begin
    if pcsrc = '0' then
        mux1_out <= sumator_out;
    else mux1_out <= branch_addr;
    end if;
end process;

mux2 : process(clk,jump,mux1_out)
begin
    if jump = '0' then
        mux2_out <= mux1_out;
    else mux2_out <= jump_addr;
    end if;
end process;

pc <= sumator_out;
instruction <= s_rom(conv_integer(pc_out));

end Behavioral;