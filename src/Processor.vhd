									

library IEEE;
use IEEE.std_logic_1164.all;

entity Processor is
	generic (n : integer := 6);
	 port(
		 clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 addr : out STD_LOGIC
	     );
end Processor;																 

architecture Processor of Processor is
	signal count : unsigned (n-1 downto 0);
begin
	addr <= std_logic_vector(count);
	counter: process (clk, rst_bar)
	begin
		if (clk'event and clk='1') then
			if (reset = '1') then
				count <= to_unsigned(0, n);
			else
				count <= count + 1;
			end if;
		end if;
	end process counter;
end Processor;
