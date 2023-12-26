// 5-bit counter

module counter #(
  parameter Width = 5
) (
  input logic              clk,
  input logic              reset,
    
  input logic              en_PP,

  output logic [Width-1:0] out
);

always_ff @( posedge clk ) begin
    if (reset)begin
        out <= 5'h0;
    end else if (en_PP) begin
        out <= out + 1;
    end
end
    
endmodule