`timescale 1ns/1ns
`include "../common/define.sv"

module sm_decode (
	input  clk,                                               // input clock for the system
	input  rst_n, 
	
	input  valid_i,                                           // indicate whether there is a valid instruction to be decoded
	input  [`CODE_MEM_DATA_WIDTH-1:0] inst_i,                 // input instruction to be decoded
	input  [`DEPTH_WARP-1:0] wid_i,                           // input warp id
	
	output [`CODE_MEM_DATA_WIDTH-1:0] decode_signals_inst_o,  // output instruction 
	output [`DEPTH_WARP-1:0] decode_signals_wid_o,            // output warp id
	output [3:0] decode_signals_opcode_na_o,                  // output opcode na field
	output [5:0] decode_signals_mod_o,                        // output mod field
	output [3:0] decode_signals_pr_o,                         // output pr field
	output [5:0] decode_signals_dst_o,                        // output dst field
	output [5:0] decode_signals_src1_o,                       // output src1 field
	output [19:0] decode_signals_immea_o,                     // output immea field
	output [1:0]  decode_signals_space_sel_o,                 // output space selector field
	output [9:0] decode_signals_immeb_o,                      // output immeb field	
	output [5:0] decode_signals_opcode_nb_o                   // output opcode nb field
);

assign decode_signals_inst_o = valid_i?inst_i:'h0;
assign decode_signals_wid_o = valid_i?wid_i:'h0;


// Ferimi GPU Instruction Encoding Format (8-Byte Instruction):
// Opcode NA: [3:0]
// Mod: [9:4]
// PR: [13:10]
// Dst Register: [19:14]
// Src1 Register: [25:20]
// Src2 Register: [31:26]
// Const Offset: [41:26], Const Bank [45:42]
// Immediate A Value: [45:26]
// Space Selector: [47:46]: 00-use SRC2, 01-use Const, 10-unused, 11-Immediate Value
// Src3 Register: [54:49]
// Immediate B Value: [57:48]
// Opcode NB: [63:58]

assign decode_signals_opcode_na_o = valid_i?inst_i[3:0]:'h0;
assign decode_signals_mod_o = valid_i?inst_i[9:4]:'h0;
assign decode_signals_pr_o = valid_i?inst_i[13:10]:'h0;
assign decode_signals_dst_o = valid_i?inst_i[19:14]:'h0; 
assign decode_signals_src1_o = valid_i?inst_i[25:20]:'h0; 
assign decode_signals_immea_o = valid_i?inst_i[45:26]:'h0;
assign decode_signals_space_sel_o = valid_i?inst_i[47:46]:'h0;  
assign decode_signals_immeb_o = valid_i?inst_i[57:48]:'h0;
assign decode_signals_opcode_nb_o = valid_i?inst_i[63:58]:'h0;

endmodule