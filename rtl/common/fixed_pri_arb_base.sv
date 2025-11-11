`timescale 1ns/1ns
`include "define.sv"

module fixed_pri_arb_base #(
	parameter ARB_WIDTH = 8
)
(
	input  [ARB_WIDTH-1:0] req_i ,
	input  [ARB_WIDTH-1:0] pri_i ,
	output [ARB_WIDTH-1:0] grant_o
);

wire [2*ARB_WIDTH-1:0] double_grant;

assign double_grant = {req_i,req_i} & ~({req_i,req_i}-pri_i);
assign grant_o = double_grant[2*ARB_WIDTH-1:ARB_WIDTH] | double_grant[ARB_WIDTH-1:0];

endmodule