from .logger import logger


def dump_scheduler(dut):
    logger.log("\n Scheduler State:")
    logger.log("U_sm_warp_scheduler.index_to_assign：", dut.U_sm_core.U_sm_warp_scheduler.index_to_assign.value)
    logger.log("U_sm_warp_scheduler.bitmap_to_assign_oh：", dut.U_sm_core.U_sm_warp_scheduler.bitmap_to_assign_oh.value)
    logger.log("U_sm_warp_scheduler.bitmap_to_assign：", dut.U_sm_core.U_sm_warp_scheduler.bitmap_to_assign.value)
    logger.log("U_sm_warp_scheduler.bitmap_assigned：", dut.U_sm_core.U_sm_warp_scheduler.bitmap_assigned.value)

    logger.log("U_sm_warp_scheduler.tpc_req_ready_o：", dut.U_sm_core.U_sm_warp_scheduler.tpc_req_ready_o.value)
    logger.log("U_sm_warp_scheduler.tpc_req_fire：", dut.U_sm_core.U_sm_warp_scheduler.tpc_req_fire.value)
    logger.log("U_sm_warp_scheduler.tpc_req_valid_i：", dut.U_sm_core.U_sm_warp_scheduler.tpc_req_valid_i.value)

    logger.log("U_sm_warp_scheduler.sm_warp_req_valid_o：", dut.U_sm_core.U_sm_warp_scheduler.sm_warp_req_valid_o.value)
    logger.log("U_sm_warp_scheduler.sm_warp_req_wid_o：", dut.U_sm_core.U_sm_warp_scheduler.sm_warp_req_wid_o.value)
    
def dump_prefetch(dut):
    logger.log("\n Prefetch State:")
    logger.log("U_sm_fetch.sm_warp_req_valid_i：", dut.U_sm_core.U_sm_fetch.sm_warp_req_valid_i.value)
    logger.log("U_sm_fetch.sm_warp_req_wid_i：", dut.U_sm_core.U_sm_fetch.sm_warp_req_wid_i.value)
    logger.log("U_sm_fetch.sm_warp_req_start_addr_i：", dut.U_sm_core.U_sm_fetch.sm_warp_req_start_addr_i.value)
    logger.log("U_sm_fetch.ibuffer_avail_i：", dut.U_sm_core.U_sm_fetch.ibuffer_avail_i.value)
    logger.log("U_sm_fetch.stalled_warps_i：", dut.U_sm_core.U_sm_fetch.stalled_warps_i.value)

    logger.log("U_sm_fetch.active_warps：", dut.U_sm_core.U_sm_fetch.active_warps.value)
    logger.log("U_sm_fetch.ready_warps：", dut.U_sm_core.U_sm_fetch.ready_warps_o.value)
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
    
def dump_decode(dut):
    logger.log("\n Decode State:")
    logger.log("U_sm_decode.valid_i", dut.U_sm_core.U_sm_decode.valid_i.value)
    logger.log("U_sm_decode.inst_i", dut.U_sm_core.U_sm_decode.inst_i.value)
    logger.log("U_sm_decode.wid_i", dut.U_sm_core.U_sm_decode.wid_i.value)
    logger.log("U_sm_decode.decode_signals_inst_o", dut.U_sm_core.U_sm_decode.decode_signals_inst_o.value)
    logger.log("U_sm_decode.decode_signals_wid_o", dut.U_sm_core.U_sm_decode.decode_signals_wid_o.value)
    logger.log("U_sm_decode.decode_signals_opcode_na_o", dut.U_sm_core.U_sm_decode.decode_signals_opcode_na_o.value)
    logger.log("U_sm_decode.decode_signals_mod_o", dut.U_sm_core.U_sm_decode.decode_signals_mod_o.value)
    logger.log("U_sm_decode.decode_signals_pr_o", dut.U_sm_core.U_sm_decode.decode_signals_pr_o.value)
    logger.log("U_sm_decode.decode_signals_dst_o", dut.U_sm_core.U_sm_decode.decode_signals_dst_o.value)
    logger.log("U_sm_decode.decode_signals_src1_o", dut.U_sm_core.U_sm_decode.decode_signals_src1_o.value)
    logger.log("U_sm_decode.decode_signals_immea_o", dut.U_sm_core.U_sm_decode.decode_signals_immea_o.value)
    logger.log("U_sm_decode.decode_signals_space_sel_o", dut.U_sm_core.U_sm_decode.decode_signals_space_sel_o.value)
    logger.log("U_sm_decode.decode_signals_immeb_o", dut.U_sm_core.U_sm_decode.decode_signals_immeb_o.value)
    logger.log("U_sm_decode.decode_signals_opcode_nb_o", dut.U_sm_core.U_sm_decode.decode_signals_opcode_nb_o.value)
    
def dump_inst_buffer(dut):
    logger.log("\n Instruction Buffer State:")
    logger.log("U_sm_inst_buffer.ibuffer_avail_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_avail_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_has_data", dut.U_sm_core.U_sm_inst_buffer.ibuffer_has_data.value)
    logger.log("U_sm_inst_buffer.ibuffer_to_issue_oh", dut.U_sm_core.U_sm_inst_buffer.ibuffer_to_issue_oh.value)
    logger.log("U_sm_inst_buffer.rd_en", dut.U_sm_core.U_sm_inst_buffer.rd_en.value)
    logger.log("U_sm_inst_buffer.rd_data", dut.U_sm_core.U_sm_inst_buffer.rd_data.value)
    logger.log("U_sm_inst_buffer.wr_en", dut.U_sm_core.U_sm_inst_buffer.wr_en.value)
    logger.log("U_sm_inst_buffer.wr_data", dut.U_sm_core.U_sm_inst_buffer.wr_data.value)

    logger.log("inst_buffer_per_warp[0].U_sync_fifo.fifo_data.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.fifo_data.value)
    logger.log("inst_buffer_per_warp[0].U_sync_fifo.rd_ptr.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.rd_ptr.value)
    logger.log("inst_buffer_per_warp[0].U_sync_fifo.wr_ptr.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.wr_ptr.value)
    logger.log("inst_buffer_per_warp[0].U_sync_fifo.rd_en_i.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.rd_en_i.value)
    logger.log("inst_buffer_per_warp[0].U_sync_fifo.rd_data_o.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.rd_data_o.value)
    logger.log("inst_buffer_per_warp[0].U_sync_fifo.wr_en_i.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.wr_en_i.value)
    logger.log("inst_buffer_per_warp[0].U_sync_fifo.wr_data_i.value", dut.U_sm_core.U_sm_inst_buffer.inst_buffer_per_warp[0].U_sync_fifo.wr_data_i.value)

    logger.log("U_sm_inst_buffer.ibuffer_signals_valid_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_valid_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_inst_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_inst_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_wid_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_wid_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_opcode_na_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_opcode_na_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_mod_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_mod_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_pr_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_pr_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_dst_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_dst_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_src1_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_src1_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_immea_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_immea_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_space_sel_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_space_sel_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_immeb_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_immeb_o.value)
    logger.log("U_sm_inst_buffer.ibuffer_signals_opcode_nb_o", dut.U_sm_core.U_sm_inst_buffer.ibuffer_signals_opcode_nb_o.value)


def dump_per_cycle(dut, cycle_id: int):
    logger.log(f"\n================================== Cycle {cycle_id} ==================================")
    
    dump_scheduler(dut)
    dump_prefetch(dut)
    dump_decode(dut)
    dump_inst_buffer(dut)