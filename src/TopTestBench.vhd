-------------------------------------------------------------------------------
--
-- Title       : TopTestBench
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\TopTestBench.vhd
-- Generated   : Sun Dec  1 21:02:51 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity TopTestBench is
    generic (
		n : positive := 6;
		INSTR_BUF_SIZE : positive := 64;
		INSTR_WIDTH : positive := 25;
		LOG_NUM_REG : positive := 5;
		REG_WIDTH : positive := 128;
		ALU_OP_WIDTH : positive := 10;
		R3_OPCODE_WIDTH : positive := 8;
	);
end TopTestBench;

architecture TopTestBench of TopTestBench is   
    constant period : time := 50ns;

    file file_VECTORS : text;
    file file_RESULTS : text;

    -- stimulus signals
    signal clk : std_logic := 0;
    signal reset : std_logic;


    signal i3,i2,Instruction_Intb,Load_tb : std_logic;
    signal exec, done : std_logic;

    -- observed signals
    signal y_tb: std_logic;

begin
    UUT : entity Processor port map (
            clk=>clk,
            reset=>reset,
            load=>,
            instruction_in=>
        );
	
    ReadingFile :process
        variable v_ILINE     : line;
        variable v_OLINE     : line;
        variable v_ADD_TERM : std_logic_vector(24 downto 0);
    begin
        file_open(file_VECTORS, "binary_output.txt",  read_mode);

        Load_tb <= '1';

        while not endfile(file_VECTORS) loop
            readline(file_VECTORS, v_ILINE);
            read(v_ILINE, v_ADD_TERM);

            Instruction_tb <= v_ADD_TERM;
            r_ADD_TERM2 <= v_ADD_TERM2;


        end loop;

        wait;
    end process ReadingFile;
    
    WritingResults: process
    begin
        file_open(file_RESULTS, "output_results.txt", write_mode);

        write(v_OLINE, ,);
        writeline(file_RESULTS, v_OLINE);
        file_close(file_RESULTS);
    end process WritingResults;

    clock: process
    begin
        for i in 0 to 1032 * (2 ** 7) loop
            wait for period/2;
            clk <= not clk;
        end loop;
        
        file_close(file_VECTORS);
        file_close(file_RESULTS);

        wait;
    end process;


end TopTestBench;
