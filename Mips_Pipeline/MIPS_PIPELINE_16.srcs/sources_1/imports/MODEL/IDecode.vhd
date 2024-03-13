library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDecode is
    Port ( clk: in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(12 downto 0);
           WA : in STD_LOGIC_VECTOR(2 downto 0);
           WD : in STD_LOGIC_VECTOR(15 downto 0);
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(15 downto 0);
           RD2 : out STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
           func : out STD_LOGIC_VECTOR(2 downto 0);
           sa : out STD_LOGIC;
           rt : out STD_LOGIC_VECTOR(2 downto 0);
           rd : out STD_LOGIC_VECTOR(2 downto 0));
end IDecode;

architecture Behavioral of IDecode is

component RF is 
 Port( RA1: in std_logic_vector(2 downto 0);
       RA2: in std_logic_vector(2 downto 0);
       WA: in  std_logic_vector(2 downto 0);
       WD: in std_logic_vector(15 downto 0);
       clk: in std_logic;
       en: in std_logic;
       RegWr: in std_logic;
       RD1: out std_logic_vector(15 downto 0);
       RD2: out std_logic_vector(15 downto 0));
end component;
-- RegFile

signal RF1: std_logic_vector(15 downto 0);
signal RF2: std_logic_vector(15 downto 0);

begin
Reg : RF port map( RA1 => Instr(12 downto 10), RA2 => Instr(9 downto 7),
                   WA => WA, WD => WD, clk => clk, en => en, RegWr => RegWrite,
                   RD1 => RF1, RD2 => RF2 );

    -- RegFile write
    RD1 <= RF1;
    RD2 <= RF2;
    
    sa <= Instr(3);
    func <= Instr(2 downto 0);
     
    --Extension unit
    Ext_imm<= "000000000" & Instr(6 downto 0) when ExtOp='0' or Instr(6)='0' else "111111111" & Instr(6 downto 0); 
    
    rt<=Instr(9 downto 7);
    rd<=Instr(6 downto 4);
    
 end Behavioral;
