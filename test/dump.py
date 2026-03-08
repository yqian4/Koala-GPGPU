from .logger import logger

def dump_per_cycle(dut, cycle_id: int):
    logger.log(f"\n================================== Cycle {cycle_id} ==================================")
    logger.log("d:", dut.d.value)
    logger.log("q:", dut.q.value)