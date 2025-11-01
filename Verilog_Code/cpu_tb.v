//cpu_tb.v
// ---------------------------------------------------------------------------
// EXPLANATION
// ---------------------------------------------------------------------------
// This is the main testbench for the 8-bit CPU. It verifies the full system
// functionality by simulating clock and reset signals, initializing registers,
// and automatically loading program instructions from "program.mem".
// The testbench prints a detailed cycle-by-cycle trace, including
// program counter (PC), opcode, register states (R0–R3), ALU outputs,
// flags (Z and C), and control unit state transitions.
// A waveform dump ("cpu.vcd") is also generated for visual debugging.
// This provides full visibility into the CPU’s internal operation and
// is easily customizable for extended tests or new instruction sets.
// ---------------------------------------------------------------------------
`timescale 1ns/1ps
module cpu_tb;
  reg clk, reset;

  cpu uut (
    .clk(clk),
    .reset(reset)
  );

  // 10ns clock
  always #5 clk = ~clk;

  integer i;

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_tb);

    clk = 0;
    reset = 1;
    #10 reset = 0;

    // Initialize registers (for test variety)
    uut.DP.RF.mem[0] = 8'h0A; // R0 = 10
    uut.DP.RF.mem[1] = 8'h05; // R1 = 5
    uut.DP.RF.mem[2] = 8'h00;
    uut.DP.RF.mem[3] = 8'h00;

    $display("\n--- Simulation Start (Loaded from program.mem) ---");
    $display(" time | PC | opcode |  ra1  |  ra2  |  wa |  R0  |  R1  |  R2  |  R3  |  Y  | Z | C | CUst | WE ");
    $display("---------------------------------------------------------------------------------------------");

    // Print every cycle on posedge
    repeat (100) begin
      @(posedge clk);
      $display("%5t | %2d |   %03b   |  %02b  |  %02b  | %02b |  %02h  |  %02h  |  %02h  |  %02h  |  %02h  | %1b | %1b |  %03b  |  %1b",
        $time,
        uut.CU.pc,
        uut.CU.opcode,
        uut.CU.ra1,
        uut.CU.ra2,
        uut.CU.wa,
        uut.DP.RF.mem[0],
        uut.DP.RF.mem[1],
        uut.DP.RF.mem[2],
        uut.DP.RF.mem[3],
        uut.DP.ALU.y,      // ALU result
        uut.DP.ALU.z,      // Zero flag from ALU
        uut.DP.ALU.c,      // Carry/Borrow flag from ALU
        uut.CU.state,      // CU FSM state (internal reg)
        uut.CU.we          // Write Enable from CU
      );
    end

    $display("---------------------------------------------------------------------------------------------");
    $display("--- Simulation Complete ---");
    $finish;
  end
endmodule
