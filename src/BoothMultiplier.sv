module Booth_Multiplier #(
  parameter Width_inputs = 16,
  parameter Width_PP = 33,         // Width of Partial Products
  parameter Width_product = 32
) (
  input logic  [Width_inputs-1:0] in_A,
  input logic  [Width_inputs-1:0] in_B,
    
  input logic                     clk,
  input logic                     reset,

  input logic                     ld_PP,  // load for Partial product
  input logic                     ld,     // load for inputs 

  output logic [Width_product-1:0] product
);
 
logic en_a, en_b, \   //  Enable for multiplier and multiplicand
      en_pp,      \   //  Enable for Partial Products
      ld_p,       \   //  Load for Final product (i.e answer)
      count;          //  count 16-bits 

logic [Width_PP-1:0] pp;      // Partial product must be 33-bit 

// Booth Multiplier Datapath
Datapath DP_BM (
  .Multiplier_B(in_B),
  .Multiplicand_A(in_A),
  .enable_A(en_a),
  .enable_B(en_b),
  .enable_PP(en_pp),
  .load(ld),
  .load_PP(ld_PP),
  .load_P(ld_p),
  .count(count),
  .clk(clk),
  .reset(reset),
  .product(product)
);

// Booth Multiplier Controller
Controller CP_BM (
  .load(ld),
  .load_PP(ld_PP),
  .count(count),
  .clk(clk),
  .reset(reset),
  .load_P(ld_p),
  .enable_A(en_a),
  .enable_B(en_b),
  .enable_PP(en_pp)
);

endmodule
