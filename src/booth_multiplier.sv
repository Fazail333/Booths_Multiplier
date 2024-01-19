module booth_multiplier #(
  parameter WIDTH_IN = 16,
  parameter WIDTH_PP = 33,         // Width of Partial Products
  parameter WIDTH_PRODUCT = 32
) (
  input logic  [WIDTH_IN-1:0] in_a,
  input logic  [WIDTH_IN-1:0] in_b,
    
  input logic                     clk,
  input logic                     reset,

  input logic                     ld_pp,  // load for Partial product
  input logic                     ld,     // load for inputs 

  output logic                    ld_p,          //  Load for Final product (i.e answer)
  output logic [WIDTH_PRODUCT-1:0] product
);
 
logic en_a, en_b,    //  Enable for multiplier and multiplicand
      en_pp,         //  Enable for Partial Products
      count;          //  count 16-bits 

logic [WIDTH_PP-1:0] pp;      // Partial product must be 33-bit 

// Booth Multiplier Datapath
datapath dp_bm (
  .multiplier_b(in_b),
  .multiplicand_a(in_a),
  .enable_a(en_a),
  .enable_b(en_b),
  .enable_pp(en_pp),
  .load(ld),
  .load_pp(ld_pp),
  .load_p(ld_p),
  .count(count),
  .clk(clk),
  .reset(reset),
  .product(product)
);

// Booth Multiplier Controller
controller cp_bm (
  .load(ld),
  .load_pp(ld_pp),
  .count(count),
  .clk(clk),
  .reset(reset),
  .load_p(ld_p),
  .enable_a(en_a),
  .enable_b(en_b),
  .enable_pp(en_pp)
);

endmodule
