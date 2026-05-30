`timescale 1ns/1ns
`include "../common/define.sv"

module sm_writeback (
	input  clk,
	input  rst_n,

	// input from integer ALU
	input  int_alu_wb_valid_i,
	input  [`DEPTH_WARP-1:0] int_alu_wb_wid_i,
	input  [5:0] int_alu_wb_dst_i,
	input  [`REG_DATA_WIDTH-1:0] int_alu_wb_data_i,

	// output to register file (scoreboard + operand collect)
	output reg wb_valid_o,
	output reg [`DEPTH_WARP-1:0] wb_wid_o,
	output reg [5:0] wb_dst_o,
	output reg [`REG_DATA_WIDTH-1:0] wb_data_o
);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wb_valid_o <= 1'b0;
		wb_wid_o   <= {`DEPTH_WARP{1'b0}};
		wb_dst_o   <= 6'h0;
		wb_data_o  <= {`REG_DATA_WIDTH{1'b0}};
	end
	else begin
		wb_valid_o <= int_alu_wb_valid_i;
		wb_wid_o   <= int_alu_wb_wid_i;
		wb_dst_o   <= int_alu_wb_dst_i;
		wb_data_o  <= int_alu_wb_data_i;
	end
end

endmodule
