module partial_product #(
    parameter Width_PP = 33,    // Partial Product Width 33-bit 
    parameter Width_in = 16     // Input width 16-bit
) (
    input logic [Width_PP-1:0] in,
    input logic [Width_in-1:0] in_B,
    
    input logic                ld,
    input logic                ld_p,
    input logic                en,

    input logic                clk,
    input logic                reset,
    
    output logic [Width_PP-1:0] out 
);

logic [Width_PP-1:0]start;

assign start = {16'h0000, in_B, 1'b0};

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
