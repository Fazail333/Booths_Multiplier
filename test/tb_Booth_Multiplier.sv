module tb_Booth_Multiplier;

    // Inputs
    logic [15:0] multiplicand;
    logic [15:0] multiplier;
    logic clk;
    logic reset;
    logic valid_out;
    logic load;
    logic load_PP;

    // Outputs
    logic [31:0] product;

    // Instantiate the Booth's Multiplier Datapath and Controller
    Booth_Multiplier UUT (
        .in_A(multiplicand),
        .in_B(multiplier),
        .clk(clk),
        .reset(reset),
        .ld_PP(load_PP),
        .ld(load),
        .ld_p(valid_out),
        .product(product)
    );

    logic [14:0]a,b;
    
    // Clock generation
    initial
    begin
        //initial value of clock
        clk = 1'b1;
        //generating clock signal
        forever #10 clk = ~clk;
    end

    // Initial stimulus
    initial
    begin
        reset_sequence;
        repeat(5) begin
           a = $random; b = $random;
           apply_inputs(a,b);
            
       	   @(negedge valid_out);
           if (mul_ref(a,b) == (product)) begin
            	$display( "\nmultiplicand = %0d; multiplier = %0d; product = %0d", multiplicand, multiplier, mul_ref(a,b));
            	$display ("---> SUCCESS <---\n");
                //$stop; 
                end 
                else 
                	$display("Error for input a=%d, b=%d, expected=%d, product=%d\n", a, b, mul_ref(a,b), product); 
        repeat(2) @(posedge clk);
        a = 0; b = 0;
        end
        $stop;
    end

   task reset_sequence;
   	begin 
               reset = 0; load = 0; load_PP = 0; 
             @(posedge clk) reset = #1 1; 
   	     @(posedge clk) reset = #1 0;
   	end
   endtask
   
   task apply_inputs(input logic [15:0]in_a, in_b);
        begin
        	 multiplicand = in_a;
        	 multiplier = in_b;
        	 load = 0;  
        	 load_PP = 0;
        	@(posedge clk) load = #1 1;
        	@(posedge clk) load = #1 0;
        	@(posedge clk) load_PP = #1 1;
        	@(posedge clk) load_PP = #1 0;
        end
   endtask
   
   function [31:0]mul_ref(input logic [15:0]in_a, in_b);
   	begin 
   		mul_ref = (in_a * in_b);
   	end
   endfunction 	 
        	
endmodule
