// compare the value of clock cycles to 15-bits

module comparator #(
   parameter WIDTH = 4               // Counter width 
) (
   input logic [WIDTH-1:0] in,

   input logic             reset,
   input logic             clk,

   output logic            valid_out      // comparator 
);

always_ff @(posedge clk) begin
    if (reset) begin
        valid_out <= 1'b0;
    end
    else begin 
        if(in == 4'hE)begin
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule