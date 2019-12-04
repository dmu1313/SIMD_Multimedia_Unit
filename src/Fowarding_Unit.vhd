


library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity Forwarding_Unit is
	port(
		rd : in STD_LOGIC_VECTOR(4 downto 0);
		rs1 : in STD_LOGIC_VECTOR(4 downto 0);
		rs2 : in STD_LOGIC_VECTOR(4 downto 0);
		rs3 : in STD_LOGIC_VECTOR(4 downto 0);
		c : out STD_LOGIC_VECTOR(127 downto 0)
	);
end Forwarding_Unit;

architecture behavior of Forwarding_Unit is
begin
end




















