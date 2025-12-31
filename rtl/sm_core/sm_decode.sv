`timescale 1ns/1ns
`include "../common/define.sv"

module sm_decode (
	input  clk,                                               // input clock for the system
	input  rst_n, 
	
	input  valid_i,                                           // indicate whether there is a valid instruction to be decoded
	input  inst_i,                                            // input instruction to be decoded
	input  wid_i,                                             // input warp id
	
	output [`CODE_MEM_DATA_WIDTH-1:0] decode_signals_inst_o,  // output instruction 
	output [`DEPTH_WARP-1:0] decode_signals_wid_o,            // output warp id
	output [3:0] decode_signals_opcode_na_o,                  // output opcode na field
	output [5:0] decode_signals_mod_o,                        // output mod field
	output [3:0] decode_signals_pr_o,                         // output pr field
	output [5:0] decode_signals_re0_o,                        // output re0 field
	output [5:0] decode_signals_re1_o,                        // output re1 field
	output [9:0] decode_signals_immeb_o,                      // output immeb field
	output [21:0] decode_signals_immea_o,                     // output immea field
	output [5:0] decode_signals_opcode_nb_o                   // output opcode nb field
);

reg [`CODE_MEM_DATA_WIDTH-1:0] cached_decode_inst;
reg [`DEPTH_WARP-1:0] cached_decode_wid;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cached_decode_inst <= 'h0;
		cached_decode_wid <= 'h0;
	end 
	else if(valid_i) begin
		cached_decode_inst <= inst_i;
		cached_decode_wid <= wid_i;
	end
	else begin
		cached_decode_inst <= cached_decode_inst;
		cached_decode_wid <= cached_decode_wid;
	end 
end

assign decode_signals_inst_o = cached_decode_inst;
assign decode_signals_wid_o = cached_decode_wid;

assign decode_signals_opcode_na_o = cached_decode_inst[3:0];
assign decode_signals_mod_o = cached_decode_inst[9:4];
assign decode_signals_pr_o = cached_decode_inst[13:10];
assign decode_signals_re0_o = cached_decode_inst[19:14];
assign decode_signals_re1_o = cached_decode_inst[25:20];
assign decode_signals_immeb_o = cached_decode_inst[35:26];
assign decode_signals_immea_o = cached_decode_inst[57:36];
assign decode_signals_opcode_nb_o = cached_decode_inst[63:58];

endmodule