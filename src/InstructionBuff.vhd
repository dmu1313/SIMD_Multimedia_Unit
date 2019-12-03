-------------------------------------------------------------------------------
--
-- Title       : Instruction_Buffer
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\InstructionBuff.vhd
-- Generated   : Sat Nov 30 18:05:02 2019
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
--{entity {Instruction_Buffer} architecture {Instruction_Buffer}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Buffer is
	generic (
		n : positive := 6,
		INSTR_BUF_SIZE : positive := 64,
		INSTR_WIDTH : positive := 25
	);
	port(
		clk : in STD_LOGIC;
		load : in STD_LOGIC;
		PC_In : in STD_LOGIC_VECTOR(n-1 downto 0);
		instruction_in : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
		instruction_out : out STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0)
	);
end Instruction_Buffer;

--}} End of automatically maintained section

architecture behavior of Instruction_Buffer is
	type InstructionBuffer is array (0 to INSTR_BUF_SIZE) of STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
	signal instr_buffer : InstructionBuffer;
begin
	loading: process(clk) begin
		if (rising_edge(clk)) then
			if (load = '1') then
				instr_buffer(to_integer(unsigned(PC_In))) <= instruction_in;
			end if;					  
		end if;
	end process loading;

	outputting: process(clk) begin
		if (rising_edge(clk)) then
			instruction_out <= instr_buffer(to_integer(unsigned(PC_In)));
		end if;
	end process outputting;	
end behavior;
