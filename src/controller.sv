module controller (
    input logic  load,
    input logic  load_pp,
    input logic  count,

    input logic  clk,
    input logic  reset,

    output logic load_p,
    output logic enable_a,
    output logic enable_b,
    output logic enable_pp
);

logic [1:0] c_state, n_state;
parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

always_ff @ (posedge clk or posedge reset) begin
    //reset is active high
    if (reset) 
    c_state <= S0;
    else
    c_state <= n_state;
end

//next_state always block
always_comb begin
  case (c_state)
    S0: begin   
      if (load) n_state = S1;
      else n_state = S0; 
    end
    S1: begin   
      if (load_pp) n_state = S2;
      else n_state = S1; 
    end
    S2: begin   
      if (count) n_state = S3;
      else n_state = S2; 
    end
    S3: begin    
      if(count) n_state = S3;
      else n_state = S0; 
    end
    default: n_state = S0;
  endcase
end

//output always block
always_comb begin
  case (c_state)
    S0: begin   
      enable_a  = 1'b0;
      enable_b  = 1'b0;
      enable_pp = 1'b0;
      load_p    = 1'b0;  
    end

    S1: begin   
      enable_a  = 1'b1;
      enable_b  = 1'b1;
      enable_pp = 1'b0;
      load_p    = 1'b0;
    end

    S2: begin   
      enable_a  = 1'b1;
      enable_b  = 1'b1;
      enable_pp = 1'b1;
      load_p    = 1'b0; 
    end

    S3: begin   
      enable_a  = 1'b1;
      enable_b  = 1'b1;
      enable_pp = 1'b1;
      load_p    = 1'b1;
    end

    default: begin  
      enable_a  = 1'b0;
      enable_b  = 1'b0;
      enable_pp = 1'b0;
      load_p    = 1'b0;  
    end
  endcase
end
    
endmodule