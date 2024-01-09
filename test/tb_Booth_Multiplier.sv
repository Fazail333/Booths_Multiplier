module tb_Booth_Multiplier;

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
        clk = 1'b1;
        //generating clock signal
        forever #5 clk = ~clk;
    end

    // Initial stimulus
    initial
    begin
        //repeat (5) begin
        reset <= 0; multiplicand <= 17'h00000; multiplier = 17'h00000; load <= 0; load_PP <= 0;
        @(posedge clk)
        reset <= 1; multiplicand <= 17'h00000; multiplier = 17'h00000; load <= 0;
        @(posedge clk);
        reset <= 0; multiplicand <= $urandom; multiplier = $urandom; load <= 1;
        @(posedge clk);
        load <= 0;
        @(posedge clk);
        load_PP <= 1;
        @(posedge clk);
        reset <= 0; load <= 0; load_PP <= 0;
        repeat (18)@(posedge clk);
        if ((multiplicand)*(multiplier) == (product))
            $display( "multiplicand = %0d; multiplier = %0d; product = %0d", multiplicand, multiplier, product);
        //end
        $stop;
    end
    /*begin
    repeat(10)begin
        reset <= 1;
        @(posedge clk);
        reset <= 0; multiplicand <= $urandom; multiplier = $urandom; load <= 1;
        #5
        $display( "multiplicand = %0d;multiplier = %0d;",multiplicand,multiplier);
        @(posedge clk);
        load <= 0;
        @(posedge clk);
        load_PP <= 1;
        @(posedge clk);
        load_PP <= 0;
        repeat (30)@(posedge clk);
        end
        $stop;
   
   end */
endmodule
