module partial_product #(
    parameter WIDTH_PP = 33,    // Partial Product Width 33-bit 
    parameter WIDTH_IN = 16     // Input width 16-bit
) (
    input logic [WIDTH_PP-1:0] in,
    input logic [WIDTH_IN-1:0] in_b,
    
    input logic                ld,
    input logic                ld_p,
    input logic                en,

    input logic                clk,
    input logic                reset,
    
    output logic [WIDTH_PP-1:0] out 
);

logic [WIDTH_PP-1:0]start;

assign start = {16'h0000, in_b, 1'b0};

always_ff @( posedge clk ) begin
    if (reset | ld_p)begin
        out <= 33'h00000000; 
    end
    else begin
        if (ld) begin
            out <= start;
        end else if (en) begin
            out <= in;
        end
    end
end
    
endmodule
