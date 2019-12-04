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

    file file_in : text;
    file file_results : text;

    -- stimulus signals
    signal clk : std_logic := 0;
    signal reset : std_logic;

    signal instruction_in : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal load : std_logic;
    signal done_loading : std_logic := 0;

    signal num_instructions : integer range 0 to INSTR_BUF_SIZE := 0;
    signal cycle_number : integer range 0 to INSTR_BUF_SIZE*2 := 0;
    signal done_executing : std_logic := 0;


    -- observed signals

begin

    reset <= '1', '0' after 2 * period;

    UUT: entity Processor port map (
            clk=>clk,
            reset=>reset,
            load=>load,
            instruction_in=>instruction_in
        );
	
    ReadingFile: process
        variable instr_line : line;
        variable instruction : std_logic_vector(24 downto 0);
        variable counter : integer range 0 to INSTR_BUF_SIZE-1 := 0;
    begin
        file_open(file_in, "binary_output.txt",  read_mode);
        load <= '1';

        wait for period*2;

        while not endfile(file_in) loop
            -- Read line from file and then read 0's and 1's into instruction signal
            readline(file_in, instr_line);
            read(instr_line, instruction);

            instruction_in <= instruction;

            num_instructions <= num_instructions + 1;
            wait until rising_edge(clk);
        end loop;

        wait for period/2;

        done_loading <= '1';
        load <= '0';

        wait;
    end process ReadingFile;
    
    WritingResults: process
        variable result_line : line;
    begin
        file_open(file_RESULTS, "output_results.txt", write_mode);
        
        
        while not done_executing loop
            if (done_loading) then
                write(my_line, string'("Cycle ") & integer'image(cycle_number) & string'(":"));
                writeline(output, my_line);

                -- write(result_line, out_data);
                -- writeline(file_results, result_line);
            end if;
            wait until rising_edge(clk);
        end loop;

    end process WritingResults;

    count_cycles: process
    begin
        while (cycle_number < num_instructions + 3) loop
            if (done_loading) then
                cycle_number <= cycle_number + 1;
            end if;
            wait for rising_edge(clk);
        end loop;

        done_executing <= '1';

        wait;
    end process count_cycles;

    clock: process
    begin
        for i in 0 to 1032 * (2 ** 7) loop
            wait for period/2;
            clk <= not clk;
        end loop;
        
        file_close(file_in);
        file_close(file_results);

        wait;
    end process;


end TopTestBench;
