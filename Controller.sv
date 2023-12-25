module Controller (
    input logic load,
    input logic load_PP,
    //input logic [1:0]PP,
    input logic count,

    input logic clk,
    input logic reset,

    //output logic [1:0]sel,
    output logic load_P,
    output logic enable_A,
    output logic enable_B,
    output logic enable_PP
);

logic [1:0] c_state, n_state;
parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

always_ff @ (posedge clk or posedge reset)
begin
    //reset is active high
    if (reset) 
    c_state <= S0;
    else
    c_state <= n_state;
end

//next_state always block
always_comb
begin
case (c_state)
    S0: begin   if (load) n_state = S1;
                else n_state = S0; end

    S1: begin   if (load_PP) n_state = S2;
                else n_state = S1; end

    S2: begin   if (count) n_state = S3;
                else n_state = S2; end

    S3: begin    if(count) n_state = S3;
                else n_state = S0; end
    
    default: n_state = S0;
endcase
end

//output always block
always_comb
begin
case (c_state)
    S0: begin   enable_A  = 1'b0;
                enable_B  = 1'b0;
                enable_PP = 1'b0;
                load_P    = 1'b0;  
        end

    S1: begin   enable_A  = 1'b1;
                enable_B  = 1'b1;
                enable_PP = 1'b0;
                load_P    = 1'b0;
        end

    S2: begin   enable_A  = 1'b1;
                enable_B  = 1'b1;
                enable_PP = 1'b1;
                load_P    = 1'b0; 
        end

    S3: begin   enable_A  = 1'b1;
                enable_B  = 1'b1;
                enable_PP = 1'b1;
                load_P    = 1'b1;
        end

    default: begin  enable_A  = 1'b0;
                    enable_B  = 1'b0;
                    enable_PP = 1'b0;
                    load_P    = 1'b0;  
            end
endcase
end
    
endmodule