module Input_Register #(
    parameter Width = 16
) (
    input logic [Width-1:0] in,           // input 
    input logic             ld,           // load the input
    input logic             en,           // enable the input 

    input logic             clk,
    input logic             reset,

    output logic [Width-1:0] out
);

logic [Width-1:0] hold;

always_ff @( posedge clk) begin
    if (reset) begin 
        out <= 16'h00000;
    end 
    else begin
        if (ld) begin
            hold <= in;              
        end else if (en) begin
            out <= hold;            // enable the input to output
        end
    end
end
    
endmodule
