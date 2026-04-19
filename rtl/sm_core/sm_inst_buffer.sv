`timescale 1ns/1ns
`include "../common/define.sv"

module sm_inst_buffer #(
	parameter IBUFFER_DATA_WIDTH = 2*`CODE_MEM_DATA_WIDTH+`DEPTH_WARP, 
	parameter IBUFFER_SIZE = 2
)
(
	input  clk,                                                // input clock for the system
	input  rst_n,                                              // reset signal
	 
	input decode_signals_valid_i,                              // valid signal of decode signals	
	input [`CODE_MEM_DATA_WIDTH-1:0] decode_signals_inst_i,    // input decoded instruction 
	input [`DEPTH_WARP-1:0] decode_signals_wid_i,              // input warp id
	input [3:0] decode_signals_opcode_na_i,                    // input opcode na field
	input [5:0] decode_signals_mod_i,                          // input mod field
	input [3:0] decode_signals_pr_i,                           // input pr field
	input [5:0] decode_signals_dst_i,                          // input dst field
	input [5:0] decode_signals_src1_i,                         // input src1 field
	input [19:0] decode_signals_immea_i,                       // input immea field
	input [1:0] decode_signals_space_sel_i,                    // input space_sel field
	input [9:0] decode_signals_immeb_i,                        // input immeb field	
	input [5:0] decode_signals_opcode_nb_i,                    // input opcode nb field

	output [`CODE_MEM_DATA_WIDTH-1:0] ibuffer_signals_inst_o,  // output instruction 
	output [`DEPTH_WARP-1:0] ibuffer_signals_wid_o,            // output warp id
	output [3:0] ibuffer_signals_opcode_na_o,                  // output opcode na field
	output [5:0] ibuffer_signals_mod_o,                        // output mod field
	output [3:0] ibuffer_signals_pr_o,                         // output pr field
	output [5:0] ibuffer_signals_dst_o,                        // output dst field
	output [5:0] ibuffer_signals_src1_o,                       // output src1 field
	output [19:0] ibuffer_signals_immea_o,                     // output immea field
	output [1:0] ibuffer_signals_space_sel_o,                  // output space_sel field
	output [9:0] ibuffer_signals_immeb_o,                      // output immeb field	
	output [5:0] ibuffer_signals_opcode_nb_o,                  // output opcode nb field	
	output ibuffer_signals_valid_o,                            // valid signal of decode signals	
		
	input  [`NUM_WARP-1:0] ready_warps_i,                      // indicate the warps that are ready for instruction fetch
	output [`NUM_WARP-1:0] ibuffer_avail_o                     // instruction buffer available flag
);

wire [`NUM_WARP-1:0] rd_en, wr_en;
wire [`NUM_WARP-1:0] full;
wire [`NUM_WARP-1:0] empty;

wire  [IBUFFER_DATA_WIDTH-1:0] wr_data;
wire  [IBUFFER_DATA_WIDTH-1:0] rd_data[`NUM_WARP-1:0];

wire [`NUM_WARP-1:0] ibuffer_has_data;
wire [`NUM_WARP-1:0] ibuffer_to_issue_oh;
wire [`DEPTH_WARP-1:0] ibuffer_to_issue;

assign rd_en = ibuffer_to_issue_oh;
assign wr_en = (~full[decode_signals_wid_i] && decode_signals_valid_i) ? (`NUM_WARP'b1 << decode_signals_wid_i) : `NUM_WARP'b0;

assign wr_data = 
			{
				decode_signals_inst_i,
				decode_signals_wid_i,
				decode_signals_opcode_nb_i,
				decode_signals_immeb_i,
				decode_signals_space_sel_i,
				decode_signals_immea_i,	
				decode_signals_src1_i,				
				decode_signals_dst_i,				
				decode_signals_pr_i,
				decode_signals_mod_i,
				decode_signals_opcode_na_i				
			};


genvar i; 
generate
	for(i=0;i<`NUM_WARP;i=i+1) begin: inst_buffer_per_warp	
		sync_fifo #(
			.DATA_WIDTH(IBUFFER_DATA_WIDTH),
			.FIFO_DEPTH(IBUFFER_SIZE)
		) U_sync_fifo (
			.clk               (clk),
			.rst_n             (rst_n),
			.rd_en_i           (rd_en[i]),
			.rd_data_o         (rd_data[i]),
			.wr_en_i           (wr_en[i]),
			.wr_data_i         (wr_data),
			.empty_o           (empty[i]),
			.full_o            (full[i])
		);	
	end
endgenerate

assign ibuffer_signals_opcode_na_o = rd_data[ibuffer_to_issue][3:0];
assign ibuffer_signals_mod_o = rd_data[ibuffer_to_issue][9:4];
assign ibuffer_signals_pr_o = rd_data[ibuffer_to_issue][13:10];
assign ibuffer_signals_dst_o = rd_data[ibuffer_to_issue][19:14];			
assign ibuffer_signals_src1_o = rd_data[ibuffer_to_issue][25:20];
assign ibuffer_signals_immea_o = rd_data[ibuffer_to_issue][45:26];
assign ibuffer_signals_space_sel_o = rd_data[ibuffer_to_issue][47:46];
assign ibuffer_signals_immeb_o = rd_data[ibuffer_to_issue][57:48];
assign ibuffer_signals_opcode_nb_o = rd_data[ibuffer_to_issue][63:58];
assign ibuffer_signals_wid_o = rd_data[ibuffer_to_issue][64+:`DEPTH_WARP];	
assign ibuffer_signals_inst_o = rd_data[ibuffer_to_issue][IBUFFER_DATA_WIDTH-1 -:`CODE_MEM_DATA_WIDTH];

assign ibuffer_signals_valid_o = (ibuffer_has_data != `NUM_WARP'b0) ? 1'b1:1'b0;
assign ibuffer_has_data = (~empty) & ready_warps_i;
assign ibuffer_avail_o = ~full;

rr_arb #(
	.ARB_WIDTH(`NUM_WARP)
) ibuffer_rr_arb (
	.clk                 (clk),
	.rst_n               (rst_n),
	.req_i               (ibuffer_has_data),
	.grant_o             (ibuffer_to_issue_oh)
);

oh2bin #(
	.ONE_HOT_WIDTH(`NUM_WARP),
	.BIN_WIDTH(`DEPTH_WARP)
) fetch_oh2bin (
	.oh_i                (ibuffer_to_issue_oh),
	.bin_o               (ibuffer_to_issue)
);

endmodule