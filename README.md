# Minimal 8-bit CPU Design (Verilog)

This repository contains a minimal 8-bit CPU implemented in Verilog HDL.  
The design demonstrates the fundamental architecture of a simple processor, including the ALU, Register File, Control Unit, Instruction Memory, and Datapath.  
The CPU executes instructions stored in external memory and follows a clear Fetch–Decode–Execute–Writeback sequence.

---

## Table of Contents
- [Author](#author)
- [Introduction](#introduction)
- [Architecture Overview](#architecture-overview)
- [Modules Description](#modules-description)
  - [ALU (`alu8.v`)](#alu-alu8v)
  - [Register File (`regfile.v`)](#register-file-regfilev)
  - [Datapath (`datapath.v`)](#datapath-datapathv)
  - [Control Unit (`control_unit.v`)](#control-unit-control_unitv)
  - [Instruction Memory (`instruction_memory.v`)](#instruction-memory-instruction_memoryv)
  - [Top-Level CPU (`cpu.v`)](#top-level-cpu-cpuv)
  - [Testbench (`cpu_tb.v`)](#testbench-cpu_tbv)
- [Instruction Set](#instruction-set)
- [Simulation Output](#simulation-output)
- [Results](#results)
- [License](#license)

---

## Author
**Rom Barak**  
B.Sc. Electrical Engineering, Bar-Ilan University  
Focus: Digital Systems, RTL Design, and VLSI Architecture

---

## Introduction
This project implements a minimal educational 8-bit CPU using Verilog.  
The CPU demonstrates the fundamental operations of a processor, including:
- Arithmetic and logical operations via the ALU
- Register-based data storage and manipulation
- Program-controlled execution through a finite state machine (FSM)
- Instruction fetching and decoding from memory

The design provides a clear view of how simple processors execute machine-level operations at the RTL level.

---

## Architecture Overview
The processor consists of the following main components:

| Module | Function |
|--------|-----------|
| **ALU** | Performs arithmetic and logical operations (ADD, SUB, AND, OR, XOR, NOT, SHL, SHR). |
| **Register File** | Stores four 8-bit general-purpose registers (R0–R3). |
| **Control Unit** | Controls instruction flow through FSM states (FETCH, EXECUTE, WRITEBACK, NEXT, DONE). |
| **Instruction Memory** | Holds program instructions loaded from `program.mem`. |
| **Datapath** | Connects the ALU, RegFile, and Control Unit for data transfer. |
| **Top-Level CPU** | Integrates all functional modules. |
| **Testbench** | Provides simulation and waveform analysis. |

---

## Modules Description

### ALU (`alu8.v`)
Performs 8-bit arithmetic and logic operations.  
Includes carry and zero flags for control feedback.

**Main Operations:**
