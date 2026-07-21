# RV32I Wishbone SoC with Matrix Multiplication Accelerator

A modular **RV32I RISC-V System-on-Chip (SoC)** implemented in **SystemVerilog**, featuring a **Wishbone B4 Classic** interconnect, a **3×3 hardware matrix multiplication accelerator**, on-chip data memory, and a **UART peripheral**. The design demonstrates hardware acceleration through memory-mapped peripherals while maintaining a clean and scalable SoC architecture. 

---

## Target FPGA

**Digilent Nexys A7-100T (Artix-7 XC7A100T)**

---

## Features

- Single-cycle RV32I RISC-V processor
- Wishbone B4 Classic bus architecture
- Memory-mapped peripherals
- 3×3 Matrix Multiplication Accelerator
- UART (8-N-1, 9600 baud)
- On-chip data memory
- Modular and scalable interconnect
- RTL simulation and FPGA validation using Vivado ILA 

---

## System Architecture

```
                 +----------------+
                 |   RV32I CPU    |
                 +-------+--------+
                         |
                 Wishbone Master
                         |
               +---------+---------+
               | Wishbone Bus      |
               |  Interconnect     |
      +--------+---------+---------+
      |                  |         |
+-------------+   +-------------+  +-----------+
| Data Memory |   | Matrix Acc. |  |   UART    |
+-------------+   +-------------+  +-----------+
```

The CPU is the only Wishbone master. All peripherals are accessed through memory-mapped registers using standard load/store instructions. 

---

# Project Hierarchy

```
rv32i_soc_top
├── clock_divider
│   └── clk_wiz_0
│
├── cpu : rv32i
│   ├── pc_mux
│   ├── pc_freeze_mux
│   ├── program_counter
│   ├── instruction_memory
│   ├── adder0
│   ├── adder1
│   ├── instruction_decoder
│   ├── main_decoder
│   ├── alu_decoder
│   ├── immediate_generator
│   ├── reg_file_mux
│   ├── register_file
│   ├── alu_src_mux
│   └── ALU
│
├── WBM_rv32i
│
├── Wishbone_Interconnect
│   ├── WBS_Data_Mem
│   │   └── data_mem
│   │
│   ├── WBS_Matrix_Accelerator
│   │   └── Matrix_Accelerator
│   │       ├── PE_Controller
│   │       ├── matrix_mem A
│   │       ├── matrix_mem B
│   │       ├── matrix_mem C
│   │       └── PE_Array
│   │
│   └── WBS_uart
│       ├── baud_rate_generator (TX)
│       ├── baud_rate_generator (RX)
│       ├── uart_tx
│       └── uart_rx
```

---

# Memory Map

| Base Address | End Address | Peripheral |
|--------------|-------------|------------|
| `0x0000_0000` | `0x0000_0024` | Data Memory |
| `0x0000_1000` | `0x0000_1040` | Matrix Accelerator |
| `0x0000_2000` | `0x0000_2008` | UART |
| `0x0000_3000` | `0x0000_FFFF` | Reserved |

---

# Matrix Accelerator

The matrix accelerator is implemented as a memory-mapped Wishbone peripheral and computes the product of two **3×3 signed 8-bit matrices**.

### Internal Components

- PE Controller FSM
- 3×3 Processing Element (MAC) Array
- Matrix A Memory
- Matrix B Memory
- Matrix C Memory

The PE array performs all **nine dot products in parallel**, significantly reducing execution time compared to software execution. 

---

# UART Peripheral

- 8-N-1 UART
- 9600 baud
- Independent TX/RX baud generators
- 16× oversampling receiver
- Memory-mapped register interface

The UART enables communication between the SoC and a host PC using polling-based software. 

---

# Wishbone Bus

The SoC follows the **Wishbone B4 Classic** specification.

- Single Wishbone master (RV32I CPU)
- Address-decoding interconnect
- Memory-mapped peripherals
- One wait-state peripheral accesses
- Simple two-state slave handshake (IDLE → ACK)

Adding new peripherals only requires:
- a new Wishbone wrapper
- one decoder entry
- one response mux connection
- 
---

# Resource Utilization

| Resource | Utilization |
|----------|------------:|
| LUTs | 2,226 |
| Flip-Flops | 2,298 |
| DSP Slices | 9 |
| Block RAM | 0* |

Matrix memories are inferred as distributed (LUT) RAM.

---

# Toolchain

- SystemVerilog
- Xilinx Vivado 2023.2
- Digilent Nexys A7-100T FPGA
- Integrated Logic Analyzer (ILA)

---

# Future Improvements

- Interrupt controller
- SPI and I²C peripherals
- DMA support
- Timer peripherals
- Larger matrix accelerator
- Multi-cycle or pipelined RV32I processor

---
