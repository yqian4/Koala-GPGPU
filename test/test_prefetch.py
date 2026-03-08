# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.runner import get_runner
from cocotb.triggers import RisingEdge
from cocotb.types import LogicArray
from .logger import logger
from .dump import dump_per_cycle

#from remote_pdb import RemotePdb
#rpdb = RemotePdb("127.0.0.1", 4000)

@cocotb.test()
async def dff_simple_test(dut):
    """Test that d propagates to q"""

   
    # Set initial input value to prevent it from floating
    dut.d.value = 0
    #rpdb.set_trace()

    clock = Clock(dut.clk, 10, units="us")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    # Synchronize with the clock. This will regisiter the initial `d` value
    await RisingEdge(dut.clk)
    cycles = 0
    for i in range(10):
        val = random.randint(0, 1)
        logger.log(f"new value:", val)
        dut.d.value = val  # Assign the random value val to the input port d       
        await RisingEdge(dut.clk)
        await cocotb.triggers.ReadWrite()
        assert dut.q.value == val, f"output q was incorrect on the {i}th cycle"        
        dump_per_cycle(dut, cycles)        
        cycles += 1


def test_simple_dff_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve().parent

    verilog_sources = []
    vhdl_sources = []

    if hdl_toplevel_lang == "verilog":
        verilog_sources = [proj_path / "dff.sv"]
    else:
        vhdl_sources = [proj_path / "dff.vhdl"]

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        vhdl_sources=vhdl_sources,
        hdl_toplevel="dff",
        always=True,
    )

    runner.test(hdl_toplevel="dff", test_module="test_dff,")


if __name__ == "__main__":
    test_simple_dff_runner()
