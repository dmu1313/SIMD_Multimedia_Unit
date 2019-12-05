
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
begin
	process(clk, rst)
	begin
		if rst = '1' then 
			Ins_Out <= b"11_111_11111_00000_00000_00000";--std_logic_vector(to_unsigned(0, INSTR_WIDTH));
			rd_Out <= std_logic_vector(to_unsigned(0, REG_WIDTH));
		elsif rising_edge(clk) then
			Ins_Out <= Ins_In;
			rd_Out <= rd_In;
		end if;
   end process;
end behavior;
