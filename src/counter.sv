// 5-bit counter

module counter #(
  parameter WIDTH = 4
) (
  input logic              clk,
  input logic              reset,
  input logic              load,
    
  input logic              en_pp,

  output logic [WIDTH-1:0] out
);

always_ff @( posedge clk ) begin
    if (reset | load)begin
        out <= 0;
    end else if (en_pp) begin
        out <= out + 1;
    end
end
    
endmodule
