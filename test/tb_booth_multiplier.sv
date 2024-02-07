localparam WIDTH_INPUT = 16;
localparam WIDTH_OUTPUT = 32;

module tb_booth_multiplier(
`ifdef VERILATOR
    input logic clk
`endif
    );

    // Inputs
    logic signed [WIDTH_INPUT-1:0] multiplicand;
    logic signed [WIDTH_INPUT-1:0] multiplier;
    logic                   valid_out;
    
    logic                   reset;
    logic                   valid_in;

`ifndef VERILATOR
    logic                   clk;
`endif

    // Outputs
    logic signed [WIDTH_OUTPUT-1:0] product;

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

    logic signed [WIDTH_INPUT-1:0]a,b;

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
        
        init_signals;
        reset_sequence;

        repeat(5) begin
            int count = 0;

            // Not add #1 because verilator can not show the output at the terminal and 
            // not store the values of multiplier and multiplicand

            a <= $random; b <= $random;

            @(posedge clk); 
            multiplicand <= a; multiplier <= b;

            apply_inputs;

            while (!valid_out) 
            begin
                @(posedge clk)
                if (count > 20)
                begin
                    $fatal("No valid out appears for 20 clock cycles");
                end
                count ++;
            end

            if (mul_ref(a,b) == (product)) 
                begin
            	    $display( "\nHexadecimal Values----> multiplicand = %h; multiplier = %h; product = %h ", multiplicand, multiplier, $signed(mul_ref(a,b)));
            	    $display ("---> SUCCESSFULLY MULTIPLIED <---\n");
                end 
                else 
                	$display("Error for input a=%d, b=%d, expected=%h, product=%h\n", a, b, mul_ref(a,b), product); 
        repeat(2) @(posedge clk);
        end
        $finish;
    end

    task init_signals;
        begin
            multiplicand <= 0; multiplier <= 0;
            reset <= 1; valid_in <= 0; a <= 0; b <= 0;
        end
    endtask

    task reset_sequence;
        begin 
            reset <= 1;
            @(posedge clk) reset <= 0; 
            @(posedge clk) reset <= 1;
        end
    endtask

    task apply_inputs;
        begin
            valid_in <= 0;  
            @(posedge clk) valid_in <= 1;
            @(posedge clk) valid_in <= 0;
        end
    endtask

   function [WIDTH_OUTPUT-1:0]mul_ref(input logic [WIDTH_INPUT-1:0]in_a, in_b);
   	begin
   		mul_ref = ($signed(in_a) * $signed(in_b));
   	end
   endfunction 	 
        	
endmodule