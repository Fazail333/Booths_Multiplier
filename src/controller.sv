module controller (
    input logic  valid_in,
    input logic  count,

    input logic  clk,
    input logic  reset,

    output logic en_i,
    output logic en_fp,
    output logic en_pp
);

logic [1:0] c_state, n_state;
parameter S0=2'b00, S1=2'b01 ,S2=2'b10;

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
      if (valid_in) n_state = S1;
      else n_state = S0; 
    end
    S1: begin   
      if (!count) n_state = S2;
    end
    S2: begin
      if (count) n_state = S0;
      else n_state = S2;
    end
    default: n_state = S0;
  endcase
end

//output always block
always_comb begin
  case (c_state)
    S0: if (valid_in) begin   
      en_i  = 1'b1;
      en_pp = 1'b0;
      en_fp = 1'b0; 
    end
    else begin
      en_i  = 1'b0;
      en_pp = 1'b0;
      en_fp = 1'b0;
    end

    S1: if(!count) begin   
      en_i  = 1'b1;
      en_pp = 1'b0;
      en_fp = 1'b0;
    end

    S2: if(!count) begin   
      en_i  = 1'b0;
      en_pp = 1'b1;
      en_fp = 1'b0;
    end

    else begin   
      en_i  = 1'b0;
      en_pp = 1'b0;
      en_fp = 1'b1;
    end

    default: begin  
      en_i  = 1'b0;
      en_pp = 1'b0;
      en_fp = 1'b0; 
    end
  endcase
end
    
endmodule