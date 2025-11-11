`timescale 1ns/1ns
`include "../common/define.sv"


module sm_core (
	input  clk,                                               // input clock for the system
	input  rst_n,                                             // reset signal to the system, negative active
	
	// code memory interface
	input  code_mem_available_i,                              // signal indicating whether external code memory is vailable
	output code_read_valid_o,                                 // valid signal of code memory read operation
	output [`CODE_MEM_ADDR_WIDTH-1:0] code_read_addr_o,       // code memory read address
	output [`DEPTH_WARP-1:0] code_read_wid_o,                 // warp id of code memory read 	
	input  code_read_ready_i,                                 // ready siginal of code memory data after read operation
   input  [`CODE_MEM_DATA_WIDTH-1:0] code_read_data_i,       // data bits returned by code memory read operation
	
	
	// tpc interface
	output tpc_req_ready_o,                                   // signal telling whether sm core is ready to receive a new request from tpc
	input  tpc_req_valid_i,                                   // signal indicating a new kernel to be assigned to this sm core for execution
	input  [`CODE_ADDR_WIDTH-1:0] tpc_req_start_addr_i,       // starting address for kernel code
	
	input  tpc_rsp_ready_i,                                   // signal telling whether tpc is ready to receive the response from this sm core
	output tpc_rsp_valid_o,                                   // valid signal of sm core response to gpc
	output [`DEPTH_WARP-1:0] tpc_rsp_wid_o                    // warp id of the warp that has finished its execution
);

wire sm_warp_req_valid;
wire [`DEPTH_WARP-1:0] sm_warp_req_wid;

wire sm_warp_rsp_ready;
wire sm_warp_rsp_valid;
wire [`DEPTH_WARP-1:0] sm_warp_rsp_wid;

//wire [`NUM_WARP-1:0] inst_buffer_avail; 

sm_warp_assign U_sm_warp_assign (
	.clk                         (clk),
	.rst_n                       (rst_n),	
	
	.tpc_req_ready_o             (tpc_req_ready_o),
	.tpc_req_valid_i             (tpc_req_valid_i),	
	.tpc_rsp_ready_i             (tpc_rsp_ready_i),
	.tpc_rsp_valid_o             (tpc_rsp_valid_o),
	.tpc_rsp_wid_o               (tpc_rsp_wid_o),
	
	.sm_warp_req_valid_o         (sm_warp_req_valid),
	.sm_warp_req_wid_o           (sm_warp_req_wid),
	.sm_warp_rsp_ready_o         (sm_warp_rsp_ready),
	.sm_warp_rsp_valid_i         (sm_warp_rsp_valid),
	.sm_warp_rsp_wid_i           (sm_warp_rsp_wid)
);
//
//sm_fetch U_sm_fetch (
//	.clk                         (clk),
//	.rst_n                       (rst_n),
//	
//	.sm_warp_req_valid_i         (sm_warp_req_valid),
//	.sm_warp_req_wid_i           (sm_warp_req_wid),
//	.sm_warp_req_start_addr_i    (tpc_req_start_addr_i),
//	.inst_buffer_avail_i         (inst_buffer_avail),
//	
//	.code_mem_available_i        (code_mem_available_i),
//	.code_read_valid_o           (code_read_valid_o),
//	.code_read_addr_o            (code_read_addr_o)
//);
//
//sm_decode U_sm_decode (
//
//
//);
//
//
//sm_inst_buffer U_sm_inst_buffer (
//
//
//);
//
//sm_score_board U_sm_score_board (
//
//
//);
//
//sm_issue U_sm_issue (
//
//
//);
//
//sm_operand_collect U_sm_operand_collect (
//
//
//);
//
//sm_execute U_sm_execute (
//
//
//);
//
//
//sm_write U_sm_write (
//
//
//);


endmodule