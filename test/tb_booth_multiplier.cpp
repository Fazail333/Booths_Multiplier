#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vbooth_multiplier.h"  // Replace with the actual Verilated header file

#define MAX_SIM_TIME 48
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
    top->trace(tfp, 6);  // Trace 99 levels of hierarchy
    tfp->open("waveform.vcd");
    a = rand() ;
    b = rand() ;
	
	while(sim_time < MAX_SIM_TIME){
		top->reset = 0 ;
		if(sim_time >= 2 &&  sim_time < 4){
			top->reset = 1;
			top->in_a = 0;
			top->in_b = 0;
			top->ld_pp = 0;
			top->ld = 0;
			top->product = 0;
		}
		top->clk ^= 1;
        	top->eval();
        
        		
		if(sim_time >= 4 &&  sim_time < 5){
			top->in_a = a;
			top->in_b = b;
			top->ld = 1;
		}
		if(sim_time >= 6 &&  sim_time < 8){
		
			top->ld = 0;
			top->in_a = 0;
			top->in_b = 0;
		}
 		if(sim_time >= 8 &&  sim_time <10 ){
			top->ld = 0;
 			top->in_a = 0;
			top->in_b = 0;
			top->ld_pp = 1;
		}
		if(sim_time >= 10 &&  sim_time <12 ){

			top->reset = 0;
			top->in_a = 0;
			top->in_b = 0;
			top->ld_pp = 0;
			top->ld = 0;

		}

		tfp->dump(sim_time);
        	sim_time++;
    }
	if ((a)*(b) == (top->product)) {
		printf("Multiplican =  %d; Multiplier =  %d; Product = %d\n" , a,b, top->product); 
		printf("SIMULATE SUCCESSFULLY\n");
   	}
 
   tfp->close();
   delete top;
   exit(EXIT_SUCCESS);
}
	
