#include <stdlib.h>
#include <iostream>
#include <cstdlib>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vtb_booth_multiplier.h"  // Replace with the actual Verilated header file

#define MAX_SIM_TIME_R 43
vluint64_t MAX_SIM_TIME = 0;
vluint64_t sim_time = 0;

int main(int argc, char** argv) {

    short int a,b;
    int product;
    const int array_size = 6;
    int relative_time[array_size] = {0, 44, 87, 130, 173, 216};

    // Verilator setup
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // Instantiate the Verilated model
    Vtb_booth_multiplier* top = new Vtb_booth_multiplier;

    // Initialize trace dump
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);  				// Trace 99 levels of hierarchy
    tfp->open("waveform.vcd");

    for (int i = 0; i < array_size; i++) {

        MAX_SIM_TIME += MAX_SIM_TIME_R;
        
        // Simulate for MAX_SIM_TIME
        while (!Verilated::gotFinish() && sim_time < MAX_SIM_TIME) {
                top->reset = 0;
                top->valid_in = 0;
            if ((sim_time >= relative_time[i] + 2) && (sim_time < relative_time[i] + 4))
                {
                    top->reset = 1;
                }
            if((sim_time >= relative_time[i] + 6) && (sim_time < relative_time[i] + 8)){
                    top->valid_in = 1;
                }
            top->clk ^= 1;
            top->eval();


            tfp->dump(sim_time);

            // Advance time
            sim_time++;
            }
    }

	// Close trace file
    tfp->close();

    // Clean up
   delete top;

   exit(EXIT_SUCCESS);
}

