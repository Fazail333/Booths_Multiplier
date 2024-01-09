module twos_complement #(
    parameter Width = 16
) (
    input logic [Width-1:0] in,      // input

    output logic [Width-1:0] out     // 2's complement output
);

logic [Width-1:0]inverse;

always_comb begin
    inverse = ~in;
    out = (inverse + 1'b1);
end

endmodule