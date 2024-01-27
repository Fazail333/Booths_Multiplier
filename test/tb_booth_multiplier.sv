localparam WIDTH_INPUT = 16;
localparam WIDTH_OUTPUT = 32;

module tb_booth_multiplier;

    // Inputs
    logic [WIDTH_INPUT-1:0] multiplicand;
    logic [WIDTH_INPUT-1:0] multiplier;
    logic clk;
    logic reset;
    logic valid_out;
    logic valid_in;

    // Outputs
    logic [WIDTH_OUTPUT-1:0] product;

    // Instantiate the Booth's Multiplier Datapath and Controller
    booth_multiplier UUT (
        .in_a(multiplicand),
        .in_b(multiplier),
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .valid_out(valid_out),
        .product(product)
    );

    logic [WIDTH_INPUT-2:0]a,b;
    
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
                end 
                else 
                	$display("Error for input a=%d, b=%d, expected=%d, product=%d\n", a, b, mul_ref(a,b), product); 
        repeat(2) @(posedge clk);
        end
        $stop;
    end

   task reset_sequence;
   	begin 
        reset = 0; valid_in = 0;
        @(posedge clk) reset = #1 1; 
   	    @(posedge clk) reset = #1 0;
   	end
   endtask
   
   task apply_inputs(input logic [WIDTH_INPUT-2:0]in_a, in_b);
        begin
        	 multiplicand = in_a;
        	 multiplier = in_b;
        	 valid_in = 0;  
        	@(posedge clk) valid_in = #1 1;
        	@(posedge clk) valid_in = #1 0;
        end
   endtask
   
   function [WIDTH_OUTPUT-1:0]mul_ref(input logic [WIDTH_INPUT-2:0]in_a, in_b);
   	begin 
   		mul_ref = (in_a * in_b);
   	end
   endfunction 	 
        	
endmodule
