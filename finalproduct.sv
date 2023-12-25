module final_product (
    input logic [32:0]in,
    input logic ld,

    input logic reset,
    input logic clk,

    output logic [31:0]product
);

always_ff @(posedge clk) begin
    if (reset) begin
        product <= 33'h000000;
    end
    else if (ld) begin
        product <= in[32:1];
    end
end
    
endmodule