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
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {EX_WB} architecture {EX_WB}}

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity EX_WB is
	 port(
	 	 CLK : in STD_LOGIC;
	 	 Ins_In : in STD_LOGIC_VECTOR(24 downto 0);
		 Ins_Out : out STD_LOGIC_VECTOR(24 downto 0);
		 rd_In : in STD_LOGIC_VECTOR(127 downto 0);	
		 rst : in std_logic;
		 rd_Out : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end EX_WB;

--}} End of automatically maintained section

architecture behavior of EX_WB is
begin
	process(CLK, rst)
	begin
		if rst = '1' then 
			Ins_Out <= std_logic_vector(to_unsigned(0, 25)); 
			rd_Out <= std_logic_vector(to_unsigned(0, 128));
		elsif rising_edge(CLK) then
			rd_Out <= rd_In;
		end if;
   end process;
end behavior;
