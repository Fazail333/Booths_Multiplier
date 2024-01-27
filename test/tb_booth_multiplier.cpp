#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vbooth_multiplier.h"  // Replace with the actual Verilated header file

#define MAX_SIM_TIME 50
vluint64_t sim_time = 0;

int main(int argc, char** argv) {
int a,b;


// Verilator setup
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // Instantiate the Verilated model
    Vbooth_multiplier* top = new Vbooth_multiplier;

    // Initialize trace dump
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);  // Trace 99 levels of hierarchy
    tfp->open("waveform.vcd");

	a = rand() ;
    b = rand() ;

	
    // Simulate for MAX_SIM_TIME
    while (!Verilated::gotFinish() && sim_time < MAX_SIM_TIME) {
        top->reset = 0;
		if(sim_time >= 2 &&  sim_time < 4){
			top->reset = 1;
			top->in_a = 0;
			top->in_b = 0;
			top->valid_in= 0;
		}
		top->clk ^= 1;
        top->eval();

        if(sim_time >= 4 &&  sim_time < 5){
			top->in_a = a;
			top->in_b = b;
		}

		if(sim_time >= 6 &&  sim_time < 8){

			top->valid_in = 1;
		
		}
			if(sim_time >= 8 &&  sim_time < 10){

			top->valid_in = 0;
		
		}


		tfp->dump(sim_time);
		// Advance time
        sim_time++;
     
    }
	
	if ((a)*(b) == (top->product)) {
		printf("Multiplican =  %d; Multiplier =  %d; Product = %d\n" , a,b, top->product);
		printf("SIMULATE SUCCESSFULLY\n");
	}




    // Close trace file
    tfp->close();

    // Clean up
    delete top;

   return 0;
}

