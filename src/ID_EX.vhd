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
	 port(
	 	 CLK : in STD_LOGIC;  
	 	 rst: in std_logic;
		 rs1_In : in STD_LOGIC_VECTOR(127 downto 0);
		 rs2_In : in STD_LOGIC_VECTOR(127 downto 0);
		 rs3_In : in STD_LOGIC_VECTOR(127 downto 0);
		 Ins_In : in STD_LOGIC_VECTOR(24 downto 0);
		 Ins_Out : out STD_LOGIC_VECTOR(24 downto 0);
		 rs1_Out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs2_Out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs3_Out : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end ID_EX;

--}} End of automatically maintained section

architecture behavior of ID_EX is
begin
	process(CLK, rst)
	begin 
		if rst = '1' then 
			Ins_Out <= std_logic_vector(to_unsigned(0, 25)); 
			rs1_Out <= std_logic_vector(to_unsigned(0, 128));
			rs2_Out <= std_logic_vector(to_unsigned(0, 128));
			rs3_Out <= std_logic_vector(to_unsigned(0, 128));
	 	elsif rising_edge(CLK)	then 
			 Ins_Out <= Ins_In;
			 rs1_Out <= rs1_In;
			 rs2_Out <= rs2_In;
			 rs3_Out <= rs3_In;
		end if;
	end process;
end behavior;
