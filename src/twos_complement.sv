module twos_complement #(
    parameter WIDTH = 16
) (
    input logic [WIDTH-1:0] in,      // input

    output logic [WIDTH-1:0] out     // 2's complement output
);

logic [WIDTH-1:0]inverse;

always_comb begin
    inverse = ~in;
    out = (inverse + 1'b1);
end

endmodule