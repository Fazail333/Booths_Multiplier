//Arithematic Right Shift

module ARS (
    input logic [32:0] in,
    output logic [32:0] out
);

    assign out = {in[32], in[32:1]};
    
endmodule
