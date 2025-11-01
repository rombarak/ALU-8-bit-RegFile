// cpu.v
// --------------------------------------------------------------------------
// EXPLANATION
// --------------------------------------------------------------------------
// This is the top-level CPU module integrating all major components:
// the Control Unit, Instruction Memory, and Datapath (ALU + RegFile).
// The Control Unit manages instruction flow and synchronization,
// fetching instructions from memory, decoding them, and controlling
// datapath operations. The Datapath executes ALU operations and updates
// registers as directed. The design demonstrates a clean modular
// structure for a simple sequential 8-bit processor.
// --------------------------------------------------------------------------

module cpu (clk,reset);
  input clk;
  input reset;

  // WIRES BETWEEN MODULES
  wire [2:0] opcode;       // ALU operation code
  wire [1:0] ra1, ra2, wa; // register addresses
  wire [7:0] y;            // ALU result
  wire [8:0] instr;        // instruction from memory
  wire we;                 // write enable for RegFile
  wire [7:0] pc;           // program counter
  wire done;               // program finished

  // CONTROL UNIT 
  control_unit CU (
    .clk(clk),
    .reset(reset),
    .instr(instr),     // gets instruction from instruction_memory
    .opcode(opcode),   // sends to ALU (through datapath)
    .ra1(ra1),         // sends to RegFile
    .ra2(ra2),         // sends to RegFile
    .wa(wa),           // sends to RegFile
    .we(we),           // sends to RegFile (write enable)
    .pc(pc),           // sends to Instruction Memory
    .done(done)        // status flag
  );

  // INSTRUCTION MEMORY 
  instruction_memory IM (
    .addr(pc),         // receives PC from control unit
    .instr(instr)      // sends instruction back to control unit
  );

  // DATAPATH (includes RegFile + ALU) ---
  datapath DP (
    .clk(clk),
    .we(we),           // from control unit
    .ra1(ra1),         // from control unit
    .ra2(ra2),         // from control unit
    .wa(wa),           // from control unit
    .opcode(opcode),   // from control unit
    .y(y)              // result
  );

endmodule
