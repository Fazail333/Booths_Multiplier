module final_product #(
    parameter Width_PP = 33,    // Partial Product
    parameter Width_FP = 32     // Final Product
) (
    input logic [Width_PP-1:0]  in,
    input logic                 ld,

    input logic                 reset,
    input logic                 clk,

    output logic [Width_FP-1:0] product
);

always_ff @(posedge clk) begin
    if (reset) begin
        product <= 33'h000000;
    end
    else if (ld) begin
        product <= in[Width_PP-1:1];
    end
end
    
endmodule