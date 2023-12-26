module Datapath #(
    parameter Width_inputs = 16,
    parameter Width_PP = 33,         // Width of Partial Products
    parameter Width_FP = 32,
    parameter Width_CO = 5           // Width of counter
) (
    input logic [Width_inputs-1:0] Multiplier_B,
    input logic [Width_inputs-1:0] Multiplicand_A,

    // Enables are the output of controller.
    input logic                    enable_A,
    input logic                    enable_B,
    input logic                    enable_PP,

    // Load are the inputs from the user.
    input logic                    load,
    input logic                    load_PP,
    input logic                    load_P,

    input logic                    clk,
    input logic                    reset,

    output logic                   count,      // count the 16 clock cycles and return 1 or 0. 
    output logic [Width_FP-1:0] product 
);

    logic [Width_inputs-1:0] A, B;           
    logic [Width_inputs-1:0] A2;             // 2's complement of A
    logic [Width_inputs-1:0] A_out;          // sel A from the booth's table 
    logic [Width_PP-1:0] A_extend;       // A convert into 33 bits
    logic [Width_PP-1:0] PP, A_PP, S_PP; // Partial Products 33-bits
    logic [Width_CO-1:0]  count_16;

    //logic [1:0] sel,   // Check the 0th and 1st bit of the partial products  

    // Inputs multiplier and multiplicand

    Input_Register Register_A (
        .in(Multiplicand_A),
        .ld(load),
        .en(enable_A),
        .clk(clk),
        .reset(reset),
        .out(A)
    );

    Input_Register Register_B (
        .in(Multiplier_B),
        .ld(load),
        .en(enable_B),
        .clk(clk),
        .reset(reset),
        .out(B)
    );
    // twos_complement is used to subtract the value using adder.

    twos_complement subtracting (
        .in(A),
        .out(A2)
    );
                
    mux4x1 Booth_table (
        .sel(PP[1:0]), 
        .seg0(A),
        .seg1(A2),
        .out(A_out)
    );

    shifting Extend_A (
        .in(A_out),
        .out(A_extend)
    );

    partial_product PProduct (
        .in(S_PP),
        .in_B(B),
        .ld(load_PP),
        .en(enable_PP),
        .clk(clk),
        .reset(reset),
        .out(PP)
    );
    
    // Add A and B
    adder addAB (
        .in_A(A_extend),
        .in_P(PP),
        .out(A_PP)
    );

    // Shift the Partial Product
    ARS PP_ASR (
        .in(A_PP),
        .out(S_PP)
    );

    counter count16 (
        .clk(clk),
        .reset(reset),
        .en_PP(enable_PP),
        .out(count_16)
    );

    comparator compare_16 (
        .in(count_16),
        .reset(reset),
        .clk(clk),
        .comp(count)
    );

    final_product multiply (
        .in(PP),
        .reset(reset),
        .ld(load_P),
        .clk(clk),
        .product(product)
    );

endmodule
