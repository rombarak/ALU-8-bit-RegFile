// control_unit.v
// -----------------------------------------------------------------------------
// EXPLANATION
// -----------------------------------------------------------------------------
// Control Unit – the CPU’s finite state machine that orchestrates execution flow.
// Sequentially cycles through five states: FETCH, EXECUTE, WRITEBACK, NEXT, DONE.
// Decodes each 9-bit instruction into ALU opcode and register addresses,
// manages the program counter (PC), and enables RegFile writes when needed.
// Serves as the core logic controller driving the 8-bit CPU pipeline.
// -----------------------------------------------------------------------------

module control_unit (clk, reset, instr, opcode, ra1, ra2, wa, we, pc, done);
  input clk;
  input reset;

  // input from instruction memory
  input [8:0] instr;          // 9-bit instruction from memory

  // outputs to datapath
  output reg [2:0] opcode;        // operation for ALU
  output reg [1:0] ra1, ra2, wa;  // register addresses
  output reg we;                  // write enable
  output reg [7:0] pc;            // program counter (for instruction memory)
  output reg done;                // signals when program is finished

  // FSM states 
  reg [2:0] state, next_state;

  parameter S_FETCH     = 3'b000;
  parameter S_EXECUTE   = 3'b001;
  parameter S_WRITEBACK = 3'b010;
  parameter S_NEXT      = 3'b011;
  parameter S_DONE      = 3'b100;

  // Sequential process – update state and program counter
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S_FETCH;
      pc <= 8'b00000000;
    end else begin
      state <= next_state;

      // update program counter only in NEXT state
      if (state == S_NEXT)
        pc <= pc + 1;
    end
  end

  // Combinational process – control logic + done flag
  always @(*) begin
    // default signals
    opcode = 3'b000;
    ra1 = 2'b00;
    ra2 = 2'b00;
    wa  = 2'b00;
    we  = 1'b0;
    next_state = state;
    done = 1'b0;

    case (state)
      // FETCH – load current instruction from memory
      S_FETCH: begin
        {opcode, ra1, ra2, wa} = instr;  // decode instruction
        next_state = S_EXECUTE;
      end

      // EXECUTE – perform ALU operation
      S_EXECUTE: begin
        {opcode, ra1, ra2, wa} = instr;  // decode instruction
        next_state = S_WRITEBACK;
      end

      // WRITEBACK – enable RegFile write
      S_WRITEBACK: begin
        {opcode, ra1, ra2, wa} = instr;  // decode instruction
        we = 1'b1;
        next_state = S_NEXT;
      end

      // NEXT – move to next instruction
      S_NEXT: begin
         {opcode, ra1, ra2, wa} = instr;  // decode instruction
        if (pc == 8'b11111111) begin
          next_state = S_DONE;  // stop at end of memory
        end else begin
          next_state = S_FETCH;
        end
      end

      // DONE – program finished
      S_DONE: begin
        done = 1'b1;
        we = 1'b0;
        next_state = S_DONE;
      end

      default: next_state = S_FETCH;
    endcase
  end
endmodule
