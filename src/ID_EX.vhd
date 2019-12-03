-------------------------------------------------------------------------------
--
-- Title       : ID_EX
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\ID_EX.vhd
-- Generated   : Sun Dec  1 19:14:48 2019
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
--{entity {ID_EX} architecture {ID_EX}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity ID_EX is
	generic (
		INSTR_WIDTH : positive := 25;
		REG_WIDTH : positive := 128
	);
	port(
		clk : in STD_LOGIC;  
		rst: in std_logic;
		rs1_In : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rs2_In : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rs3_In : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		Ins_In : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
		Ins_Out : out STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
		rs1_Out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rs2_Out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rs3_Out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0)
	);
end ID_EX;

architecture behavior of ID_EX is
	signal pipeline_instr : std_logic_vector(INSTR_WIDTH-1 downto 0);
	signal pipeline_rs1 : std_logic_vector(REG_WIDTH-1 downto 0);
	signal pipeline_rs2 : std_logic_vector(REG_WIDTH-1 downto 0);
	signal pipeline_rs3 : std_logic_vector(REG_WIDTH-1 downto 0);
begin
	process(clk, rst)
	begin 
		if rst = '1' then 
			Ins_Out <= std_logic_vector(to_unsigned(0, INSTR_WIDTH)); 
			rs1_Out <= std_logic_vector(to_unsigned(0, REG_WIDTH));
			rs2_Out <= std_logic_vector(to_unsigned(0, REG_WIDTH));
			rs3_Out <= std_logic_vector(to_unsigned(0, REG_WIDTH));

			pipeline_instr <= std_logic_vector(to_unsigned(0, INSTR_WIDTH)); 
			pipeline_rs1 <= std_logic_vector(to_unsigned(0, REG_WIDTH));
			pipeline_rs2 <= std_logic_vector(to_unsigned(0, REG_WIDTH));
			pipeline_rs3 <= std_logic_vector(to_unsigned(0, REG_WIDTH));
	 	elsif rising_edge(clk)	then
			Ins_Out <= pipeline_instr;
			rs1_Out <= pipeline_rs1;
			rs2_Out <= pipeline_rs2;
			rs3_Out <= pipeline_rs3;

			pipeline_instr <= Ins_In; 
			pipeline_rs1 <= rs1_In;
			pipeline_rs2 <= rs2_In;
			pipeline_rs3 <= rs3_In;
		end if;
	end process;
end behavior;
