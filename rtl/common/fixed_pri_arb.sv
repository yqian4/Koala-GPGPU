`timescale 1ns/1ns
`include "define.sv"

module fixed_pri_arb #(
	parameter ARB_WIDTH = 8
)
(
	input  [ARB_WIDTH-1:0] req_i ,
	output [ARB_WIDTH-1:0] grant_o
);

wire [ARB_WIDTH-1:0] pre_req;

assign pre_req[0] = 1'b0;
assign pre_req[ARB_WIDTH-1:1] = req_i[ARB_WIDTH-2:0] | pre_req[ARB_WIDTH-2:0];
assign grant_o = req_i & (~pre_req);

endmodule