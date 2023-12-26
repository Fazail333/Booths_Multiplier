// Compare the value of clock cycles to 15-bits

module comparator #(
   parameter Width = 5               // Counter width 
) (
   input logic [Width-1:0] in,

   input logic             reset,
   input logic             clk,
    
   output logic            comp      // comparator 
);

always_ff @(posedge clk) begin
    if (reset) begin
        comp <= 1'b0;
    end
    else begin 
        if(in == 5'h0E)begin
            comp <= 1'b1;
        end else begin
            comp <= 1'b0;
        end
    end
end

endmodule