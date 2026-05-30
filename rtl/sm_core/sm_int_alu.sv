`timescale 1ns/1ns
`include "../common/define.sv"

module sm_int_alu (
	input  clk,
	input  rst_n,

	// input from issue stage
	input  valid_i,
	input  [`DEPTH_WARP-1:0] wid_i,
	input  [5:0] dst_i,
	input  [`REG_DATA_WIDTH-1:0] src1_data_i,
	input  [`REG_DATA_WIDTH-1:0] src2_data_i,
	input  [5:0] opcode_nb_i,
	input  [5:0] mod_i,

	// output to writeback
	output reg wb_valid_o,
	output reg [`DEPTH_WARP-1:0] wb_wid_o,
	output reg [5:0] wb_dst_o,
	output reg [`REG_DATA_WIDTH-1:0] wb_data_o
);

localparam OPCODE_NB_MOV32I = 6'h06;
localparam OPCODE_NB_MOV    = 6'h0A;
localparam OPCODE_NB_IADD   = 6'h12;
localparam OPCODE_NB_IMUL   = 6'h14;
localparam OPCODE_NB_IDIV   = 6'h16;

reg [`REG_DATA_WIDTH-1:0] alu_result;

always @(*) begin
	case (opcode_nb_i)
		OPCODE_NB_MOV32I: alu_result = src2_data_i;
		OPCODE_NB_MOV:    alu_result = src1_data_i;
		OPCODE_NB_IADD:   alu_result = mod_i[0] ? (src1_data_i - src2_data_i)
		                                         : (src1_data_i + src2_data_i);
		OPCODE_NB_IMUL:   alu_result = src1_data_i * src2_data_i;
		OPCODE_NB_IDIV:   alu_result = (src2_data_i != 0) ? (src1_data_i / src2_data_i)
		                                                   : {`REG_DATA_WIDTH{1'b0}};
		default:          alu_result = {`REG_DATA_WIDTH{1'b0}};
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wb_valid_o <= 1'b0;
		wb_wid_o   <= {`DEPTH_WARP{1'b0}};
		wb_dst_o   <= 6'h0;
		wb_data_o  <= {`REG_DATA_WIDTH{1'b0}};
	end
	else begin
		wb_valid_o <= valid_i;
		wb_wid_o   <= wid_i;
		wb_dst_o   <= dst_i;
		wb_data_o  <= alu_result;
	end
end

endmodule
