module partial_product(
    input logic [32:0]in,
    input logic [15:0]in_B,
    
    input logic ld,
    input logic en,

    input logic clk,
    input logic reset,
    
    output logic [32:0]out 
);

logic [32:0]start;
assign start = {16'h0000,in_B,1'b0};

always_ff @( posedge clk ) begin
    if (reset)begin
        out <= 33'h00000000; 
    end
    else begin
        if (ld) begin
            out <= start;
        end
        else if (en) begin
            out <= in;
        end
    end
end
    
endmodule