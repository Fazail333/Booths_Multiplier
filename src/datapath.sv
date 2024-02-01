module datapath #(
    parameter WIDTH_IN = 16,
    parameter WIDTH_PP = 33,         // Width of Partial Products
    parameter WIDTH_FP = 32,
    parameter WIDTH_CO = 4           // Width of counter
) (
    input logic [WIDTH_IN-1:0] multiplier_b,
    input logic [WIDTH_IN-1:0] multiplicand_a,

    // Enables are the output of controller.
    input logic                    en_i,    //enable for inputs
    input logic                    en_pp,   //enable for partial products
    input logic                    en_fp,   //enable for final product
    input logic                    valid_in,    

    input logic                    clk,
    input logic                    reset,

    output logic                   valid_out,      // count the 16 clock cycles and return 1 or 0. 
    output logic [WIDTH_FP-1:0] product 
);

    logic [WIDTH_IN-1:0] a, b;           
    logic [WIDTH_IN-1:0] a2;             // 2's complement of a
    logic [WIDTH_IN-1:0] a_out;          // sel a from the booth's table 
    logic [WIDTH_PP-1:0] a_extend;       // a convert into 33 bits
    logic [WIDTH_PP-1:0] pp, a_pp, s_pp; // Partial Products 33-bits
    logic [WIDTH_CO-1:0]  count_16; 

    // Inputs multiplier and multiplicand

    input_register register_a (
        .in(multiplicand_a),

        .en(en_i),

        .clk(clk),
        .reset(reset),

        .out(a)
    );

    input_register register_b (
        .in(multiplier_b),

        .en(en_i),

        .clk(clk),
        .reset(reset),

        .out(b)
    );
    // twos_complement is used to subtract the value using adder.

    twos_complement subtracting (
        .in(a),

        .out(a2)
    );
                
    mux_4x1 booth_table (
        .sel(pp[1:0]), 

        .seg0(a),
        .seg1(a2),

        .out(a_out)
    );

    shifting extend_a (
        .in(a_out),

        .out(a_extend)
    );

    partial_product partial_product (
        .in(s_pp),
        .in_b(b),

        .en_i(en_i),
        .en_fp(en_fp),
        .en_pp(en_pp),

        .clk(clk),
        .reset(reset),

        .out(pp)
    );
    
    // Add a and b
    adder addab (
        .in_a(a_extend),
        .in_p(pp),

        .out(a_pp)
    );

    // Shift the Partial Product
    ars pp_ars (
        .in(a_pp),

        .out(s_pp)
    );

    counter count16 (
        .load(valid_in),

        .reset(reset),
        .clk(clk),

        .en_pp(en_pp),

        .out(count_16)
    );

    comparator compare_16 (
        .in(count_16),

        .reset(reset),
        .clk(clk),

        .valid_out(valid_out)
    );

    final_product multiply (
        .in(pp[WIDTH_PP-1:1]),

        .en_fp(en_fp),

        .reset(reset),
        .clk(clk),
        
        .product(product)
    );

endmodule
