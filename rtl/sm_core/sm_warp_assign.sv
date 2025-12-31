`timescale 1ns/1ns
`include "../common/define.sv"

module sm_warp_assign (
	input  clk,                                               // input clock for the system
	input  rst_n,                                             // reset signal to the system, negative active
	
	output tpc_req_ready_o,                                   // signal telling whether sm core is ready to receive a new request from tpc
	input  tpc_req_valid_i,                                   // signal indicating a new kernel to be assigned to this sm core for execution
	input  tpc_rsp_ready_i,                                   // signal telling whether tpc is ready to receive response from this sm core
	output tpc_rsp_valid_o,                                   // signal indicating a new response is available for TPC's processing
	output [`DEPTH_WARP-1:0] tpc_rsp_wid_o,                   // warp id of a new completed warp
	
	output sm_warp_req_valid_o,                               // indiate a new warp is assigned for execution
	output [`DEPTH_WARP-1:0] sm_warp_req_wid_o,               // warp id of this new warp to be executed
	output sm_warp_rsp_ready_o,                               // signal telling whether it is ready to receive response from warp
	input  sm_warp_rsp_valid_i,                               // signal indicating a new response is available for processing
	input  [`DEPTH_WARP-1:0] sm_warp_rsp_wid_i	             // warp id of a new completed warp
);

wire tpc_req_fire, sm_warp_rsp_fire;
reg [`NUM_WARP-1:0]  bitmap_assigned;
wire [`NUM_WARP-1:0] bitmap_to_assign,bitmap_to_release;

wire [`DEPTH_WARP-1:0] index_to_assign;
wire [`NUM_WARP-1:0]   bitmap_to_assign_oh;

assign tpc_req_fire = tpc_req_valid_i && tpc_req_ready_o;
assign sm_warp_rsp_fire = sm_warp_rsp_valid_i && sm_warp_rsp_ready_o;

assign tpc_req_ready_o = ~(&bitmap_assigned);
assign bitmap_to_assign = bitmap_assigned | ((1'h1<<index_to_assign) & {`NUM_WARP{tpc_req_fire}}); 
assign bitmap_to_release = (1'h1<<sm_warp_rsp_wid_i) & {`NUM_WARP{sm_warp_rsp_fire}}; 

assign sm_warp_req_valid_o = tpc_req_fire;
assign sm_warp_req_wid_o = index_to_assign;

assign sm_warp_rsp_ready_o = tpc_rsp_ready_i;
assign tpc_rsp_valid_o = sm_warp_rsp_valid_i;
assign tpc_rsp_wid_o = sm_warp_rsp_wid_i;


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		bitmap_assigned <= 'h0;
	end 
	else begin
		bitmap_assigned <= bitmap_to_assign & (~bitmap_to_release); 
	end  
end 


rr_arb #(
	.ARB_WIDTH(`NUM_WARP)
) assign_rr_arb (
	.clk                 (clk),
	.rst_n               (rst_n),
	.req_i               (~bitmap_assigned),
	.grant_o             (bitmap_to_assign_oh)
);


oh2bin #(
	.ONE_HOT_WIDTH(`NUM_WARP),
	.BIN_WIDTH(`DEPTH_WARP)
) assign_oh2bin (
	.oh_i                (bitmap_to_assign_oh),
	.bin_o               (index_to_assign)
);

endmodule