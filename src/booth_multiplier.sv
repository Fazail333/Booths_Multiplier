module booth_multiplier #(
  parameter WIDTH_IN = 16,
  parameter WIDTH_PP = 33,         // Width of Partial Products
  parameter WIDTH_PRODUCT = 32
) (
  input logic  [WIDTH_IN-1:0] in_a,
  input logic  [WIDTH_IN-1:0] in_b,
  
  input logic                     valid_in,     // valid_in for inputs 
    
  input logic                     clk,
  input logic                     reset,

  output logic                    valid_out,          //  valid_out for Final product (i.e answer)
  output logic [WIDTH_PRODUCT-1:0] product
);
 
logic en_i, en_fp, en_pp;     // Enables     

logic [WIDTH_PP-1:0] pp;      // Partial product must be 33-bit 

// Booth Multiplier Datapath
datapath dp_bm (
  .multiplier_b(in_b),
  .multiplicand_a(in_a),

  .en_i(en_i),
  .en_pp(en_pp),
  .en_fp(en_fp),

  .valid_in(valid_in),
  .valid_out(valid_out),

  .clk(clk),
  .reset(reset),
  
  .product(product)
);

// Booth Multiplier Controller
controller cp_bm (
  .valid_in(valid_in),

  .valid_out(valid_out),
  .clk(clk),
  .reset(reset),

  .en_i(en_i),
  .en_fp(en_fp),
  .en_pp(en_pp)
);

endmodule
