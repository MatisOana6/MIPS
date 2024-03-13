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

entity MainControl is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
        reg_dest: out STD_LOGIC;
        reg_write : out STD_LOGIC;
        alu_src: out STD_LOGIC;
        ext_op: out STD_LOGIC;
        alu_op : out STD_LOGIC_VECTOR (1 downto 0); 
        mem_write: out STD_LOGIC; 
        mem_to_reg: out STD_LOGIC;
        branch_eq: out STD_LOGIC;
        branch_ne: out STD_LOGIC;
        branch_gtz: out STD_LOGIC;
        jump : out STD_LOGIC);
end MainControl;

architecture Behavioral of MainControl is

begin

    process(opcode) 
    begin 
        reg_dest<='0';
        reg_write <= '0';
        alu_src <= '0';
        ext_op <= '0';
        alu_op <= "00"; 
        mem_write <= '0'; 
        mem_to_reg <= '0';
        branch_eq <= '0';
        branch_ne <= '0';
        branch_gtz <= '0';
        jump <= '0';
        
        case opcode is 
            when "000" => --tip R
                reg_dest <= '1';
                reg_write <= '1';
                
            when "001" =>  --addi
                reg_write <= '1';
                alu_src <= '1';
                ext_op <= '1';
                alu_op <= "01";
                
            when "010" =>  --lw
                reg_write <= '1';
                alu_src <= '1';
                ext_op <= '1';
                alu_op <= "01";
                mem_to_reg <= '1';
                
            when "011" =>   --sw
                reg_write <= '1';
                alu_src <= '1';
                ext_op <= '1';
                alu_op <= "01";
                mem_write <= '1';
                
            when "100" =>  --beq
                ext_op <= '1';
                alu_op <= "10";
                branch_eq <= '1';
                
            when "101" => --bgtz  
                ext_op <= '1';
                alu_op <= "10";
                branch_gtz <= '1';
            
            when "110" => --bne 
                ext_op <= '1';
                alu_op <= "10";
                branch_ne <= '1';
                
            when "111" => --j
                jump <= '1'; 
                   
            when others => reg_dest<= 'X';
                        reg_write <='X';
                        alu_src <= 'X';
                        ext_op <= 'X';
                        alu_op <= "XX"; 
                        mem_write <= 'X'; 
                        mem_to_reg <= 'X';
                        branch_eq <= 'X';
                        branch_ne <= 'X';
                        branch_gtz <= 'X';
                        jump <= 'X';                     
        end case;
                   
    end process;
    
end Behavioral;