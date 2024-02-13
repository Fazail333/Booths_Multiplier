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

  output logic                    valid_out,          //  count_16 for Final product (i.e answer)
  output logic [WIDTH_PRODUCT-1:0] product
);
 
logic en_i, en_fp, en_pp, count_16;     // Enables     

logic [WIDTH_PP-1:0] pp;      // Partial product must be 33-bit 

logic [1:0] c_in, mux_sel;

// Booth Multiplier Datapath
datapath dp_bm (
  .multiplier_b(in_b),
  .multiplicand_a(in_a),

  .en_i(en_i),
  .en_pp(en_pp),
  .en_fp(en_fp),
  .sel(mux_sel),

  .valid_in(valid_in),
  .count_16(count_16),

  .clk(clk),
  .reset(reset),
  
  .out(c_in),
  .product(product)
);

// Booth Multiplier Controller
controller cp_bm (
  .valid_in(valid_in),
  .count_16(count_16),
  .in(c_in),

  .clk(clk),
  .reset(reset),

  .mux_sel(mux_sel),
  .en_i(en_i),
  .en_fp(en_fp),
  .en_pp(en_pp),
  .valid_out(valid_out)
);

endmodule
