
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Program_Counter is
	generic (n : integer := 6);
	 port(
		 clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 addr : out STD_LOGIC_VECTOR(n-1 downto 0)
	     );
end Program_Counter;																 

architecture Program_Counter of Program_Counter is
	signal count : unsigned (n-1 downto 0);
begin
	addr <= std_logic_vector(count);
	counter: process (clk, reset)
	begin
		if (clk'event and clk='1') then
			if (reset = '1') then
				count <= to_unsigned(0, n);
			else
				count <= count + 1;
			end if;
		end if;
	end process counter;
end Program_Counter;
