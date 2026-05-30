`timescale 1ns/1ns
`include "../common/define.sv"

module sm_issue (
	input  clk,
	input  rst_n,

	// input from operand collect
	input  oc_signals_valid_i,
	input  [`CODE_MEM_DATA_WIDTH-1:0] oc_signals_inst_i,
	input  [`DEPTH_WARP-1:0] oc_signals_wid_i,
	input  [3:0] oc_signals_opcode_na_i,
	input  [5:0] oc_signals_mod_i,
	input  [3:0] oc_signals_pr_i,
	input  [5:0] oc_signals_dst_i,
	input  [`REG_DATA_WIDTH-1:0] oc_signals_src1_data_i,
	input  [`REG_DATA_WIDTH-1:0] oc_signals_src2_data_i,
	input  [19:0] oc_signals_immea_i,
	input  [1:0] oc_signals_space_sel_i,
	input  [9:0] oc_signals_immeb_i,
	input  [5:0] oc_signals_opcode_nb_i,

	// integer ALU dispatch
	output reg int_alu_valid_o,
	output reg [`DEPTH_WARP-1:0] int_alu_wid_o,
	output reg [5:0] int_alu_dst_o,
	output reg [`REG_DATA_WIDTH-1:0] int_alu_src1_data_o,
	output reg [`REG_DATA_WIDTH-1:0] int_alu_src2_data_o,
	output reg [5:0] int_alu_opcode_nb_o,
	output reg [5:0] int_alu_mod_o,

	// warp completion (EXIT instruction)
	output reg sm_warp_rsp_valid_o,
	output reg [`DEPTH_WARP-1:0] sm_warp_rsp_wid_o
);

localparam OPCODE_NB_MOV32I = 6'h06;
localparam OPCODE_NB_MOV    = 6'h0A;
localparam OPCODE_NB_IADD   = 6'h12;
localparam OPCODE_NB_IMUL   = 6'h14;
localparam OPCODE_NB_IDIV   = 6'h16;
localparam OPCODE_NB_EXIT   = 6'h20;

wire is_int_op = (oc_signals_opcode_nb_i == OPCODE_NB_MOV32I) ||
                 (oc_signals_opcode_nb_i == OPCODE_NB_MOV)    ||
                 (oc_signals_opcode_nb_i == OPCODE_NB_IADD)   ||
                 (oc_signals_opcode_nb_i == OPCODE_NB_IMUL)   ||
                 (oc_signals_opcode_nb_i == OPCODE_NB_IDIV);

wire is_exit = (oc_signals_opcode_nb_i == OPCODE_NB_EXIT);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		int_alu_valid_o     <= 1'b0;
		int_alu_wid_o       <= {`DEPTH_WARP{1'b0}};
		int_alu_dst_o       <= 6'h0;
		int_alu_src1_data_o <= {`REG_DATA_WIDTH{1'b0}};
		int_alu_src2_data_o <= {`REG_DATA_WIDTH{1'b0}};
		int_alu_opcode_nb_o <= 6'h0;
		int_alu_mod_o       <= 6'h0;
		sm_warp_rsp_valid_o <= 1'b0;
		sm_warp_rsp_wid_o   <= {`DEPTH_WARP{1'b0}};
	end
	else begin
		int_alu_valid_o     <= oc_signals_valid_i && is_int_op;
		int_alu_wid_o       <= oc_signals_wid_i;
		int_alu_dst_o       <= oc_signals_dst_i;
		int_alu_src1_data_o <= oc_signals_src1_data_i;
		int_alu_src2_data_o <= oc_signals_src2_data_i;
		int_alu_opcode_nb_o <= oc_signals_opcode_nb_i;
		int_alu_mod_o       <= oc_signals_mod_i;
		sm_warp_rsp_valid_o <= oc_signals_valid_i && is_exit;
		sm_warp_rsp_wid_o   <= oc_signals_wid_i;
	end
end

endmodule
