`timescale 1ns/1ns
`include "define.sv"

module oh2bin #(
	parameter ONE_HOT_WIDTH = 8,
	parameter BIN_WIDTH = 3
)
(
	input  [ONE_HOT_WIDTH-1:0] oh_i,
	output [BIN_WIDTH-1:0] bin_o    
);
  
wire [BIN_WIDTH-1:0]     bin_temp1 [ONE_HOT_WIDTH-1:0];
wire [ONE_HOT_WIDTH-1:0] bin_temp2 [BIN_WIDTH-1:0];
  
genvar i,j,k;
generate
	for(i = 0;i < ONE_HOT_WIDTH;i = i + 1) begin: temp1_loop
		assign bin_temp1[i] = oh_i[i] ? i : 'b0;
	end
endgenerate

generate
	for(i = 0;i < ONE_HOT_WIDTH;i = i + 1) begin: temp2_loop1
		for(j = 0;j < BIN_WIDTH;j= j + 1) begin:temp2_loop2
			assign bin_temp2[j][i] = bin_temp1[i][j];
		end
	end
endgenerate

generate
	for(k = 0;k < BIN_WIDTH;k = k + 1) begin:output_loop
		assign bin_o[k] = |bin_temp2[k];
	end 
endgenerate  
  
endmodule