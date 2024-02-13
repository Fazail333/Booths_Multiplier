// compare the value of clock cycles to 15-bits

module comparator #(
   parameter WIDTH = 4               // Counter width 
) (
   input logic [WIDTH-1:0] in,

   input logic             reset,
   input logic             clk,

   output logic            count_16      // comparator 
);

always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
        count_16 <= 1'b0;
    end
    else begin 
        if(in == 4'hf)begin
            count_16 <= 1'b1;
        end else begin
            count_16 <= 1'b0;
        end
    end
end

endmodule