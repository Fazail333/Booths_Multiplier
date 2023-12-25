module comparator (
    input logic [4:0]in,
    input logic reset,
    input logic clk,
    
    output logic comp
);

always_ff @(posedge clk) begin
    if (reset) begin
        comp <= 1'b0;
    end
    else begin 
        if(in == 5'h0E)begin
            comp <= 1'b1;
        end
        else begin
            comp <= 1'b0;
        end
    end
end

endmodule