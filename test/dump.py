from .logger import logger


def dump_scheduler(dut):
    logger.log("\n Scheduler State:")
    logger.log("U_sm_warp_assign.index_to_assign：", dut.U_sm_core.U_sm_warp_assign.index_to_assign.value)
    logger.log("U_sm_warp_assign.bitmap_to_assign_oh：", dut.U_sm_core.U_sm_warp_assign.bitmap_to_assign_oh.value)
    logger.log("U_sm_warp_assign.bitmap_to_assign：", dut.U_sm_core.U_sm_warp_assign.bitmap_to_assign.value)
    logger.log("U_sm_warp_assign.bitmap_assigned：", dut.U_sm_core.U_sm_warp_assign.bitmap_assigned.value)

    logger.log("U_sm_warp_assign.tpc_req_ready_o：", dut.U_sm_core.U_sm_warp_assign.tpc_req_ready_o.value)
    logger.log("U_sm_warp_assign.tpc_req_fire：", dut.U_sm_core.U_sm_warp_assign.tpc_req_fire.value)
    logger.log("U_sm_warp_assign.tpc_req_valid_i：", dut.U_sm_core.U_sm_warp_assign.tpc_req_valid_i.value)

    logger.log("U_sm_warp_assign.sm_warp_req_valid_o：", dut.U_sm_core.U_sm_warp_assign.sm_warp_req_valid_o.value)
    logger.log("U_sm_warp_assign.sm_warp_req_wid_o：", dut.U_sm_core.U_sm_warp_assign.sm_warp_req_wid_o.value)
    
def dump_prefetch(dut):
    logger.log("\n Prefetch State:")
    logger.log("U_sm_fetch.sm_warp_req_valid_i：", dut.U_sm_core.U_sm_fetch.sm_warp_req_valid_i.value)
    logger.log("U_sm_fetch.sm_warp_req_wid_i：", dut.U_sm_core.U_sm_fetch.sm_warp_req_wid_i.value)
    logger.log("U_sm_fetch.sm_warp_req_start_addr_i：", dut.U_sm_core.U_sm_fetch.sm_warp_req_start_addr_i.value)
    logger.log("U_sm_fetch.inst_buffer_avail_i：", dut.U_sm_core.U_sm_fetch.inst_buffer_avail_i.value)
    logger.log("U_sm_fetch.stalled_warps_i：", dut.U_sm_core.U_sm_fetch.stalled_warps_i.value)

    logger.log("U_sm_fetch.active_warps：", dut.U_sm_core.U_sm_fetch.active_warps.value)
    logger.log("U_sm_fetch.ready_warps：", dut.U_sm_core.U_sm_fetch.ready_warps.value)
    logger.log("U_sm_fetch.selected_warp_oh：", dut.U_sm_core.U_sm_fetch.selected_warp_oh.value)
    logger.log("U_sm_fetch.selected_warp：", dut.U_sm_core.U_sm_fetch.selected_warp.value)

    logger.log("U_sm_fetch.code_mem_ready_i：", dut.U_sm_core.U_sm_fetch.code_mem_ready_i.value)
    logger.log("U_sm_fetch.code_rd_req_valid_o：", dut.U_sm_core.U_sm_fetch.code_rd_req_valid_o.value)
    logger.log("U_sm_fetch.code_rd_req_addr_o：", dut.U_sm_core.U_sm_fetch.code_rd_req_addr_o.value)
    logger.log("U_sm_fetch.code_rd_req_wid_o：", dut.U_sm_core.U_sm_fetch.code_rd_req_wid_o.value)

    logger.log("U_sm_fetch.code_rd_rsp_valid_i：", dut.U_sm_core.U_sm_fetch.code_rd_rsp_valid_i.value)
    logger.log("U_sm_fetch.code_rd_rsp_wid_i：", dut.U_sm_core.U_sm_fetch.code_rd_rsp_wid_i.value)
    logger.log("U_sm_fetch.code_rd_rsp_addr_i：", dut.U_sm_core.U_sm_fetch.code_rd_rsp_addr_i.value)
    logger.log("U_sm_core.code_rd_rsp_data_i：", dut.U_sm_core.code_rd_rsp_data_i.value)
    


def dump_per_cycle(dut, cycle_id: int):
    logger.log(f"\n================================== Cycle {cycle_id} ==================================")
    
    dump_scheduler(dut)
    dump_prefetch(dut)