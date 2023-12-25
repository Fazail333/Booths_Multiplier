module shifting(
    input logic [15:0]in,
    output logic [32:0]out
);

assign out = {in, 16'h0000, 1'b0};

endmodule