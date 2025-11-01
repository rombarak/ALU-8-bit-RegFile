// datapath.v
// -----------------------------------------------------------------------------
// EXPLANATION
// -----------------------------------------------------------------------------
// Core datapath module integrating the ALU and Register File.
// Fetches operands (a,b) from the RegFile, performs the ALU operation
// defined by 'opcode', and writes the result (y) back to the destination register.
// Serves as the main computation backbone of the 8-bit CPU architecture.
// -----------------------------------------------------------------------------

module datapath (clk,we,ra1,ra2,wa,opcode,y);
  input clk;
  input we;
  input [1:0] ra1, ra2, wa;
  input [2:0] opcode;
  output [7:0] y;

  wire [7:0] a, b;  // data from RegFile to ALU
  wire z, c;        // flags from ALU

  // Register File instance
  regfile RF (
    .clk(clk),
    .we(we),
    .ra1(ra1),
    .ra2(ra2),
    .wa(wa),
    .wd(y),       // ALU result goes back to RegFile
    .rd1(a),
    .rd2(b)
  );

  // ALU instance
  alu8 ALU (
    .a(a),
    .b(b),
    .opcode(opcode),
    .y(y),
    .z(z),
    .c(c)
  );

endmodule
