module final_product #(
    parameter WIDTH_PP = 33,    // Partial Product
    parameter WIDTH_FP = 32     // Final Product
) (
    input logic [WIDTH_PP-1:0]  in,
    input logic                 ld,

    input logic                 reset,
    input logic                 clk,

    output logic [WIDTH_FP-1:0] product
);

always_ff @(posedge clk) begin
    if (reset) begin
        product <= 33'h000000;
    end
    else if (ld) begin
        product <= in[WIDTH_PP-1:1];
    end
end
    
endmodule