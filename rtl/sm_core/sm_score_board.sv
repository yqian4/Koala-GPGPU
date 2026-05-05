`timescale 1ns/1ns
`include "../common/define.sv"

module sm_score_board (
	input  clk,
	input  rst_n,

	// input from instruction buffer
	input  ibuffer_signals_valid_i,
	input  [`CODE_MEM_DATA_WIDTH-1:0] ibuffer_signals_inst_i,
	input  [`DEPTH_WARP-1:0] ibuffer_signals_wid_i,
	input  [3:0] ibuffer_signals_opcode_na_i,
	input  [5:0] ibuffer_signals_mod_i,
	input  [3:0] ibuffer_signals_pr_i,
	input  [5:0] ibuffer_signals_dst_i,
	input  [5:0] ibuffer_signals_src1_i,
	input  [19:0] ibuffer_signals_immea_i,
	input  [1:0] ibuffer_signals_space_sel_i,
	input  [9:0] ibuffer_signals_immeb_i,
	input  [5:0] ibuffer_signals_opcode_nb_i,

	// writeback completion to clear in-flight registers
	input  wb_valid_i,
	input  [`DEPTH_WARP-1:0] wb_wid_i,
	input  [5:0] wb_dst_i,

	// output to operand collect
	output sb_signals_valid_o,
	output [`CODE_MEM_DATA_WIDTH-1:0] sb_signals_inst_o,
	output [`DEPTH_WARP-1:0] sb_signals_wid_o,
	output [3:0] sb_signals_opcode_na_o,
	output [5:0] sb_signals_mod_o,
	output [3:0] sb_signals_pr_o,
	output [5:0] sb_signals_dst_o,
	output [5:0] sb_signals_src1_o,
	output [19:0] sb_signals_immea_o,
	output [1:0] sb_signals_space_sel_o,
	output [9:0] sb_signals_immeb_o,
	output [5:0] sb_signals_opcode_nb_o,

	// stalled warps bitmap to fetch stage
	output [`NUM_WARP-1:0] stalled_warps_o
);

// per-warp in-flight destination register tracking
// each warp has a 64-bit bitmap (6-bit register address -> 64 registers)
reg [`NUM_REG-1:0] inflight_regs [`NUM_WARP-1:0];

wire [5:0] src1 = ibuffer_signals_src1_i;
wire [5:0] src2 = ibuffer_signals_immea_i[5:0]; // src2 is in bits [31:26] of instruction, mapped to immea[5:0]
wire [5:0] dst  = ibuffer_signals_dst_i;
wire [`DEPTH_WARP-1:0] wid = ibuffer_signals_wid_i;

// space_sel == 2'b00 means src2 is a register operand
wire src2_is_reg = (ibuffer_signals_space_sel_i == 2'b00);

// check for RAW hazards: source registers conflict with in-flight destinations
wire src1_hazard = inflight_regs[wid][src1];
wire src2_hazard = src2_is_reg && inflight_regs[wid][src2];
wire has_hazard  = ibuffer_signals_valid_i && (src1_hazard || src2_hazard);

// issue the instruction only when there is no hazard
wire issue_valid = ibuffer_signals_valid_i && !has_hazard;

// generate stalled_warps bitmap
genvar w;
generate
	for (w = 0; w < `NUM_WARP; w = w + 1) begin: stall_check
		assign stalled_warps_o[w] = (|inflight_regs[w]);
	end
endgenerate

// update in-flight register tracking
integer i;
always @(posedge clk or negedge rst_n) begin
	for (i = 0; i < `NUM_WARP; i = i + 1) begin
		if (!rst_n) begin
			inflight_regs[i] <= {`NUM_REG{1'b0}};
		end
		else begin
			if (issue_valid && (i == wid) && wb_valid_i && (i == wb_wid_i))
				inflight_regs[i] <= (inflight_regs[i] | ({{(`NUM_REG-1){1'b0}}, 1'b1} << dst)) & ~({{(`NUM_REG-1){1'b0}}, 1'b1} << wb_dst_i);
			else if (issue_valid && (i == wid))
				inflight_regs[i] <= inflight_regs[i] | ({{(`NUM_REG-1){1'b0}}, 1'b1} << dst);
			else if (wb_valid_i && (i == wb_wid_i))
				inflight_regs[i] <= inflight_regs[i] & ~({{(`NUM_REG-1){1'b0}}, 1'b1} << wb_dst_i);
		end
	end
end

// pass-through signals to operand collect
assign sb_signals_valid_o      = issue_valid;
assign sb_signals_inst_o       = ibuffer_signals_inst_i;
assign sb_signals_wid_o        = ibuffer_signals_wid_i;
assign sb_signals_opcode_na_o  = ibuffer_signals_opcode_na_i;
assign sb_signals_mod_o        = ibuffer_signals_mod_i;
assign sb_signals_pr_o         = ibuffer_signals_pr_i;
assign sb_signals_dst_o        = ibuffer_signals_dst_i;
assign sb_signals_src1_o       = ibuffer_signals_src1_i;
assign sb_signals_immea_o      = ibuffer_signals_immea_i;
assign sb_signals_space_sel_o  = ibuffer_signals_space_sel_i;
assign sb_signals_immeb_o      = ibuffer_signals_immeb_i;
assign sb_signals_opcode_nb_o  = ibuffer_signals_opcode_nb_i;

endmodule
