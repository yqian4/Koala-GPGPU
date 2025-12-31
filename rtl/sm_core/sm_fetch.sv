module sm_fetch (
	input  clk,                                               // input clock for the system
	input  rst_n, 
	
	input  sm_warp_req_valid_i,                               // indiate a new warp request is available
	input  sm_warp_req_wid_i,                                 // warp id of this new warp request
	input  [`CODE_ADDR_WIDTH-1:0] sm_warp_req_start_addr_i,   // starting address for kernel code
	input  [`NUM_WARP-1:0] inst_buffer_avail_i,               // indicate whether instruction buffer of this warp has free space
	input  [`NUM_WARP-1:0] stalled_warps_i,                   // tell the information of stalled warps
	
	input  code_mem_ready_i,                                  // signal indicating whether external code memory is ready for access
	output code_rd_req_valid_o,                               // valid signal of code memory read operation
	output [`CODE_MEM_ADDR_WIDTH-1:0] code_rd_req_addr_o,     // code memory read address
	output [`DEPTH_WARP-1:0] code_rd_req_wid_o,               // warp id of code memory read,
   
   input  code_rd_rsp_valid_i,                               // indicate the response from external code memory is available
   input  [`CODE_MEM_ADDR_WIDTH-1:0] code_rd_rsp_addr_i,     // returned address of code memory response	
	input  [`DEPTH_WARP-1:0] code_rd_rsp_wid_i                // warp id of code memory response	
);

wire sm_warp_req_fire;
reg  [`NUM_WARP-1:0] active_warps;
wire [`NUM_WARP-1:0] ready_warps;

wire [`DEPTH_WARP-1:0] selected_warp;
wire [`NUM_WARP-1:0]   selected_warp_oh;

reg  [`CODE_ADDR_WIDTH-1:0] warp_pcs[`NUM_WARP-1:0];
integer i;


assign sm_warp_req_fire = sm_warp_req_valid_i;

assign ready_warps = (active_warps & stalled_warps_i) & inst_buffer_avail_i;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		active_warps <= 'h0;
	end 
	else begin
		active_warps <= active_warps | ((1'h1<< sm_warp_req_wid_i) & {`NUM_WARP{sm_warp_req_fire}});
	end 
end


rr_arb #(
	.ARB_WIDTH(`NUM_WARP)
) fetch_rr_arb (
	.clk                 (clk),
	.rst_n               (rst_n),
	.req_i               (ready_warps),
	.grant_o             (selected_warp_oh)
);


oh2bin #(
	.ONE_HOT_WIDTH(`NUM_WARP),
	.BIN_WIDTH(`DEPTH_WARP)
) fetch_oh2bin (
	.oh_i                (selected_warp_oh),
	.bin_o               (selected_warp)
);

always @(posedge clk or negedge rst_n) begin
	for(i=0;i<`NUM_WARP;i=i+1) begin
		if(!rst_n) begin
			warp_pcs[i] <= 'h0;
		end 
		else begin			
			warp_pcs[i] <= (sm_warp_req_fire && (i == sm_warp_req_wid_i)) ? sm_warp_req_start_addr_i :
								((code_rd_rsp_valid_i && (i == code_rd_rsp_wid_i)) ? code_rd_rsp_addr_i : warp_pcs[i]);
		end
	end
end

assign code_rd_req_valid_o = (|ready_warps) && code_mem_ready_i;
assign code_rd_req_addr_o = warp_pcs[selected_warp];
assign code_rd_req_wid_o = selected_warp;


endmodule