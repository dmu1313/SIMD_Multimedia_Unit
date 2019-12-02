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
	 port(
		 CLK : in STD_LOGIC;
		 PC_In : in STD_LOGIC_VECTOR(5 downto 0);
		 Instruction_code : out STD_LOGIC_VECTOR(25 downto 0);
		 PC_Out : out STD_LOGIC_VECTOR(5 downto 0)
	     );
end Instruction_Buffer;

--}} End of automatically maintained section

architecture behavior of Instruction_Buffer is	 
	signal PC: std_logic_vector(5 downto 0):= "000000";
begin
	
	
	
	
	
	
	
	
	
end behavior;
