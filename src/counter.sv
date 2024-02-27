// 5-bit counter

module counter #(
  parameter WIDTH = 4
) (
  input logic              clk,
  input logic              reset,
  input logic              clear,
    
  input logic              en_pp,     // enable use for counting bits.
  //input logic              en_i,

  output logic [WIDTH-1:0] out
);

always_ff @( posedge clk or negedge reset ) begin
    if (!reset /*| clear*/)begin
        out <= 0;
    end else begin 
      if (clear) begin
          out <= 0;
      end
      else if (en_pp) begin
          out <= out + 1;
      end
    end
end
    
endmodule
