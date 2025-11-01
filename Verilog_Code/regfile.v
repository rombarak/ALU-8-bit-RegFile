// regfile.v
// ----------------------------------------------------------------------------
// EXPLANATION
// ----------------------------------------------------------------------------
// 4x8-bit Register File with dual asynchronous read ports and a single
// synchronous write port. Registers are addressed via 2-bit selectors (R0–R3).
// Data is read instantly and written on the rising clock edge when 'we' (write enable) is high.
// Core storage unit of the CPU datapath for operand fetch and result write-back.
// ----------------------------------------------------------------------------

module regfile (clk,we,ra1,ra2,wa,wd,rd1,rd2);
  input clk;                   // clock
  input we;                    // write enable
  input [1:0] ra1, ra2, wa;    // 2-bit addresses (4 registers)
  input [7:0] wd;              // write data
  output [7:0] rd1, rd2;       // read data

  // 4 registers of 8 bits each
  reg [7:0] mem [3:0];

  // asynchronous reads
  assign rd1 = mem[ra1];
  assign rd2 = mem[ra2];

  // synchronous write
  always @(posedge clk) begin
    if (we)
      mem[wa] <= wd;
  end
endmodule
