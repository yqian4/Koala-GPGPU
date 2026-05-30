# Koala-GPGPU

A GPGPU implementation compatible with the NVIDIA Fermi GPU microarchitecture, written in SystemVerilog. This project is a forward work for FlexGrip Plus, implementing a streaming multiprocessor (SM) core with warp-based execution.

## Architecture

The design implements a single SM core with complete execution pipeline:

```
gpgpu_top
└── sm_core
    ├── sm_warp_scheduler    — round-robin warp slot assignment for kernel launches
    ├── sm_fetch             — per-warp PC tracking, code memory fetch arbitration
    ├── sm_decode            — 64-bit Fermi instruction field extraction
    ├── sm_inst_buffer       — per-warp 2-entry instruction FIFOs
    ├── sm_score_board       — RAW hazard detection via in-flight register tracking
    ├── sm_operand_collect   — per-warp register file read and operand muxing
    ├── sm_issue             — instruction dispatch to execution units
    ├── sm_int_alu           — integer arithmetic/move execution
    └── sm_writeback         — result writeback to register file
```

### Key Parameters

| Parameter | Value |
|-----------|-------|
| Concurrent warps | 8 |
| Registers per warp | 64 |
| Instruction width | 64 bits |
| Code address width | 32 bits |
| Register data width | 32 bits |
| Inter-module protocol | Valid/ready handshake |

### Current Supported Instructions

| Instruction | OpcodeNB | Description |
|-------------|----------|-------------|
| MOV32I | 0x06 | Load 20-bit immediate into register |
| MOV | 0x0A | Register-to-register move |
| IADD | 0x12 | Integer add/subtract (mod-bit selectable) |
| IMUL | 0x14 | Integer multiply |
| EXIT | 0x20 | Warp completion signal |

### Fermi ISA Encoding (64-bit)

```
[63:58] OpcodeNB        [57:48] ImmediateB / Src3
[47:46] Space selector  [45:26] ImmediateA / Src2 / Const
[25:20] Src1 register   [19:14] Dst register
[13:10] Predicate       [9:4]   Modifier
[3:0]   OpcodeNA
```

Space selector: `00` = register src2, `01` = constant memory, `11` = immediate value.

## Prerequisites

- [Icarus Verilog](http://iverilog.icarus.com/) (12.0+, `-g2012` support required)
- Python 3.x with [Cocotb](https://www.cocotb.org/) (`pip install cocotb`)
- (Optional) Intel Quartus Prime for FPGA synthesis — Cyclone V 5CGTFD9D5F27C7 target

## Build & Test

```bash
# Run the integer operations test (MOV32I, MOV, IADD, IMUL, EXIT)
make test_integer

# Clean build artifacts
make clean
```

The build system copies RTL and test sources into `build/`, compiles with `iverilog -g2012`, and runs via `vvp` with the Cocotb VPI plugin.

## Test Infrastructure

Tests are Python-based Cocotb testbenches in `test/`:

| File | Purpose |
|------|---------|
| `test_integer.py` | Integer pipeline verification (MOV32I, MOV, IADD, IMUL, EXIT) |
| `memory.py` | Simulated code memory with request-response interface |
| `host.py` | Host/GPU interface driver for kernel launch/completion |
| `dump.py` | Per-cycle pipeline state dump for debugging |
| `logger.py` | Timestamped log file output |

## Common RTL Primitives (`rtl/common/`)

| Module | Description |
|--------|-------------|
| `sync_fifo` | Synchronous FIFO with pointer-based full/empty |
| `rr_arb` | Round-robin arbiter |
| `fixed_pri_arb` | Fixed-priority arbiter |
| `oh2bin` | One-hot to binary encoder |

## FPGA Target

Quartus Prime project in `project/altera/` targeting Cyclone V. Top-level entity: `gpgpu_top`.

## License

See [LICENSE](LICENSE) for details.
