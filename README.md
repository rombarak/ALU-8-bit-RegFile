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
- [Conclusion](#Conclusion)
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
```verilog
ADD, SUB, AND, OR, XOR, NOT, SHL, SHR
```

**Features:**
- Operates on 8-bit inputs (`a`, `b`)
- Produces 8-bit output (`y`)
- Generates status flags:
  - **C** – Carry/Borrow flag
  - **Z** – Zero flag
- Fully combinational and synthesizable logic
- Parameter-free and portable between FPGA/ASIC environments

---

### Register File (`regfile.v`)
Implements a 4×8-bit register bank with dual asynchronous read ports and one synchronous write port.  
Used to temporarily store operands and results between ALU operations.

**Functional Description:**
- Asynchronous read ensures immediate data availability for ALU input
- Synchronous write ensures data consistency at each clock cycle
- Write operation controlled via the `we` (Write Enable) signal

**Key Signals:**
| Signal | Width | Description |
|---------|--------|-------------|
| `clk` | 1 | System clock for synchronous writes |
| `we` | 1 | Write enable |
| `ra1`, `ra2` | 2 | Read addresses |
| `wa` | 2 | Write address |
| `wd` | 8 | Write data input |
| `rd1`, `rd2` | 8 | Read data outputs |

---

### Datapath (`datapath.v`)
The Datapath module connects the **ALU** and **Register File**, defining how data flows through the processor.  
It is fully controlled by the **Control Unit**.

**Responsibilities:**
- Reads operands (`a`, `b`) from the Register File
- Sends operands to the ALU for computation
- Writes the ALU result (`y`) back into the Register File
- Transfers the control signals (`we`, `opcode`, `ra1`, `ra2`, `wa`) between modules

This module forms the **core dataflow backbone** of the processor.

---

### Control Unit (`control_unit.v`)
Implements the **Finite State Machine (FSM)** that sequences CPU operations.

**FSM States:**
| State | Name | Description |
|--------|------|-------------|
| `000` | **S_FETCH** | Fetch instruction from memory |
| `001` | **S_EXECUTE** | Decode and execute ALU operation |
| `010` | **S_WRITEBACK** | Write ALU result to destination register |
| `011` | **S_NEXT** | Increment Program Counter |
| `100` | **S_DONE** | Halt CPU after program completion |

**Outputs:**
- `opcode`: ALU operation selector
- `ra1`, `ra2`, `wa`: Register addresses
- `we`: Write enable
- `pc`: Program counter
- `done`: Signals program termination

The FSM ensures deterministic, cycle-accurate execution of instructions.

---

### Instruction Memory (`instruction_memory.v`)
Stores up to 256 9-bit instructions, each structured as:  
`[Opcode(3) | RA1(2) | RA2(2) | WA(2)]`.

**Functional Description:**
- Indexed by Program Counter (`pc`)
- Provides instruction to the Control Unit during FETCH stage
- Preloaded via an external file (`program.mem`) at simulation start

**Initialization Example:**
```verilog
$readmemb("program.mem", mem);
```

This enables flexible reprogramming of the CPU without source modification.

---

### Top-Level CPU (`cpu.v`)
Integrates all components into a complete 8-bit processor.  
Responsible for interconnecting the Control Unit, Datapath, and Instruction Memory.

**Flow Summary:**
```
Instruction Memory → Control Unit → Datapath → ALU → RegFile → Control Unit
```

**Responsibilities:**
- Synchronizes all modules on the main clock
- Manages instruction fetch, decode, and execution
- Exposes the system interface (clock, reset)

---

### Testbench (`cpu_tb.v`)
Provides a complete test environment for functional verification of the CPU.  
Implements automatic clock, reset, memory initialization, and waveform generation.

**Key Features:**
- Clock period: 10 ns (`always #5 clk = ~clk;`)
- Register initialization prior to execution
- Console output displaying CPU state each clock cycle
- Generates simulation waveform (`cpu.vcd`) for detailed inspection
- Supports external program modification through `program.mem`

**Sample Output:**
```
 time | PC | opcode | ra1 | ra2 | wa | R0 | R1 | R2 | R3 |  Y  | Z | C | State | WE
------------------------------------------------------------------------------------
  10  | 00 | 000    | 00  | 01  | 10 | 0A | 05 | 0F | 00 | 0F  | 0 | 0 | 000   | 1
```

---

## Instruction Set

| Opcode | Operation | Description |
|---------|------------|-------------|
| `000` | ADD | Add two registers |
| `001` | SUB | Subtract two registers |
| `010` | AND | Bitwise AND |
| `011` | OR | Bitwise OR |
| `100` | XOR | Bitwise XOR |
| `101` | NOT | Bitwise inversion of operand A |
| `110` | SHL | Logical shift left |
| `111` | SHR | Logical shift right |

Example instruction file: [`program.mem`](Verilog_Code/program.mem)

---

## Simulation Output
The CPU is simulated using the provided testbench.  
Results are logged cycle-by-cycle, displaying all relevant control and datapath signals.  
A waveform dump (`cpu.vcd`) is generated for detailed visual debugging using tools such as **GTKWave**.

**View waveform:**
```bash
gtkwave cpu.vcd
```

---

## Results
- All ALU operations verified for arithmetic, logical, and shift functions.
- FSM state sequencing validated across multiple instruction cycles.
- Program Counter increments correctly and halts at program completion.
- Zero and Carry flags behave according to expected arithmetic results.
- Complete CPU functionality confirmed through behavioral simulation.

---

## Conclusion  
The design and implementation of the **8-bit CPU** were successfully completed, demonstrating a fully functional processor built entirely from fundamental digital logic modules. The system integrates an **ALU**, **Register File**, **Control Unit**, **Datapath**, and **Instruction Memory**, all operating under a single clock domain and coordinated through a finite state machine.  

Simulations confirmed that the CPU correctly executes a sequence of **arithmetic**, **logical**, and **shift operations** based on 9-bit instructions loaded from `program.mem`. The control unit efficiently manages the instruction flow through the **FETCH–EXECUTE–WRITEBACK** stages, while the ALU and register file handle data processing and storage reliably.  

Although the CPU does not include branching or jump mechanisms, its modular and synchronous design makes it an excellent base for extending into more advanced architectures.  
Overall, this project demonstrates a clear understanding of **how a processor executes binary instructions at the hardware level**, combining control logic, datapath design, and verification into a cohesive and educational implementation.


---

## License
This project is released under an open-source license for academic and educational use.  
Users may reproduce, modify, and extend the design with proper attribution.

---

