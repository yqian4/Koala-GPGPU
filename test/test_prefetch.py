import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from .memory import Memory
from .logger import logger
from .host import host_interface
from .dump import dump_per_cycle

from remote_pdb import RemotePdb
rpdb = RemotePdb("127.0.0.1", 4000)

@cocotb.test()
async def test_prefetch(dut):

    # Initialize code Memory
    code_memory = Memory(dut=dut, addr_bits=32, data_bits=64, wid_bits=8, name="code")
    kernel_code = [
        0b01010000110111100101000011011110, # MUL R0, %blockIdx, %blockDim
        0b00110000000011110101000011011110, # ADD R0, R0, %threadIdx         ; i = blockIdx * blockDim + threadIdx
        0b10010001000000000101000011011110, # CONST R1, #0                   ; baseA (matrix A base address)
        0b10010010000010000101000011011110, # CONST R2, #8                   ; baseB (matrix B base address)
        0b10010011000100000101000011011110, # CONST R3, #16                  ; baseC (matrix C base address)
        0b00110100000100000101000011011110, # ADD R4, R1, R0                 ; addr(A[i]) = baseA + i
        0b01110100010000000101000011011110, # LDR R4, R4                     ; load A[i] from global memory
        0b00110101001000000101000011011110, # ADD R5, R2, R0                 ; addr(B[i]) = baseB + i
        0b01110101010100000101000011011110, # LDR R5, R5                     ; load B[i] from global memory
        0b00110110010001010101000011011110, # ADD R6, R4, R5                 ; C[i] = A[i] + B[i]
        0b00110111001100000101000011011110, # ADD R7, R3, R0                 ; addr(C[i]) = baseC + i
        0b10000000011101100101000011011110, # STR R7, R6                     ; store C[i] in global memory
        0b11110000000000000101000011011110, # RET                            ; end of kernel
    ]
    # Initialize host interface
    host = host_interface(dut=dut, addr_bits=32, wid_bits=8)

    # Setup 50MHZ Clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    rpdb.set_trace()
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
    
    cycles = 0
    for i in range(5):
        code_memory.run()

        await RisingEdge(dut.clk)   

        dump_per_cycle(dut, cycles)  

        cycles += 1

