


library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity Forwarding_Unit is 
	generic (
		REG_SEL : positive := 5;
		REG_WIDTH: positive := 128
	);
	port(
		op : in STD_LOGIC_VECTOR(1 downto 0);
		rd_sel : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		rs1_sel : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		rs2_sel : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		rs3_sel : in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);

		rd_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs1_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs2_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs3_in: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);

		rs2_is_immediate : in std_logic;

		wr_en_rd : in STD_LOGIC;
		rd_wb_sel: in STD_LOGIC_VECTOR(REG_SEL -1 downto 0);
		data_foward: in STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0); 
		
		rs1_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs2_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rs3_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);
		rd_out: out STD_LOGIC_VECTOR(REG_WIDTH -1 downto 0);

		-- These are used by processor top level test bench to print to a file when a forwarding event occurs
		forwarding_event_occurred : out std_logic;
		forwarded_reg : out std_logic_vector(REG_SEL-1 downto 0)
	);
end Forwarding_Unit;

architecture behavior of Forwarding_Unit is
begin  
	process(all) 
	begin
		forwarded_reg <= rd_wb_sel;

		if (wr_en_rd = '1' and rd_wb_sel = rs1_sel and (op = "10" or op = "11")) then
			forwarding_event_occurred <= '1';

			rs1_out <= data_foward;
			rs2_out <= rs2_in;
			rs3_out <= rs3_in;
			rd_out <= rd_in;
		elsif(rs2_is_immediate='0' and wr_en_rd = '1' and rd_wb_sel = rs2_sel and (op = "10" or op = "11")) then
			forwarding_event_occurred <= '1';

			rs1_out <= rs1_in;
			rs2_out <= data_foward;
			rs3_out <= rs3_in;
			rd_out <= rd_in;
		elsif(wr_en_rd = '1' and rd_wb_sel = rs3_sel and op = "10") then
			forwarding_event_occurred <= '1';

			rs1_out <= rs1_in;
			rs2_out <= rs2_in;
			rs3_out <= data_foward;
			rd_out <= rd_in;
		elsif(wr_en_rd = '1' and rd_wb_sel = rd_sel and op(1) = '0')	then
			forwarding_event_occurred <= '1';
			
			rs1_out <= rs1_in;
			rs2_out <= rs2_in;
			rs3_out <= rs3_in;
			rd_out <= data_foward;
		else
			forwarding_event_occurred <= '0';

			rs1_out <= rs1_in;
			rs2_out <= rs2_in;
			rs3_out <= rs3_in;
			rd_out <= rd_in;
		end if;	
	end process;
end	behavior;




















