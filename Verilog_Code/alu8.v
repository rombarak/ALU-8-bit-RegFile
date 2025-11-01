// alu8.v 
// -----------------------------------------------------------------------------
// EXPLANATION
// -----------------------------------------------------------------------------
// This ALU (Arithmetic Logic Unit) executes 8-bit arithmetic and logical
// operations according to a 3-bit opcode. It supports addition, subtraction,
// bitwise logic (AND, OR, XOR, NOT), and single-bit shift operations.
//
// The module outputs the 8-bit result (y), a zero flag (z) that indicates
// whether the result is zero, and a carry flag (c) used for arithmetic overflow
// or borrow detection.
//
// This design is purely combinational and serves as the core computation
// element within the 8-bit CPU datapath.
// -----------------------------------------------------------------------------

module alu8 (a,b,opcode,y,z,c); 
  input [7:0] a;        // first input operand
  input [7:0] b;        // second input operand
  input [2:0] opcode;   // operation code (selects the operation)
  output reg [7:0] y;   // operation result
  output reg c;         // carry flag
  output reg z;         // zero flag
  
  // internal 9-bit adder/subtractor to capture carry/borrow
  wire [8:0] add9 = {1'b0, a} + {1'b0, b};
  wire [8:0] sub9 = {1'b0, a} - {1'b0, b}; 
  
  always @(*) begin
    // safe defaults to avoid latches
    y = 8'h00;
    c = 1'b0;
    z = 1'b0;
    
    case (opcode)
      3'b000: begin        // ADD
        y = add9[7:0];
        c = add9[8];       // carry-out bit
      end
      
      3'b001: begin        // SUB
        y = sub9[7:0];
        c = sub9[8];       // borrow bit (for unsigned, it's inverted carry)
      end
      
      3'b010: begin        // AND
        y = a & b;
      end
      
      3'b011: begin        // OR
        y = a | b;
      end
      
      3'b100: begin        // XOR
        y = a ^ b;
      end
      
      3'b101: begin        // NOT (invert 'a')
        y = ~a;
      end
      
      3'b110: begin        // SHIFT LEFT
        y = a << 1;
      end
      
      3'b111: begin        // SHIFT RIGHT
        y = a >> 1;
      end
      
      default: begin
        y = 8'h00;
        c = 1'b0;
      end
    endcase

    // Zero flag
    z = (y == 8'h00);
  end
endmodule
