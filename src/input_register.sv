module input_register #(
    parameter WIDTH = 16
) (
    input logic [WIDTH-1:0] in,           // input 
    //input logic             ld,           // load the input
    input logic             en,           // enable the input 

    input logic             clk,
    input logic             reset,

    output logic [WIDTH-1:0] out
);

always_ff @( posedge clk or negedge reset ) begin
    if (!reset) begin 
        out <= 0;
    end 
    else begin
        if (en) begin
            out <= in;              
        end 
    end
end
    
endmodule
