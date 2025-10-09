`timescale 1ns/1ns
`include "define.sv"


module sm_core (
	input  clk,                                               // input clock for the system
	input  rst_n,                                             // reset signal to the system, negative active
	
	// program memory interface
	input  program_mem_available_i,                           // signal indicating whether external program memory is vailable
	output program_read_valid_o,                              // valid signal of program memory read operation
	output [`PROGRAM_MEM_ADDR_BITS-1:0] program_read_addr_o,   // program memory read address
	input  program_read_ready_i,                              // ready siginal of program memory data after read operation
   input  [`PROGRAM_MEM_DATA_BITS-1:0] program_read_data_i,	 // data bits returned by program memory read operation
	
	
	// host interface
	output host_req_ready_o,                                  // signal telling whether GPU is ready to receive a new request from host
	input  host_req_valid_i,                                  // signal indicating a new kernel assigned for execution
	input  host_req_kernel_code_addr_i,                       // starting address of kernel code
	
	input  host_rsp_ready_i,                                  // signal telling whether host is ready to receive the response from GPU
	output host_rsp_valid_o,                                  // valid signal of GPU response
	output [`DEPTH_WARP-1:0] host_rsp_wid_done                // id of the warp that finishes the execution
);





endmodule