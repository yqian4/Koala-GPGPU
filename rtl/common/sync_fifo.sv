`timescale 1ns/1ns
`include "define.sv"

module sync_fifo #(
	parameter DATA_WIDTH = 64,
	parameter FIFO_DEPTH = 4
)
(
	input  clk,                                               // input clock for the system
	input  rst_n,                                             // reset signal, negative active
	
	input  rd_en_i,                                           // fifo read enable signal
	output [DATA_WIDTH-1:0] rd_data_o,                        // read data from fifo
	input  wr_en_i,                                           // fifo write enable signal
	input  [DATA_WIDTH-1:0] wr_data_i,                        // write data to fifo
	output empty_o,                                           // fifo empty flag
	output full_o	                                           // fifo full flag
);

localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

reg [DATA_WIDTH-1:0] fifo_data [FIFO_DEPTH-1:0];
reg [ADDR_WIDTH:0] rd_ptr;
reg [ADDR_WIDTH:0] wr_ptr;

wire [ADDR_WIDTH-1:0] rd_ptr_true;
wire [ADDR_WIDTH-1:0] wr_ptr_true;

wire rd_ptr_msb;
wire wr_ptr_msb;

assign {rd_ptr_msb, rd_ptr_true} = rd_ptr;
assign {wr_ptr_msb, wr_ptr_true} = rd_ptr;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
      rd_ptr <= 'd0;
    end
    else if(rd_en_i && !empty_o) begin
		rd_data_o <= fifo_data[rd_ptr_true];
      rd_ptr <= rd_ptr + 1;
    end
    else begin
      rd_ptr <= rd_ptr;
    end

end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
      wr_ptr <= 'd0;
		fifo_data <='{default:'h0};
    end
    else if(wr_en_i && !full_o) begin
		fifo_data[wr_ptr_true] <= wr_data_i;
      wr_ptr <= wr_ptr + 1;
    end
    else begin
      wr_ptr <= wr_ptr;
    end

end

assign empty_o = (wr_ptr == rd_ptr)?1'b1:1'b0;
assign full_o = ((wr_ptr_msb != rd_ptr_msb) && (wr_ptr_true == rd_ptr_true))?1'b1:1'b0;

endmodule