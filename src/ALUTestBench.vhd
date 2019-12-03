-------------------------------------------------------------------------------
--
-- Title       : ALUTestBench
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\ALUTestBench.vhd
-- Generated   : Sun Dec  1 23:01:12 2019
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
--{entity {ALUTestBench} architecture {ALUTestBench}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity ALUTestBench is
end ALUTestBench;

--}} End of automatically maintained section

architecture ALUTestBench of ALUTestBench is

	-- input signals
	signal rs1_tb : std_logic_vector(127 downto 0);
	signal rs2_tb : std_logic_vector(127 downto 0);
	signal rs3_tb : std_logic_vector(127 downto 0);
	signal rd_tb : std_logic_vector(127 downto 0);
	signal Opcode_tb : std_logic_vector(9 downto 0);
	-- observed signals
	signal c_tb: std_logic_vector(127 downto 0);
	
	begin
	  UUT : entity ALU
	port map (
		rs1 => rs1_tb,
		rs2 => rs2_tb,
		rs3 => rs3_tb,
		rd => rd_tb,
		Opcode => Opcode_tb,
		c => c_tb
	);
--327865
	stim:process
		variable expected : std_logic_vector(127 downto 0);
	begin
		rs1_tb	<= b"0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_1000000000000000";
		rs2_tb	<= b"0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_1000000000000001"; 
		rs3_tb	<= b"0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101_0000000000000101";
		rd_tb 	<= b"0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000";
		
	--	Opcode_tb <= "0000010000";	
	--	wait for 5ns;
	--	
	--	Opcode_tb(9 downto 8) <="10"; 
	--	Opcode_tb(4 downto 0) <="00000";
	--	
	--			for i in 0 to 7 loop
	--			(Opcode_tb(7), Opcode_tb(6), Opcode_tb(5)) <= (to_unsigned(i,3)); 
	--			wait for 5ns; 	
	--			end loop;

		Opcode_tb <= b"10_000_01001";

	--	Opcode_tb(9 downto 8) <="11";  
	--			for i in 1 to 19 loop
	--				(Opcode_tb(7), Opcode_tb(6), Opcode_tb(5), Opcode_tb(4), Opcode_tb(3), Opcode_tb(2), Opcode_tb(1), Opcode_tb(0)) <= (to_unsigned(i,8)); 
	--				wait for 5ns;
	--				
	--				expected:= c_tb;
	--			end loop;
		wait;
	end process stim
end ALUTestBench;
