									

library IEEE;
use IEEE.std_logic_1164.all;

entity Processor is
	generic (n : positive := 6);
	port(
			clk : in std_logic;
			reset : in std_logic;
			load : in std_logic;
		);
end Processor;																 

architecture Processor of Processor is
	signal addr : std_logic_vector (n-1 downto 0);
begin
	u1: entity Program_Counter port map(clk=>clk, reset=>reset, addr=>addr);

	u2: entity Instruction_Buffer port map(clk=>clk, load=>load, d=>freq_val, q=>step);

	u3: entity phase_accumulator port map(clk=>clk, reset_bar=>reset_bar, up=>up, d=>step, max=>max, min=>min, q=>address);

	u4: entity phase_accumulator_fsm port map(clk=>clk, reset_bar=>reset_bar, max=>max, min=>min, up=>up, pos=>pos);

	u5: entity sine_table port map(addr=>address, sine_val=>sine_value);

	u6: entity adder_subtracter port map(pos=>pos, sine_value=>sine_value, dac_sine_val=>sine_output);

	u7: entity sq_accumulator port map(clk=>clk, reset_bar=>reset_bar, d=>step, q=>square_output);

	u8: entity tri_accumulator port map(clk=>clk, reset_bar=>reset_bar, d=>step, q=>triangle_output);

	u9: entity mux_4_1 port map(i3=>square_output, i2=>triangle_output, i1=>sine_output, i0=>undefined, s1=>ws1, s0=>ws0, q=>dac_value);


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
