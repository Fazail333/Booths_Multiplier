// Arithematic Right Shift: It shifts
// the output of the adder.

module ars #(
  parameter Width = 33
) (
  input logic  [Width-1:0] in,

  output logic [Width-1:0] out
);

assign out = {in[Width-1], in[Width-1:1]};
    
endmodule
