`timescale 1ns/1ns
`include "define.sv"

module sync_fifo_count #(
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
	output full_o,	                                           // fifo full flag
	output reg [$clog2(FIFO_DEPTH):0] fifo_count_o            // fifo count
);

reg [DATA_WIDTH-1:0] fifo_data [FIFO_DEPTH-1:0];
reg [$clog2(FIFO_DEPTH)-1:0] rd_addr;
reg [$clog2(FIFO_DEPTH)-1:0] wr_addr;


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
      rd_addr <= 'd0;
    end
    else if(rd_en_i && !empty_o) begin
		rd_data_o <= fifo_data[rd_addr];
      rd_addr <= rd_addr + 1;
    end
    else begin
      rd_addr <= rd_addr;
    end

end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
      wr_addr <= 'd0;
		fifo_data <='{default:'h0};
    end
    else if(wr_en_i && !full_o) begin
		fifo_data[wr_addr] <= wr_data_i;
      wr_addr <= wr_addr + 1;
    end
    else begin
      wr_addr <= wr_addr;
    end

end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
      fifo_count_o <= 0;
    end
    else begin
      case ({rd_en_i, wr_en_i})
			2'b00:fifo_count_o <= fifo_count_o;
			2'b10:
				if (fifo_count_o != 0)
					fifo_count_o <= fifo_count_o-1;
			2'b01:
				if (fifo_count_o != FIFO_DEPTH)
					fifo_count_o <= fifo_count_o+1;
			2'b11:fifo_count_o <= fifo_count_o;
			default:fifo_count_o <= fifo_count_o;
		endcase
    end

end

assign empty_o = (fifo_count_o == 0)?1'b1:1'b0;
assign full_o = (fifo_count_o == FIFO_DEPTH)?1'b1:1'b0;

endmodule