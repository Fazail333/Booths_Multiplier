module controller (
    input logic  valid_in,
    input logic  count_16,
    input logic  [1:0] in,

    input logic  clk,
    input logic  reset,

    output logic  [1:0] mux_sel,
    output logic en_i,
    output logic en_fp,
    output logic en_pp,

    output logic valid_out
);

logic [1:0] c_state, n_state;
parameter S0=2'b00, S1=2'b01 ,S2=2'b10;

always_ff @ (posedge clk or negedge reset) begin
    //reset is active high
    if (!reset) 
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
      if (count_16) n_state = S0;
      else if ((in == 00)) n_state = S1;
      else if ((in == 01)) n_state = S1;
      else if ((in == 10)) n_state = S1;
      else if ((in == 11)) n_state = S1;
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
      mux_sel = 2'b00; 
      valid_out = 1'b0;
    end
    else begin
      en_i  = 1'b0;
      en_pp = 1'b0;
      en_fp = 1'b0;
      mux_sel = 2'b00;
      valid_out = 1'b0;
    end

    S1: if(count_16) begin   
      en_i  = 1'b0;
      en_pp = 1'b0;
      en_fp = 1'b1;
      mux_sel = 2'b00;
      valid_out = 1'b1;
    end

    else if (!count_16 && (in == 0)) begin   
      en_i  = 1'b0;
      en_pp = 1'b1;
      en_fp = 1'b0;
      mux_sel = 2'b00;
      valid_out = 1'b0;
    end

    else if (!count_16 && (in == 1)) begin   
      en_i  = 1'b0;
      en_pp = 1'b1;
      en_fp = 1'b0;
      mux_sel = 2'b01;
      valid_out = 1'b0;
    end

    else if (!count_16 && (in == 2)) begin   
      en_i  = 1'b0;
      en_pp = 1'b1;
      en_fp = 1'b0;
      mux_sel = 2'b10;
      valid_out = 1'b0;
    end

    else if (!count_16 && (in == 3)) begin   
      en_i  = 1'b0;
      en_pp = 1'b1;
      en_fp = 1'b0;
      mux_sel = 2'b11;
      valid_out = 1'b0;
    end

    default: begin  
      en_i  = 1'b0;
      en_pp = 1'b0;
      en_fp = 1'b0; 
      mux_sel = 2'b00;
      valid_out = 1'b0;
    end
  endcase
end
    
endmodule