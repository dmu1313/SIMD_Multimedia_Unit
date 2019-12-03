-------------------------------------------------------------------------------
--
-- Title       : EX_WB
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\EX_WB.vhd
-- Generated   : Sun Dec  1 19:21:32 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--


library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity EX_WB is
	generic (
		INSTR_WIDTH : positive := 25;
		REG_WIDTH : positive := 128
	);
	port(
		clk : in STD_LOGIC;
		Ins_In : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
		rd_In : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rst : in std_logic;
		Ins_Out : out STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
		rd_Out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0)
	);
end EX_WB;

architecture behavior of EX_WB is
	signal pipeline_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
	signal pipeline_rd : std_logic_vector(REG_WIDTH-1 downto 0);
begin
	process(clk, rst)
	begin
		if rst = '1' then 
			Ins_Out <= std_logic_vector(to_unsigned(0, INSTR_WIDTH));
			rd_Out <= std_logic_vector(to_unsigned(0, REG_WIDTH));

			pipeline_instr <= std_logic_vector(to_unsigned(0, INSTR_WIDTH));
			pipeline_rd <= std_logic_vector(to_unsigned(0, REG_WIDTH));
		elsif rising_edge(clk) then
			Ins_Out <= pipeline_instr;
			rd_Out <= pipeline_rd;

			pipeline_instr <= Ins_In;
			pipeline_rd <= rd_In;
		end if;
   end process;
end behavior;
