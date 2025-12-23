`timescale 1ns/1ns
`include "common/define.sv"


module gpgpu_top (
	input  clk,                                                // input clock for the system
	input  rst_n,                                              // reset signal to the system, negative active
	
	// code memory interface
	input  code_mem_ready_i,                                   // signal indicating whether external code memory is ready for access	
	output code_rd_req_valid_o,                               // valid signal of code memory read operation
	output [`CODE_MEM_ADDR_WIDTH-1:0] code_rd_req_addr_o,     // code memory read address
	output [`DEPTH_WARP-1:0] code_rd_req_wid_o,               // warp id of code memory read 	
	input  code_rd_rsp_valid_i,                               // valid signal of code memory data after read operation
	input  [`CODE_MEM_ADDR_WIDTH-1:0] code_rd_rsp_addr_i,     // code memory read address
	input  [`DEPTH_WARP-1:0] code_rd_rsp_wid_i,               // warp id of code memory read 
   input  [`CODE_MEM_DATA_WIDTH-1:0] code_rd_rsp_data_i,     // data bits returned by code memory read operation
	
	
	// host interface
	output host_req_ready_o,                                   // signal telling whether GPU is ready to receive a new request from host
	input  host_req_valid_i,                                   // signal indicating a new kernel assigned for execution
	input  [`CODE_ADDR_WIDTH-1:0] host_req_start_addr_i,       // starting address of kernel code
	
	input  host_rsp_ready_i,                                   // signal telling whether host is ready to receive the response from GPU
	output host_rsp_valid_o,                                   // valid signal of GPU response
	output [`DEPTH_WARP-1:0] host_rsp_wid_o                    // id of the warp that finishes the execution
);


sm_core U_sm_core (
	.clk                         (clk),
	.rst_n                       (rst_n),
	.code_mem_ready_i            (code_mem_ready_i),
	.code_rd_req_valid_o         (code_rd_req_valid_o),
	.code_rd_req_addr_o          (code_rd_req_addr_o),
	.code_rd_req_wid_o           (code_rd_req_wid_o),
	.code_rd_rsp_valid_i         (code_rd_rsp_valid_i),
	.code_rd_rsp_addr_i          (code_rd_rsp_addr_i),
	.code_rd_rsp_wid_i           (code_rd_rsp_wid_i),
	.code_rd_rsp_data_i          (code_rd_rsp_data_i),
	.tpc_req_ready_o             (host_req_ready_o),
	.tpc_req_valid_i             (host_req_valid_i),
	.tpc_req_start_addr_i        (host_req_start_addr_i),
	.tpc_rsp_ready_i             (host_rsp_ready_i),
	.tpc_rsp_valid_o             (host_rsp_valid_o),
	.tpc_rsp_wid_o               (host_rsp_wid_o)
);


endmodule
