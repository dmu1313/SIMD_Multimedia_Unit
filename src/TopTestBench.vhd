
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
        NUM_REGISTERS : positive := 32;
		REG_WIDTH : positive := 128;
		ALU_OP_WIDTH : positive := 10;
		R3_OPCODE_WIDTH : positive := 8
	);
end TopTestBench;

architecture TopTestBench of TopTestBench is   
    constant period : time := 50ns;

    file file_in : text;
    file file_results : text;

    -- stimulus signals
    signal clk : std_logic := '0';
    signal reset : std_logic;

    signal instruction_in : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal load : std_logic;
    signal done_loading : std_logic := '0';

    signal num_instructions : integer range 0 to INSTR_BUF_SIZE := 0;
    signal cycle_number : integer range 0 to INSTR_BUF_SIZE*2 := 0;
    signal done_executing : std_logic := '0';


    -- observed signals
    signal IF_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal ID_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal EX_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal WB_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal registers : STD_LOGIC_VECTOR((NUM_REGISTERS*REG_WIDTH)-1 downto 0);
    signal forwarding_event_occurred : std_logic;
    signal forwarded_reg : std_logic_vector(LOG_NUM_REG-1 downto 0);

begin
    UUT: entity Processor port map (
            clk=>clk,
            reset=>reset,
            load=>load,
            instruction_in=>instruction_in,

            IF_instr=>IF_instr,
			ID_instr=>ID_instr,
			EX_instr=>EX_instr,
			WB_instr=>WB_instr,
			registers=>registers,
			forwarding_event_occurred=>forwarding_event_occurred,
			forwarded_reg=>forwarded_reg
        );
	
    ReadingFile: process
        variable instr_line : line;
        variable instruction : std_logic_vector(24 downto 0);
        variable counter : integer range 0 to INSTR_BUF_SIZE-1 := 0;
    begin
        file_open(file_in, "binary_output.txt",  read_mode);
        load <= '1';

        reset <= '1';--, '0' after 2 * period;

        wait for period*2;

        reset <= '0';

        while not endfile(file_in) loop
            -- Read line from file and then read 0's and 1's into instruction signal
            readline(file_in, instr_line);
            read(instr_line, instruction);

            instruction_in <= instruction;

            num_instructions <= num_instructions + 1;
            wait until rising_edge(clk);
        end loop;

        load <= '0';
        reset <= '1';
        wait for period*2;
        reset <= '0';

        wait for period/2;

        done_loading <= '1';

        wait;
    end process ReadingFile;
    
    WritingResults: process
        variable result_line : line;
    begin
        file_open(file_results, "output_results.txt", write_mode);
        
        
        while not (done_executing='1') loop
            if (done_loading='1') then
                write(result_line, string'("Cycle ") & integer'image(cycle_number) & string'(":"));
                writeline(file_results, result_line);

                write(result_line, string'("IF Stage has Instruction: ") & to_hstring(IF_instr));
                writeline(file_results, result_line);

                write(result_line, string'("ID Stage has Instruction: ") & to_hstring(ID_instr));
                writeline(file_results, result_line);

                write(result_line, string'("EX Stage has Instruction: ") & to_hstring(EX_instr));
                writeline(file_results, result_line);

                write(result_line, string'("WB Stage has Instruction: ") & to_hstring(WB_instr));
                writeline(file_results, result_line);

                if (forwarding_event_occurred = '1') then
                    write(result_line, string'("Forwarding event has occurred! Register r") & integer'image(to_integer(unsigned(forwarded_reg))) & string'(" was forwarded back to the EX stage!"));
                    writeline(file_results, result_line);
                end if;

                write(result_line, string'(""));
                writeline(file_results, result_line);
            end if;
            wait until rising_edge(clk);
        end loop;

        write(result_line, string'("Register File:"));
        writeline(file_results, result_line);

        -- loop through register file and output register file
        for i in 1 to NUM_REGISTERS loop
            write(result_line, string'("r") & integer'image(i-1) & string'(": ") & to_hstring(
                    registers((i*REG_WIDTH)-1 downto ((i-1)*REG_WIDTH))
                ));
            writeline(file_results, result_line);
        end loop;
        
        wait;
    end process WritingResults;

    count_cycles: process
    begin
        while (cycle_number < num_instructions + 3) loop
            if (done_loading = '1') then
                cycle_number <= cycle_number + 1;
            end if;
            wait until rising_edge(clk);
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
