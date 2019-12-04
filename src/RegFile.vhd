-------------------------------------------------------------------------------
--
-- Title       : RegFile
-- Design      : SIMD_Multimedia_Unit
-- Author      : Brian Eng
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Ese_345\SIMD_Multimedia_Unit\src\RegFile.vhd
-- Generated   : Sat Nov 30 17:23:49 2019
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
--{entity {RegFile} architecture {RegFile}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity RegFile is
	generic (
		n : positive := 6;
		NUM_REGISTERS : positive := 32;
		INSTR_WIDTH : positive := 25;
		LOG_NUM_REG : positive := 5;
		REG_WIDTH : positive := 128;
		ALU_OP_WIDTH : positive := 10;
		R3_OPCODE_WIDTH : positive := 8
	);
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		rs1_sel : in STD_LOGIC_VECTOR(LOG_NUM_REG-1 downto 0);
		rs2_sel : in STD_LOGIC_VECTOR(LOG_NUM_REG-1 downto 0);
		rs3_sel : in STD_LOGIC_VECTOR(LOG_NUM_REG-1 downto 0);
		write_data : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		write_enable: in STD_LOGIC;
		write_sel : in STD_LOGIC_VECTOR(LOG_NUM_REG-1 downto 0);
		rs1_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rs2_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
		rs3_out : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0)
	);
end RegFile;


architecture behavior of RegFile is	 
	type RegisterFile is array (0 to NUM_REGISTERS-1) of STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
	signal registers  : RegisterFile;
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			for i in 0 to NUM_REGISTERS-1 loop
				registers(i) <= std_logic_vector(to_unsigned(0, REG_WIDTH));
			end loop;
		elsif rising_edge(clk) then
-- Reading the registers selected before bypassing
			rs1_out <= registers(to_integer(unsigned(rs1_sel)));
			rs2_out <= registers(to_integer(unsigned(rs2_sel)));
			rs3_out <= registers(to_integer(unsigned(rs3_sel)));
			
--Write to registers  
--Not sure if Enable is needed
		if write_enable = '1' then
			registers(to_integer(unsigned(write_sel))) <= write_data;
--bypassing rs1
			if (write_sel = rs1_sel) then
				rs1_out <= write_data;
			end if;
--bypassing rs2			
			if (write_sel = rs2_sel) then
				rs2_out <= write_data;
			end if;
--bypassing rs3			
			if (write_sel = rs3_sel) then
				rs3_out <= write_data;
			end if;	
		end if;
end if;
end process;
end behavior;
