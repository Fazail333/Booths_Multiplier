// adder file add multiplicand and
// partial products.

module adder #(
  parameter Width = 33
) ( 
  input logic  [Width-1:0] in_a,
  input logic  [Width-1:0] in_p,

  output logic [Width-1:0] out 
);

assign out = in_a + in_p;
    
endmodule