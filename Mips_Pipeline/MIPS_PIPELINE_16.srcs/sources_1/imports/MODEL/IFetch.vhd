library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is

-- Memorie ROM
type tROM is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal ROM : tROM := (
                      b"000_000_000_001_0_000",   --0010
                      b"001_000_100_0001010",    --220A
                      b"001_000_010_0000011",    --2103
                      b"000_000_000_010_0_000",    --0020
                      b"000_000_000_101_0_000",    --0050
                      b"100_001_100_0001011",    --860D
                      b"000_000_000_000_0_000",
                      b"000_000_000_000_0_000",
                      b"000_000_000_000_0_000",
                      b"010_010_011_0001010",  --498A  
                      b"110_011_110_0000100",     --CF04
                      b"000_000_000_000_0_000",
                      b"000_000_000_000_0_000",
                      b"000_000_000_000_0_000",  
                      b"000_101_011_101_0_000",       --15D0
                      b"001_010_010_0000001",     --2901
                      b"001_001_001_0000001",   --2481
                      b"111_0000000000101",    --E005
                      b"000_000_000_000_0_000",
                      b"011_000_101_0010100",   --6294 
                      others => b"0000000000000000");

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PCAux, NextAddr, AuxSgn, AuxSgn1: STD_LOGIC_VECTOR(15 downto 0);

begin

    -- Program Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    -- Instruction OUT
    Instruction <= ROM(conv_integer(PC(7 downto 0)));

    -- PC incremented
    PCAux <= PC + 1;
    PCinc <= PCAux;

    -- MUX Branch
    process(PCSrc, PCAux, BranchAddress)
    begin
        case PCSrc is 
            when '1' => AuxSgn <= BranchAddress;
            when others => AuxSgn <= PCAux;
        end case;
    end process;	

     -- MUX Jump
    process(Jump, AuxSgn, JumpAddress)
    begin
        case Jump is
            when '1' => NextAddr <= JumpAddress;
            when others => NextAddr <= AuxSgn;
        end case;
    end process;

end Behavioral;