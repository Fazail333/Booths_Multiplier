module twos_complement (
    input logic [15:0]in,      // input 
    output logic [15:0]out     // 2's complement output
);
logic [15:0]inverse;

always_comb begin
    inverse = ~in;
    out = (inverse + 1'b1);
end

endmodule