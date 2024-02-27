module partial_product #(
    parameter WIDTH_PP = 33,    // Partial Product Width 33-bit 
    parameter WIDTH_IN = 16     // Input width 16-bit
) (
    input logic [WIDTH_PP-1:0] in,
    input logic [WIDTH_IN-1:0] in_b,
    
    input logic                en_i,
    //input logic                en_fp,
    //input logic                en_pp,

    input logic                clk,
    input logic                reset,
    
    output logic [WIDTH_PP-1:0] out 
);

always_ff @( posedge clk or negedge reset ) begin
    if (!reset)begin
        out <= 0; 
    end
    else begin
        if (en_i) begin
            out <= {16'h0000, in_b, 1'b0};
        end/* else if (en_pp) begin
            out <= in;
        end*/
        else begin
            out <= in;
        end
    end
end
    
endmodule
