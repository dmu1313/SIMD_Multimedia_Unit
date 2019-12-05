
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
		Ins_In : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
		Ins_Out : out STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0)
	);
end ID_EX;

architecture behavior of ID_EX is
begin
	process(clk, rst)
	begin 
		if rst = '1' then 
			Ins_Out <= b"11_111_11111_00000_00000_00000";--std_logic_vector(to_unsigned(0, INSTR_WIDTH)); 
	 	elsif rising_edge(clk)	then
			Ins_Out <= Ins_In;
		end if;
	end process;
end behavior;
