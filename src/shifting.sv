module shifting #(
    parameter WIDTH = 16,     // Width of A is 16 bit
    parameter WIDTH_EX = 33   // Width of extended A is 33 bit
) (
    input logic [WIDTH-1:0] in,
    
    output logic [WIDTH_EX-1:0] out
);

assign out = {in, 16'h0000, 1'b0};

endmodule