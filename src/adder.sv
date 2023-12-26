// adder file add multiplicand and
// partial products.

module adder #(
  parameter Width = 33
) ( 
  input  logic [Width-1:0] in_A,
  input  logic [Width-1:0] in_P,

  output logic [Width-1:0] out 
);

assign out = in_A + in_P;
    
endmodule