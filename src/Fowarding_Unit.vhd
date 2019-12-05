


library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity Forwarding_Unit is 
		generic (
		REG_SEL : positive := 5;
		REG_WIDTH: positive := 128
	);
	port( 
		op_ex : in STD_LOGIC_VECTOR(1 downto 0);
		rd_ex : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
	 	rs1_ex : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		rs2_ex : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		rs3_ex : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);	
		rd_wb: in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		rd_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs1_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs2_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs3_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		data_foward: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0); 
		rs1_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs2_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs3_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rd_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0)
	     );
end Forwarding_Unit;

architecture behavior of Forwarding_Unit is
begin  
	process(all) 
	   begin
	if (rd_wb = rs1_ex and (op_ex = "10" or op_ex = "11")) then
		rs1_out <= data_foward;
		rs2_out <= rs2_in;
		rs3_out <= rs3_in;
		rd_out <= rd_in;
	elsif(rd_wb = rs2_ex and (op_ex = "10" or op_ex = "11")) then
		rs1_out <= rs1_in;
		rs2_out <= data_foward;
		rs3_out <= rs3_in;
		rd_out <= rd_in;
	elsif(rd_wb = rs3_ex and op_ex = "10") then
		rs1_out <= rs1_in;
		rs2_out <= rs2_in;
		rs3_out <= data_foward;
		rd_out <= rd_in;
	elsif(rd_wb = rd_ex and op_ex(1) = '0')	then
		rs1_out <= rs1_in;
		rs2_out <= rs2_in;
		rs3_out <= rs3_in;
		rd_out <= data_foward;
	else 
		rs1_out <= rs1_in;
		rs2_out <= rs2_in;
		rs3_out <= rs3_in;
		rd_out <= rd_in;
		
	end if;	
	end process;
end	behavior;




















