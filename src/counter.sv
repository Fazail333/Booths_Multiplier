// 5-bit counter

module counter #(
  parameter WIDTH = 5
) (
  input logic              clk,
  input logic              reset,
  input logic              start,
    
  input logic              en_pp,

  output logic [WIDTH-1:0] out
);

always_ff @( posedge clk ) begin
    if (reset | start)begin
        out <= 5'h0;
    end else if (en_pp) begin
        out <= out + 1;
    end
end
    
endmodule
