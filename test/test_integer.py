import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from .memory import Memory
from .logger import logger
from .host import host_interface
from .dump import dump_per_cycle

#from remote_pdb import RemotePdb
#rpdb = RemotePdb("127.0.0.1", 4000)

@cocotb.test()
async def test_integer(dut):

    # Initialize code Memory
    code_memory = Memory(dut=dut, addr_bits=32, data_bits=64, wid_bits=8, name="code")
    kernel_code = [
        0x1800c00190005de4,                 # MOV32I R1, 0x64           ; R1 = 100
        0x1800c00320009de4,                 # MOV32I R2, 0xc8           ; R2 = 200
        0x280080000020DDE4,                 # MOV R3, R2                ; R3 = R2
        0x4800000008105c03,                 # IADD R1, R1, R2           ; R1 = R1 + R2
        0x5000000008105ca3,                 # IMUL R1, R1, R2           ; R1 = R1 * R2
        0x8000000000001de7,                 # EXIT                      ; Exit
    ]
    # Initialize host interface
    host = host_interface(dut=dut, addr_bits=32, wid_bits=8)

    # Setup 50MHZ Clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Load kernel code into code memory
    code_memory.load(kernel_code)
    await RisingEdge(dut.clk)
    dump_per_cycle(dut, 800) 
    
    # send one kernel for execution
    host.launch_kernel(kernel_addr=0)
    await RisingEdge(dut.clk)
    dump_per_cycle (dut, 998)

    host.clear()
    await RisingEdge(dut.clk)
    dump_per_cycle (dut, 999)

    #rpdb.set_trace()
    
    cycles = 0
    for i in range(100):
        code_memory.run()

        await RisingEdge(dut.clk)

        dump_per_cycle(dut, cycles)


        cycles += 1

    # Verify register values (flattened indexing: warp0 R_n = index n)
    oc = dut.U_sm_core.U_sm_operand_collect
    r1_val = oc.reg_file[1].value.integer
    r2_val = oc.reg_file[2].value.integer
    r3_val = oc.reg_file[3].value.integer
    logger.log(f"\n===== Register Verification =====")
    logger.log(f"R1 = {r1_val} (0x{r1_val:08x})")
    logger.log(f"R2 = {r2_val} (0x{r2_val:08x})")
    logger.log(f"R3 = {r3_val} (0x{r3_val:08x})")

    assert r1_val == 60000, f"IMUL R1, R1, R2 failed: expected R1=60000, got R1={r1_val}"
    assert r2_val == 200, f"MOV32I R2, 200 failed: expected R2=200, got R2={r2_val}"
    assert r3_val == 200, f"MOV R3, R2 failed: expected R3=200, got R3={r3_val}"

