module final_product #(
    parameter WIDTH_FP = 32     // Final Product
) (
    input logic [WIDTH_FP-1:0]  in,
    input logic                 en_fp,

    input logic                 reset,
    input logic                 clk,

    output logic [WIDTH_FP-1:0] product
);

always_ff @(posedge clk or negedge reset or posedge en_fp) begin
    if ((!reset) | (!en_fp)) begin
        product <= 0;
    end
    else if (en_fp) begin
        product <= in;
    end
end
    
endmodule