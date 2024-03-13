library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab7_4 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end lab7_4;

architecture Behavioral of lab7_4 is

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch
    Port ( clk: in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component IDecode
    Port ( clk: in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(12 downto 0);
           WD : in STD_LOGIC_VECTOR(15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(15 downto 0);
           RD2 : out STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
           func : out STD_LOGIC_VECTOR(2 downto 0);
           sa : out STD_LOGIC);
end component;

component MainControl
    Port ( Instr : in STD_LOGIC_VECTOR(2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component ExecutionUnit is
    Port ( PCinc : in STD_LOGIC_VECTOR(15 downto 0);
           RD1 : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
           func : in STD_LOGIC_VECTOR(2 downto 0);
           sa : in STD_LOGIC;
           rt: in std_logic_vector (2 downto 0);
           rd: in std_logic_vector (2 downto 0);
           RegDst: in std_logic;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR(15 downto 0);
           ALURes : out STD_LOGIC_VECTOR(15 downto 0);
           Zero : out STD_LOGIC;
           rWA: out std_logic_vector (2 downto 0));
end component;

component MEM
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal MemWrite: std_logic;
signal MemToReg: std_logic;
signal RegWrite: std_logic;
signal ALUOp: std_logic_vector (2 downto 0);

signal WD: std_logic_vector(15 downto 0);
signal sa: std_logic;
signal func: std_logic_vector(2 downto 0);
signal Ext_imm: std_logic_vector(15 downto 0);
signal RD1: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
  
signal Instruction: std_logic_vector(15 downto 0);
signal nextInstrAddr: std_logic_vector(15 downto 0);
signal branchAddr: std_logic_vector(15 downto 0);
signal jumpAddre: std_logic_vector(15 downto 0);
signal PCSrc: std_logic;

signal rWA: std_logic_vector (2 downto 0);
signal ALURes: std_logic_vector(15 downto 0);
signal Zero: std_logic;

signal MemData: std_logic_vector(15 downto 0);
signal ALUResOut: std_logic_vector(15 downto 0);
   
signal en: std_logic;
signal rst: std_logic;
signal digits: std_logic_vector(15 downto 0);

signal rt: std_logic_vector (2 downto 0);          -- Instr(9:7)
signal rd: std_logic_vector (2 downto 0);          -- Instr(6:4)

signal IF_ID: std_logic_vector(31 downto 0);
signal ID_EX: std_logic_vector(82 downto 0);
signal EX_MEM: std_logic_vector(55 downto 0);
signal MEM_WB: std_logic_vector(36 downto 0);


begin

    -- buttons: reset, enable
    monopulse1: MPG port map(en, btn(0), clk);
    monopulse2: MPG port map(rst, btn(1), clk);
    display : SSD port map (clk, digits , an, cat);
    -- main units
    inst_IF: IFetch port map(clk, rst, en, branchAddr, jumpAddre, Jump, PCSrc, Instruction, nextInstrAddr);
    inst_ID: IDecode port map(clk, en, Instruction(12 downto 0), WD, RegWrite, RegDst, ExtOp, RD1, RD2, Ext_imm, func, sa);
    inst_MC: MainControl port map(Instruction(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    inst_EX: ExecutionUnit port map(ID_EX(24 downto 9), ID_EX(40 downto 25), ID_EX(56 downto 41),ID_EX(72 downto 57), ID_EX(75 downto 73),ID_EX(76),ID_EX(79 downto 77),ID_EX(82 downto 80),ID_EX(8), ID_EX(7), ID_EX(6 downto 4), branchAddr, ALURes, Zero,rWA); 
    inst_MEM: MEM port map(clk, en, EX_MEM(36 downto 21), RD2, MemWrite, MemData, ALUResOut);

process(clk)
begin
if rising_edge(clk) then
  if en = '1' then
    IF_ID(31 downto 16) <= nextInstrAddr;
    IF_ID(15 downto 0) <= Instruction;
  end if;
end if;
end process;

--ID/EX
process(clk)
begin
if rising_edge(clk) then
  if en = '1' then    
    ID_EX(0) <= MemToReg;
    ID_EX(1) <= RegWrite;
    ID_EX(2) <= MemWrite;
    ID_EX(3) <= Branch;
    ID_EX(6 downto 4) <= ALUOp;
    ID_EX(7) <= ALUSrc;
    ID_EX(8) <= RegDst;
    ID_EX(24 downto 9) <= IF_ID(31 downto 16);
    ID_EX(40 downto 25) <= RD1;
    ID_EX(56 downto 41) <= RD2;
    ID_EX(72 downto 57) <= Ext_Imm;
    ID_EX(75 downto 73) <= func;
    ID_EX(76) <= sa;
    ID_EX(79 downto 77) <= rt;
    ID_EX(82 downto 80) <= rd;
  end if;
end if;
end process;

--EX/MEM
process(clk)
begin
if rising_edge(clk) then
  if en = '1' then
    EX_MEM(3 downto 0) <= ID_EX(3 downto 0);
    EX_MEM(19 downto 4) <= branchAddr;
    EX_MEM(20) <= Zero;
    EX_MEM(36 downto 21) <= ALURes;
    EX_MEM(52 downto 37) <= ID_EX(56 downto 41);
    EX_MEM(55 downto 53) <= rWA;
  end if;
end if;
end process;

--MEM/WB
process(clk)
begin
if rising_edge(clk) then
  if en = '1' then
    MEM_WB(1 downto 0) <= EX_MEM(1 downto 0);
    MEM_WB(17 downto 2) <= MemData;
    MEM_WB(33 downto 18) <= ALUResOut;
    MEM_WB(36 downto 34) <= EX_MEM(55 downto 53);
  end if;
end if;
end process;

--unitatea Write Back
process(MEM_WB(0), MEM_WB(17 downto 2), MEM_WB(33 downto 18)) 
begin
case MEM_WB(0) is 
    when '1' => WD <= MEM_WB(17 downto 2);
    when '0' => WD <= MEM_WB(33 downto 18);
    when others => WD <= (others => '0');
end case;
end process;

    -- WriteBack unit

    -- branch control
    PCSrc <= Zero and Branch;

    -- jump address
    jumpAddre <= IF_ID(31 downto 29) & IF_ID(12 downto 0);

   -- SSD display MUX
    with sw(7 downto 5) select
        digits <=  Instruction when "000", 
                   nextInstrAddr when "001",
                   RD1 when "010",
                   RD2 when "011",
                   Ext_Imm when "100",
                   ALURes when "101",
                   MemData when "110",
                   WD when "111",
                   (others => '0') when others; 

    -- main controls on the leds
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
end Behavioral;