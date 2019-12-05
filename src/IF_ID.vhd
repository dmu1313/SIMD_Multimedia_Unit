
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
begin
	process(clk, rst)
	begin
		if rst = '1' then
			Ins_Out <= std_logic_vector(to_unsigned(0, INSTR_WIDTH));
		elsif rising_edge(clk)	then
			Ins_Out <= Ins_In;
		end if;
   end process;
end behavior;
