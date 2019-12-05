									

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Processor is
	generic (
		n : positive := 6;
		INSTR_BUF_SIZE : positive := 64;
		INSTR_WIDTH : positive := 25;
		LOG_NUM_REG : positive := 5;
		REG_WIDTH : positive := 128;
		ALU_OP_WIDTH : positive := 10;
		R3_OPCODE_WIDTH : positive := 8
	);
	port(
			clk : in std_logic;
			reset : in std_logic;
			load : in std_logic;
			instruction_in : in std_logic_vector(INSTR_WIDTH-1 downto 0)

		);
end Processor;

architecture Processor of Processor is			  
	constant NOP_BINARY : std_logic_vector(INSTR_WIDTH-1 downto 0) := b"1_1000_0000_0000_0000_0000_0000";

	signal addr : std_logic_vector (n-1 downto 0);
	signal instruction_out : std_logic_vector(INSTR_WIDTH-1 downto 0);
	signal IF_ID_instr_out : std_logic_vector(INSTR_WIDTH-1 downto 0);
	signal rs1_sel, rs2_sel, rs3_sel : std_logic_vector(LOG_NUM_REG-1 downto 0);
	signal rs1_out, rs2_out, rs3_out : std_logic_vector(REG_WIDTH-1 downto 0);

	signal write_data : std_logic_vector(REG_WIDTH-1 downto 0);
	signal write_enable : std_logic;
	signal write_sel : std_logic_vector(LOG_NUM_REG-1 downto 0);

	signal ID_EX_instr_out : std_logic_vector(INSTR_WIDTH-1 downto 0);
	signal ID_EX_rs1_out : std_logic_vector(REG_WIDTH-1 downto 0);
	signal ID_EX_rs2_out : std_logic_vector(REG_WIDTH-1 downto 0);
	signal ID_EX_rs3_out : std_logic_vector(REG_WIDTH-1 downto 0);

	signal ALU_rs1_in, ALU_rs2_in, ALU_rs3_in, ALU_rd_in : std_logic_vector(REG_WIDTH-1 downto 0);
	signal ALU_opcode : std_logic_vector(ALU_OP_WIDTH-1 downto 0);
	signal ALU_out : std_logic_vector(REG_WIDTH-1 downto 0);

	signal EX_WB_instr_out : std_logic_vector(INSTR_WIDTH-1 downto 0);
	signal EX_WB_instr_out_r3_op : unsigned(R3_OPCODE_WIDTH-1 downto 0);

	signal rs2_in_forward_unit : std_logic_vector(REG_WIDTH-1 downto 0);
	signal rs2_is_immediate : std_logic;

begin
	u1: entity Program_Counter port map(clk=>clk, reset=>reset, addr=>addr);

	u2: entity Instruction_Buffer port map(
			clk=>clk, load=>load, PC_In=>addr, instruction_in=>instruction_in, instruction_out=>instruction_out);

	u3: entity IF_ID port map(clk=>clk, rst=>reset, Ins_In=>instruction_out, Ins_Out=>IF_ID_instr_out);

	rs_sel: process(all)
	begin
		if (IF_ID_instr_out(24) = '0') then
			-- load immediate so read rd into rs1.
			rs1_sel <= IF_ID_instr_out(4 downto 0);
		else
			rs1_sel <= IF_ID_instr_out(9 downto 5);
		end if;

		rs2_sel <= IF_ID_instr_out(14 downto 10);
		rs3_sel <= IF_ID_instr_out(19 downto 15);
	end process rs_sel;

	u4: entity RegFile port map(
			clk=>clk,
			reset=>reset,
			rs1_sel=>rs1_sel, rs2_sel=>rs2_sel, rs3_sel=>rs3_sel,
			write_data=>write_data,
			write_enable=>write_enable,
			write_sel=>write_sel,
			rs1_out=>rs1_out, rs2_out=>rs2_out, rs3_out=>rs3_out
		);

	ID_EX_rs1_out <= rs1_out;
	ID_EX_rs2_out <= rs2_out;
	ID_EX_rs3_out <= rs3_out;

	u5: entity ID_EX port map(
			clk=>clk,
			rst=>reset,
			Ins_In=>IF_ID_instr_out,
			Ins_Out=>ID_EX_instr_out
		);

	alu_inputs: process(all)
	begin
		ALU_opcode <= ID_EX_instr_out(INSTR_WIDTH-1 downto INSTR_WIDTH-10);

		if (ID_EX_instr_out(24) = '0') then
			-- load immediate
			rs2_is_immediate <= '1';
			rs2_in_forward_unit <= std_logic_vector(resize(signed(ID_EX_instr_out(20 downto 5)), ALU_rs2_in'length));
		elsif (ID_EX_instr_out(24 downto 15) = b"11_0000_1111") then
			-- shlhi
			rs2_is_immediate <= '1';
			rs2_in_forward_unit <= std_logic_vector(resize(signed(ID_EX_instr_out(13 downto 10)), ALU_rs2_in'length));
		else
			rs2_is_immediate <= '0';
			rs2_in_forward_unit <= ID_EX_rs2_out;
		end if;
	end process alu_inputs;

	u6: entity ALU port map(
		rs1=>ALU_rs1_in,
		rs2=>ALU_rs2_in,
		rs3=>ALU_rs3_in,
		rd=>ALU_rd_in,
		Opcode=>ALU_opcode,
		c=>ALU_out
	);

	u7: entity EX_WB port map(
		clk=>clk,
		rst=>reset,
		Ins_In=>ID_EX_instr_out,
		rd_In=>ALU_out,
		Ins_Out=>EX_WB_instr_out,
		rd_Out=>write_data
	);

	EX_WB_instr_out_r3_op <= unsigned(EX_WB_instr_out(22 downto 15));
	write_sel <= EX_WB_instr_out(4 downto 0);

	write_enable <= '1' when --(not (EX_WB_instr_out = std_logic_vector(to_unsigned(0, INSTR_WIDTH))) ) and
							(
								(EX_WB_instr_out(24) = '0')
								or (EX_WB_instr_out(24 downto 23) = "10")
								or ((EX_WB_instr_out(24 downto 23) = "11")-- and (not (ID_EX_instr_out = NOP_BINARY))
																			and (EX_WB_instr_out_r3_op < 20)
																			and (EX_WB_instr_out_r3_op > 0))
																											) else
					'0';

	u8: entity Forwarding_Unit port map(
		op=>ID_EX_instr_out(24 downto 23),
		rd_sel=>ID_EX_instr_out(4 downto 0),
		rs1_sel=>ID_EX_instr_out(9 downto 5),
		rs2_sel=>ID_EX_instr_out(14 downto 10),
		rs3_sel=>ID_EX_instr_out(19 downto 15),

		rd_in=>ID_EX_rs1_out,
		rs1_in=>ID_EX_rs1_out,
		rs2_in=>rs2_in_forward_unit,
		rs3_in=>ID_EX_rs3_out,

		rs2_is_immediate=>rs2_is_immediate,

		wr_en_rd=>write_enable,
		rd_wb_sel=>write_sel,
		data_foward=>write_data, 
		
		rs1_out=>ALU_rs1_in,
		rs2_out=>ALU_rs2_in,
		rs3_out=>ALU_rs3_in,
		rd_out=>ALU_rd_in
	);

end Processor;
