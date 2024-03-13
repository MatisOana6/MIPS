----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 01:04:16 AM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity test_env is
    Port (  clk : in STD_LOGIC;
          btn : in STD_LOGIC_VECTOR (4 downto 0);
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          led : out STD_LOGIC_VECTOR (15 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0);
          cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component InstructionFetch is 
 Port ( clk : in STD_LOGIC;
          pcsrc : in STD_LOGIC;
          jump : in STD_LOGIC;
          branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
          jump_addr : in STD_LOGIC_VECTOR (15 downto 0);
          en : in STD_LOGIC;
          reset : in STD_LOGIC;
          instruction : out STD_LOGIC_VECTOR (15 downto 0);
          pc : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component SSD is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component MPG is
    Port ( en : out STD_LOGIC;
    input : in STD_LOGIC;
    clock : in STD_LOGIC);
end component;

component MainControl is 
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
 end component;

 

component UnitateExecutie is
     Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
            alu_src : in STD_LOGIC;
            rd2 : in STD_LOGIC_VECTOR (15 downto 0);
            ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
            sa : in STD_LOGIC;
            func : in STD_LOGIC_VECTOR (2 downto 0);
            alu_op : in STD_LOGIC_VECTOR (1 downto 0);
            zero : out STD_LOGIC;
            alu_res : out STD_LOGIC_VECTOR (15 downto 0);
            pcplus : in STD_LOGIC_VECTOR(15 downto 0);
            branch_addr : out STD_LOGIC_VECTOR(15 downto 0);
            greater_tz : out STD_LOGIC);
 end component;
 
 component MEM is
     Port ( alu_res : in STD_LOGIC_VECTOR (4 downto 0);
            clk : in STD_LOGIC;
            rd2 : in STD_LOGIC_VECTOR (15 downto 0);
            mem_write : in STD_LOGIC;
            mpg_en : in STD_LOGIC;
            mem_data : out STD_LOGIC_VECTOR(15 downto 0);
            alu_res_out : out STD_LOGIC_VECTOR (4 downto 0));
 end component;
 
 component ID_Unity is
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
 end component;

signal enable : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal pc_src : STD_LOGIC := '0';
signal jump : STD_LOGIC := '0';
signal jump_addr : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal branch_addr : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal instruction : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal pc_plus_1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal digits : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal SSD_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

signal opcode : STD_LOGIC_VECTOR (2 downto 0);
signal reg_dest: STD_LOGIC;
signal reg_write : STD_LOGIC;
signal alu_src: STD_LOGIC;
signal ext_op:  STD_LOGIC;
signal alu_ctrl :  STD_LOGIC_VECTOR (1 downto 0) := (others => '0'); 
signal mem_write: STD_LOGIC; 
signal mem_to_reg:  STD_LOGIC;
signal branch_eq:  STD_LOGIC;
signal branch_ne: STD_LOGIC;
signal branch_gtz: STD_LOGIC;
signal j :  STD_LOGIC;


signal wd : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd2 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ext_imm : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal func : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal sa : STD_LOGIC := '0';

signal alu_op : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal zero : STD_LOGIC := '0';
signal greater_tz : STD_LOGIC := '0';
signal alu_res : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal pcplus : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
--signal branch_addr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

signal mpg_en : STD_LOGIC;
signal mem_data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal alu_res_out : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

signal pcsrc : STD_LOGIC := '0';


begin

    mpg1: MPG port map (en => enable, input => btn(0), clock => clk);
    mpg2: MPG port map (en => reset, input => btn(1), clock => clk);
    
    --SSD_in <= instruction when sw(3)='0' else pc_plus_1;
    
    instruction_fetch_comp: InstructionFetch port map (clk => clk, 
                                                        pcsrc=> pc_src, 
                                                        jump => j,
                                                        branch_addr => branch_addr,
                                                         jump_addr => jump_addr, 
                                                         en=>enable,
                                                          reset=>reset,
                                                           instruction => instruction,
                                                            pc=>pc_plus_1 );
    
    SSD_component: SSD port map (digit0 => SSD_in(3 downto 0),digit1 => SSD_in(7 downto 4), digit2 => SSD_in(11 downto 8), 
                digit3 => SSD_in (15 downto 12), clk => clk, cat => cat, an => an);
                
    uc_comp : MainControl port map (opcode=>instruction(15 downto 13), 
                         reg_dest=> reg_dest,
                          reg_write=>reg_write,
                           alu_src=>alu_src, 
                           ext_op=>ext_op,
                            alu_op=>alu_ctrl,
                             mem_write=>mem_write,
                              mem_to_reg=>mem_to_reg, 
                              branch_eq=>branch_eq,
                               branch_ne=>branch_ne,
                               branch_gtz => branch_gtz,
                                jump => j);
        
 
 --!!!!!!!!!!                        
     execution_unit : UnitateExecutie port map(
                                  rd1 => rd1,
                                  alu_src => alu_src,
                                  rd2 => rd2, 
                                  ext_imm => ext_imm , 
                                  sa => sa  , 
                                  func => func , 
                                  alu_op => alu_ctrl, 
                                  zero => zero , 
                                  alu_res=>alu_res ,
                                  pcplus => pc_plus_1,
                                  branch_addr => branch_addr,
                                  greater_tz => greater_tz);
     
     memorie : MEM port map(alu_res => alu_res(4 downto 0), 
                                      clk => clk, 
                                      rd2 => rd2 , 
                                      mem_write => mem_write , 
                                      mpg_en => enable , 
                                      mem_data => mem_data, 
                                      alu_res_out => alu_res_out );
     
     pc_src <= (branch_eq AND zero) OR (branch_ne AND (NOT ZERO)) OR (branch_gtz AND greater_tz);
     wd <= alu_res when mem_to_reg = '0' else mem_data;
     jump_addr <= pc_plus_1(15 downto 13) & instruction(12 downto 0);
     
     instr_decode : ID_Unity port map( clk => clk,
                instruction => instruction,
                reg_write => reg_write,
                reg_dest => reg_dest,
                mpg_en => enable,
                wd => wd,
                ext_op => ext_op,
                rd1 => rd1,
                rd2 => rd2,
                ext_imm => ext_imm,
                func => func,
                sa => sa); 
                                                
    display_SSD : process(instruction, pc_plus_1, rd1, rd2, ext_imm, alu_res, mem_data, wd) 
    begin
        case sw(2 downto 0) is
           when "000" => SSD_in <= instruction;
           when "001" => SSD_in <= pc_plus_1;
           when "010" => SSD_in <= rd1;
           when "011" => SSD_in <= rd2;
           when "100" => SSD_in <= ext_imm;
           when "101" => SSD_in <= alu_res;
           when "110" => SSD_in <= mem_data;
           when "111" => SSD_in <= wd;
           when others => SSD_in <= "XXXXXXXXXXXXXXXX";
        end case;
    end process;
    
    led(0) <= reg_dest;
    led(1) <= reg_write;
    led(2) <= alu_src;
    led(3) <= ext_op;
    led(4) <= alu_ctrl(0);
    led(5) <= alu_ctrl(1);
    led(6) <= mem_write;
    led(7) <= mem_to_reg;
    led(8) <= branch_eq;
    led(9) <= branch_ne;
    led(10) <= branch_gtz;
    led(11) <= j;

end Behavioral;