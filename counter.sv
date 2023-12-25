module counter (
    input logic clk,
    input logic reset,
    
    input logic en_PP,

    output logic [4:0]out
);

always_ff @( posedge clk ) begin
    if (reset)begin
        out <= 5'h0;
    end
    else if (en_PP)
        out <= out + 1;
end
    
endmodule