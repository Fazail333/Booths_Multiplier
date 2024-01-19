// This mux is use as Booth's Table 

module mux_4x1 #(
  parameter WIDTH = 16
) (
  input logic [1:0]       sel,
  
  input logic [WIDTH-1:0] seg0,
  input logic [WIDTH-1:0] seg1,

  output logic [WIDTH-1:0] out    // 16-bit ouput      
);

always_comb begin
    case (sel)
      2'b00: out = 16'h00000;
      2'b01: out = seg0;
      2'b10: out = seg1;
      2'b11: out = 16'h00000;
      default: out = 16'h00000;
    endcase
  end

endmodule