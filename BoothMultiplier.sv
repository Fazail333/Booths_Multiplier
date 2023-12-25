module Booth_Multiplier (
    input logic [15:0] in_A,
    input logic [15:0] in_B,
    
    input logic clk,
    input logic reset,

    input logic ld_PP,
    input logic ld,

    output logic [31:0] product
);

    logic [1:0] sel;
    logic en_a, en_b, en_pp, ld_p, count;
    logic [32:0] pp;

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
        //.sel(sel),
        .clk(clk),
        .reset(reset),
        //.PP(pp[1:0]),  // Corrected width of .PP
        .product(product)
    );

    Controller CP_BM (
        .load(ld),
        .load_PP(ld_PP),
        //.PP(pp[1:0]),  // Corrected width of .PP
        .count(count),
        .clk(clk),
        .reset(reset),
        //.sel(sel),
        .load_P(ld_p),
        .enable_A(en_a),
        .enable_B(en_b),
        .enable_PP(en_pp)
    );

endmodule
