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

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {TopTestBench} architecture {TopTestBench}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity TopTestBench is
end TopTestBench;

--}} End of automatically maintained section

architecture TopTestBench of TopTestBench is   

  file file_VECTORS : text;
  file file_RESULTS : text;
	-- input signals
	signal  CLK_tb: std_logic := 0;
	signal i3,i2,Instruction_Intb,Load_tb: std_logic;
	signal exec, done: std_logic;
	-- observed signals
	signal y_tb: std_logic;
	
	constant period : time := 50ns;
	
	begin
	  UUT : entity Processor
	port map ( 
	i0 => i0,
	i1 => i1,
	i2 => i2,
	i3 => i3,
	Instruction_In => Instruction_Intb,
	Load => Load_tb,
	CLK => CLK_tb,
	y => y_tb);	
	
	
--Writing to a File
ReadingFile :process
    variable v_ILINE     : line;
    variable v_OLINE     : line;
    variable v_ADD_TERM : std_logic_vector(24 downto 0);;
  begin
 
    file_open(file_VECTORS, "input_vectors.txt",  read_mode);
    file_open(file_RESULTS, "output_results.txt", write_mode);
 	
	Load_tb <= '1'
    while not endfile(file_VECTORS) loop
      readline(file_VECTORS, v_ILINE);
      read(v_ILINE, v_ADD_TERM);

      Instruction_tb <= v_ADD_TERM;
      r_ADD_TERM2 <= v_ADD_TERM2;
 	  
	  CLK_tb <= not CLK_tb after period/2;
	  
      wait for 50 ns;
	  
 
      write(v_OLINE, ,);
      writeline(file_RESULTS, v_OLINE);
    end loop;
 
    file_close(file_VECTORS);
    file_close(file_RESULTS);
     
    wait;
  end process ReadingFile;
  
 
  

end TopTestBench;
