`timescale 1ns/1ns
`include "define.sv"

module rr_arb #(
	parameter ARB_WIDTH = 8
)
(
	input  clk,                                               // input clock for the system
	input  rst_n,
	
	input  [ARB_WIDTH-1:0] req_i ,
	output [ARB_WIDTH-1:0] grant_o
);

reg [ARB_WIDTH-1:0] cur_pri;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin      
		cur_pri <= {{(ARB_WIDTH-1){1'b0}},1'b1};
	end 
	else if(|req_i) begin
		cur_pri <= {grant_o[ARB_WIDTH-2:0], grant_o[ARB_WIDTH-1]};
	end 
	else begin      
		cur_pri <= cur_pri;
	end
end



fixed_pri_arb_base #(
  .ARB_WIDTH(ARB_WIDTH)
) arb_base (
  .req_i      (req_i),
  .pri_i      (cur_pri),
  .grant_o    (grant_o)
);

endmodule