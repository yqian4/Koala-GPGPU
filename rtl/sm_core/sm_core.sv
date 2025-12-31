`timescale 1ns/1ns
`include "../common/define.sv"


module sm_core (
	input  clk,                                               // input clock for the system
	input  rst_n,                                             // reset signal to the system, negative active
	
	// code memory interface
	input  code_mem_ready_i,                                  // signal indicating whether external code memory is ready for access
	output code_rd_req_valid_o,                               // valid signal of code memory read operation
	output [`CODE_MEM_ADDR_WIDTH-1:0] code_rd_req_addr_o,     // code memory read address
	output [`DEPTH_WARP-1:0] code_rd_req_wid_o,               // warp id of code memory read 	
	input  code_rd_rsp_valid_i,                               // valid signal of code memory data after read operation
	input  [`CODE_MEM_ADDR_WIDTH-1:0] code_rd_rsp_addr_i,     // code memory read address
	input  [`DEPTH_WARP-1:0] code_rd_rsp_wid_i,               // warp id of code memory read 
   input  [`CODE_MEM_DATA_WIDTH-1:0] code_rd_rsp_data_i,     // data bits returned by code memory read operation
	
	
	// tpc interface
	output tpc_req_ready_o,                                   // signal telling whether sm core is ready to receive a new request from tpc
	input  tpc_req_valid_i,                                   // signal indicating a new kernel to be assigned to this sm core for execution
	input  [`CODE_ADDR_WIDTH-1:0] tpc_req_start_addr_i,       // starting address for kernel code
	
	input  tpc_rsp_ready_i,                                   // signal telling whether tpc is ready to receive the response from this sm core
	output tpc_rsp_valid_o,                                   // valid signal of sm core response to gpc
	output [`DEPTH_WARP-1:0] tpc_rsp_wid_o                    // warp id of the warp that has finished its execution
);

wire                            sm_warp_req_valid;
wire [`DEPTH_WARP-1:0]          sm_warp_req_wid;

wire sm_warp_rsp_ready, sm_warp_rsp_valid;
wire [`DEPTH_WARP-1:0]          sm_warp_rsp_wid;

wire [`NUM_WARP-1:0]            inst_buffer_avail; 
wire [`NUM_WARP-1:0]            stalled_warps;

wire [`CODE_MEM_DATA_WIDTH-1:0] inst_to_decode;

wire [`CODE_MEM_DATA_WIDTH-1:0] decode_signals_inst;
wire [`DEPTH_WARP-1:0]          decode_signals_wid;
wire [3:0]                      decode_signals_opcode_na;
wire [5:0]                      decode_signals_mod;
wire [3:0]                      decode_signals_pr;
wire [5:0]                      decode_signals_re0;
wire [5:0]                      decode_signals_re1;
wire [9:0]                      decode_signals_immeb;
wire [21:0]                     decode_signals_immea;
wire [5:0]                      decode_signals_opcode_nb;

wire [`CODE_MEM_DATA_WIDTH-1:0] ibuffer_signals_inst;
wire [`DEPTH_WARP-1:0]          ibuffer_signals_wid;
wire [3:0]                      ibuffer_signals_opcode_na;
wire [5:0]                      ibuffer_signals_mod;
wire [3:0]                      ibuffer_signals_pr;
wire [5:0]                      ibuffer_signals_re0;
wire [5:0]                      ibuffer_signals_re1;
wire [9:0]                      ibuffer_signals_immeb;
wire [21:0]                     ibuffer_signals_immea;
wire [5:0]                      ibuffer_signals_opcode_nb;
wire                            ibuffer_signals_valid;
wire [`NUM_WARP-1:0]            warp_to_issue_oh;
wire [`NUM_WARP-1:0]            inst_buffer_has_data; 


assign inst_to_decode = code_rd_rsp_data_i;

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

sm_fetch U_sm_fetch (
	.clk                         (clk),
	.rst_n                       (rst_n),
	
	.sm_warp_req_valid_i         (sm_warp_req_valid),
	.sm_warp_req_wid_i           (sm_warp_req_wid),
	.sm_warp_req_start_addr_i    (tpc_req_start_addr_i),
	.inst_buffer_avail_i         (inst_buffer_avail),
	.stalled_warps_i             (stalled_warps),
	
	.code_mem_ready_i            (code_mem_ready_i),
	.code_rd_req_valid_o         (code_rd_req_valid_o),
	.code_rd_req_addr_o          (code_rd_req_addr_o),
	.code_rd_req_wid_o           (code_rd_req_wid_o),
	
	.code_rd_rsp_valid_i         (code_rd_rsp_valid_i),
	.code_rd_rsp_addr_i          (code_rd_rsp_addr_i),
	.code_rd_rsp_wid_i           (code_rd_rsp_wid_i)
);

sm_decode U_sm_decode (
	.clk                         (clk),
	.rst_n                       (rst_n),
	
	.valid_i                     (code_rd_rsp_valid_i),
	.inst_i                      (inst_to_decode),
	.wid_i                       (code_rd_rsp_wid_i),
	
	.decode_signals_inst_o       (decode_signals_inst),
	.decode_signals_wid_o        (decode_signals_wid),
	.decode_signals_opcode_na_o  (decode_signals_opcode_na),
	.decode_signals_mod_o        (decode_signals_mod),
	.decode_signals_pr_o         (decode_signals_pr),
	.decode_signals_re0_o        (decode_signals_re0),
	.decode_signals_re1_o        (decode_signals_re1),
	.decode_signals_immeb_o      (decode_signals_immeb),
	.decode_signals_immea_o      (decode_signals_immea),
	.decode_signals_opcode_nb_o  (decode_signals_opcode_nb)
);


sm_inst_buffer #(
	.IBUFFER_DATA_WIDTH(2*`CODE_MEM_DATA_WIDTH+`DEPTH_WARP),
	.IBUFFER_SIZE(2)
) U_sm_inst_buffer (
	.clk                          (clk),
	.rst_n                        (rst_n),
  
	.decode_signals_valid_i       (code_rd_rsp_valid_i),
	.decode_signals_inst_i        (decode_signals_inst),
	.decode_signals_wid_i         (decode_signals_wid),
	.decode_signals_opcode_na_i   (decode_signals_opcode_na),
	.decode_signals_mod_i         (decode_signals_mod),
	.decode_signals_pr_i          (decode_signals_pr),
	.decode_signals_re0_i         (decode_signals_re0),
	.decode_signals_re1_i         (decode_signals_re1),
	.decode_signals_immeb_i       (decode_signals_immeb),
	.decode_signals_immea_i       (decode_signals_immea),
	.decode_signals_opcode_nb_i   (decode_signals_opcode_nb),
  
	.ibuffer_signals_inst_o       (ibuffer_signals_inst),
	.ibuffer_signals_wid_o        (ibuffer_signals_wid),
	.ibuffer_signals_opcode_na_o  (ibuffer_signals_opcode_na),
	.ibuffer_signals_mod_o        (ibuffer_signals_mod),                      
	.ibuffer_signals_pr_o         (ibuffer_signals_pr),                        
	.ibuffer_signals_re0_o        (ibuffer_signals_re0),                        
	.ibuffer_signals_re1_o        (ibuffer_signals_re1),                      
	.ibuffer_signals_immeb_o      (ibuffer_signals_immeb),                      
	.ibuffer_signals_immea_o      (ibuffer_signals_immea),                    
	.ibuffer_signals_opcode_nb_o  (ibuffer_signals_opcode_nb),
	.ibuffer_signals_valid_i      (ibuffer_signals_valid),
	
	.warp_to_issue_oh_i           (warp_to_issue_oh),
	.inst_buffer_has_data_o       (inst_buffer_has_data),
	.inst_buffer_avail_o          (inst_buffer_avail)
);

//sm_score_board U_sm_score_board (
//
//
//);
//
//sm_operand_collect U_sm_operand_collect (
//
//
//);
//
//sm_issue U_sm_issue (
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