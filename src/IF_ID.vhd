-------------------------------------------------------------------------------
--
-- Title       : IF_ID
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\IF_ID.vhd
-- Generated   : Sun Dec  1 19:00:03 2019
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
--{entity {IF_ID} architecture {IF_ID}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity IF_ID is
	generic (
		INSTR_WIDTH : positive := 25
	);
	 port(
			clk : in STD_LOGIC;
			rst: in STD_LOGiC;
			Ins_In : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
			Ins_Out : out STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0)
		);
end IF_ID;

architecture behavior of IF_ID is
	signal pipeline_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
begin
	process(clk, rst)
	begin
		if rst = '1' then
			Ins_Out <= std_logic_vector(to_unsigned(0, INSTR_WIDTH));
			pipeline_instr <= std_logic_vector(to_unsigned(0, INSTR_WIDTH));
		elsif rising_edge(clk)	then
			Ins_Out <= pipeline_instr;
			pipeline_instr <= Ins_In;
		end if;
   end process;
end behavior;
