localparam WIDTH_INPUT = 16;
localparam WIDTH_OUTPUT = 32;

module tb_booth_multiplier(

`ifdef VERILATOR
    input logic clk,
    input logic reset,
    input logic valid_in
`endif

    );

    // Inputs
    logic [WIDTH_INPUT-1:0] multiplicand;
    logic [WIDTH_INPUT-1:0] multiplier;
    logic                   valid_out;

`ifndef VERILATOR
    logic                   clk;
    logic                   reset;
    logic                   valid_in;
`endif

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

`ifndef VERILATOR
    initial begin
        //initial value of clock
        clk = 1'b1;
        //generating clock signal
        forever #10 clk = ~clk;
    end
`endif

    // Initial stimulus
    initial
    begin

    `ifndef VERILATOR
        init_signals;

        reset_sequence;
    `endif

        repeat(5) begin
            int count = 0;
            a <= $random; b <= $random;

            @(posedge clk); 
            multiplicand <= a; multiplier <= b;
    
    `ifndef VERILATOR       
            apply_inputs;
    `endif

            while (!valid_out) 
            begin
                @(posedge clk)
                if (count > 20)
                begin
                    $fatal("No valid out appears for 15 clock cycles");
                end
                count ++;
            end

            if (mul_ref(a,b) == (product)) 
                begin
            	    $display( "\nmultiplicand = %0d; multiplier = %0d; product = %0d", multiplicand, multiplier, mul_ref(a,b));
            	    $display ("---> SUCCESS <---\n");
                end 
                else 
                	$fatal("Error for input a=%d, b=%d, expected=%d, product=%d\n", a, b, mul_ref(a,b), product); 
        repeat(2) @(posedge clk);
        end
        $finish;
    end

`ifndef VERILATOR
    task init_signals;
        begin
            multiplicand <= 0; multiplier <= 0;
            reset <=0; valid_in<= 0; a<=0; b<=0;
        end
    endtask

    task reset_sequence;
        begin 
            reset <= 0;
            @(posedge clk) reset <= #1 1; 
            @(posedge clk) reset <= #1 0;
        end
    endtask

    task apply_inputs;
        begin
            valid_in <= 0;  
            @(posedge clk) valid_in <= #1 1;
            @(posedge clk) valid_in <= #1 0;
        end
    endtask
`endif

   function [WIDTH_OUTPUT-1:0]mul_ref(input logic [WIDTH_INPUT-2:0]in_a, in_b);
   	begin 
   		mul_ref = (in_a * in_b);
   	end
   endfunction 	 
        	
endmodule