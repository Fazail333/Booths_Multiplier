module shifting #(
    parameter Width_A = 16,     // Width of A is 16 bit
    parameter Width_A_EX = 33   // Width of extended A is 33 bit
) (
    input logic [Width_A-1:0] in,
    
    output logic [Width_A_EX-1:0] out
);

assign out = {in, 16'h0000, 1'b0};

endmodule