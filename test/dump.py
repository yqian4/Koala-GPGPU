from .logger import logger

def dump_per_cycle(dut, cycle_id: int):
    logger.log(f"\n================================== Cycle {cycle_id} ==================================")
    