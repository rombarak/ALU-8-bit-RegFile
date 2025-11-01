// instruction_memory.v
// --------------------------------------------------------------------------
// EXPLANATION
// --------------------------------------------------------------------------
// This module implements an instruction memory for the 8-bit CPU.
// It stores up to 256 program instructions, each 9 bits wide
// (3 bits for opcode + 6 bits for register addressing).
// The memory is preloaded from an external file ("program.mem") at startup,
// allowing easy program updates without modifying the hardware design.
// The control unit provides the address (PC), and the corresponding
// instruction is read combinationally and sent to the datapath.
// --------------------------------------------------------------------------

module instruction_memory (addr,instr);
  input  [7:0] addr;         // address from control unit (PC)
  output reg [8:0] instr;    // instruction output

  reg [8:0] mem [0:255];     // up to 256 instructions

  initial begin
    $readmemb("program.mem", mem);   // load instructions from file
  end

  always @(*) begin
    instr = mem[addr];
  end
endmodule
