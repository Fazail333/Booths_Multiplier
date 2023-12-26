module tb_BoothMultiplier;

    // Inputs
    logic [15:0] multiplicand;
    logic [15:0] multiplier;
    logic clk;
    logic reset;
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
        .product(product)
    );

    // Clock generation
    initial
    begin
        //initial value of clock
        clk = 1'b0;
        //generating clock signal
        forever #5 clk = ~clk;
    end

    // Initial stimulus
    initial
    begin
        reset <= 0; multiplicand <= 17'h00000; multiplier = 17'h00000; load <= 0; load_PP <= 0;
        @(posedge clk)
        reset <= 1; multiplicand <= 17'h00000; multiplier = 17'h00000; load <= 0;
        @(posedge clk);
        reset <= 0; multiplicand <= 16'h8001; multiplier = 16'h7fff; load <= 1; 
        @(posedge clk);
        load <= 0;
        @(posedge clk);
        load_PP <= 1;
        @(posedge clk);
        reset <= 0; multiplicand <= 5'h00; multiplier = 5'h00; load <= 0; load_PP <= 0;
        repeat (30)@(posedge clk);
        $stop;
    end

    /*initial begin
        // Initialize inputs
        multiplicand = 16'b1010;
        multiplier = 16'b1101;
        load = 0;

        // Apply reset
        #10 reset = 1;

        // Load data
        #10 load = 1; reset = 0;

        // Provide some clock cycles
        #50;

        // End simulation
        $finish;
    end*/

endmodule
