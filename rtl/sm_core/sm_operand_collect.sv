`timescale 1ns/1ns
`include "../common/define.sv"

module sm_operand_collect (
	input  clk,
	input  rst_n,

	// input from scoreboard
	input  sb_signals_valid_i,
	input  [`CODE_MEM_DATA_WIDTH-1:0] sb_signals_inst_i,
	input  [`DEPTH_WARP-1:0] sb_signals_wid_i,
	input  [3:0] sb_signals_opcode_na_i,
	input  [5:0] sb_signals_mod_i,
	input  [3:0] sb_signals_pr_i,
	input  [5:0] sb_signals_dst_i,
	input  [5:0] sb_signals_src1_i,
	input  [19:0] sb_signals_immea_i,
	input  [1:0] sb_signals_space_sel_i,
	input  [9:0] sb_signals_immeb_i,
	input  [5:0] sb_signals_opcode_nb_i,

	// writeback port for register file update
	input  wb_valid_i,
	input  [`DEPTH_WARP-1:0] wb_wid_i,
	input  [5:0] wb_dst_i,
	input  [`REG_DATA_WIDTH-1:0] wb_data_i,

	// output to issue stage
	output reg oc_signals_valid_o,
	output reg [`CODE_MEM_DATA_WIDTH-1:0] oc_signals_inst_o,
	output reg [`DEPTH_WARP-1:0] oc_signals_wid_o,
	output reg [3:0] oc_signals_opcode_na_o,
	output reg [5:0] oc_signals_mod_o,
	output reg [3:0] oc_signals_pr_o,
	output reg [5:0] oc_signals_dst_o,
	output reg [`REG_DATA_WIDTH-1:0] oc_signals_src1_data_o,
	output reg [`REG_DATA_WIDTH-1:0] oc_signals_src2_data_o,
	output reg [19:0] oc_signals_immea_o,
	output reg [1:0] oc_signals_space_sel_o,
	output reg [9:0] oc_signals_immeb_o,
	output reg [5:0] oc_signals_opcode_nb_o
);

// per-warp register file: NUM_WARP banks x NUM_REG registers x REG_DATA_WIDTH bits
reg [`REG_DATA_WIDTH-1:0] reg_file [`NUM_WARP-1:0][`NUM_REG-1:0];

wire [5:0] src1_addr = sb_signals_src1_i;
wire [5:0] src2_addr = sb_signals_immea_i[5:0];
wire [`DEPTH_WARP-1:0] wid = sb_signals_wid_i;

// register file read
wire [`REG_DATA_WIDTH-1:0] src1_data = reg_file[wid][src1_addr];
wire [`REG_DATA_WIDTH-1:0] src2_data = reg_file[wid][src2_addr];

// resolve operand 2 based on space selector
// 2'b00: register (src2), 2'b01: constant, 2'b11: immediate
wire [`REG_DATA_WIDTH-1:0] operand2;
assign operand2 = (sb_signals_space_sel_i == 2'b00) ? src2_data :
                  (sb_signals_space_sel_i == 2'b11) ? {{(`REG_DATA_WIDTH-20){1'b0}}, sb_signals_immea_i} :
                  {`REG_DATA_WIDTH{1'b0}};

// register file write
integer w, r;
always @(posedge clk or negedge rst_n) begin
	for (w = 0; w < `NUM_WARP; w = w + 1) begin
		for (r = 0; r < `NUM_REG; r = r + 1) begin
			if (!rst_n) begin
				reg_file[w][r] <= {`REG_DATA_WIDTH{1'b0}};
			end
			else if (wb_valid_i && (w == wb_wid_i) && (r == wb_dst_i)) begin
				reg_file[w][r] <= wb_data_i;
			end
		end
	end
end

// pipeline register: latch read data and control signals
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		oc_signals_valid_o      <= 1'b0;
		oc_signals_inst_o       <= {`CODE_MEM_DATA_WIDTH{1'b0}};
		oc_signals_wid_o        <= {`DEPTH_WARP{1'b0}};
		oc_signals_opcode_na_o  <= 4'h0;
		oc_signals_mod_o        <= 6'h0;
		oc_signals_pr_o         <= 4'h0;
		oc_signals_dst_o        <= 6'h0;
		oc_signals_src1_data_o  <= {`REG_DATA_WIDTH{1'b0}};
		oc_signals_src2_data_o  <= {`REG_DATA_WIDTH{1'b0}};
		oc_signals_immea_o      <= 20'h0;
		oc_signals_space_sel_o  <= 2'b00;
		oc_signals_immeb_o      <= 10'h0;
		oc_signals_opcode_nb_o  <= 6'h0;
	end
	else begin
		oc_signals_valid_o      <= sb_signals_valid_i;
		oc_signals_inst_o       <= sb_signals_inst_i;
		oc_signals_wid_o        <= sb_signals_wid_i;
		oc_signals_opcode_na_o  <= sb_signals_opcode_na_i;
		oc_signals_mod_o        <= sb_signals_mod_i;
		oc_signals_pr_o         <= sb_signals_pr_i;
		oc_signals_dst_o        <= sb_signals_dst_i;
		oc_signals_src1_data_o  <= src1_data;
		oc_signals_src2_data_o  <= operand2;
		oc_signals_immea_o      <= sb_signals_immea_i;
		oc_signals_space_sel_o  <= sb_signals_space_sel_i;
		oc_signals_immeb_o      <= sb_signals_immeb_i;
		oc_signals_opcode_nb_o  <= sb_signals_opcode_nb_i;
	end
end

endmodule
