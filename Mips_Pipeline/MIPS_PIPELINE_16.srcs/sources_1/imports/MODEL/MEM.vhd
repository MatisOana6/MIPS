library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal MEM : mem_type := (x"0001", x"0011", x"0010", x"0100", x"0011", x"0001", x"0111", x"0011", x"1001", x"0010", others => x"0000");

begin

    -- Data Memory
    process(clk) 			
    begin
        if rising_edge(clk) then
            if en = '1' and MemWrite='1' then
                MEM(conv_integer(ALUResIn(4 downto 0))) <= RD2;			
            end if;
        end if;
    end process;

    -- outputs
    MemData <= MEM(conv_integer(ALUResIn(4 downto 0)));
    ALUResOut <= ALUResIn;

end Behavioral;