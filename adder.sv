module adder(
    input logic [32:0]in_A,
    input logic [32:0]in_P,

    output logic [32:0]out 
);

assign out = in_A + in_P ;
    
endmodule