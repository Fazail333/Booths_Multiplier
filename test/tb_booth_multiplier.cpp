#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vbooth_multiplier.h"  // Replace with the actual Verilated header file

#define MAX_SIM_TIME_R 43
vluint64_t MAX_SIM_TIME = 0;
vluint64_t sim_time = 0;

int main(int argc, char** argv) {
    short int a, b;
    int product, i;
    const int array_size = 5;
    int relative_time[array_size] = {0, 44, 87, 130, 173};

    // Verilator setup
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // Instantiate the Verilated model
    Vbooth_multiplier* top = new Vbooth_multiplier;

    // Initialize trace dump
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);  // Trace 99 levels of hierarchy
    tfp->open("waveform.vcd");

    for (i = 0; i < array_size; i++) {
        a = rand();
        b = rand();
        MAX_SIM_TIME += MAX_SIM_TIME_R;

        // Simulate for MAX_SIM_TIME
        while (!Verilated::gotFinish() && sim_time < MAX_SIM_TIME) {
            top->reset = 0;
            if ((sim_time >= relative_time[i] + 2) && (sim_time < relative_time[i] + 4)) {
                top->reset = 1;
                top->in_a = 0;
                top->in_b = 0;
                top->valid_in = 0;
                top->product = 0;
            }
            top->clk ^= 1;
            top->eval();

            if ((sim_time >= relative_time[i] + 4) && (sim_time < relative_time[i] + 5)) {
                top->in_a = a;
                top->in_b = b;
            }

            if ((sim_time >= relative_time[i] + 6) && (sim_time < relative_time[i] + 8)) {
                top->valid_in = 1;
            }
            if ((sim_time >= relative_time[i] + 8) && (sim_time < relative_time[i] + 10)) {
                top->valid_in = 0;
            }

            tfp->dump(sim_time);
            product = top->product;
            // Advance time
            sim_time++;
        }

        if ((a)*(b) == (product)) {
            printf("Multiplican =  %d; Multiplier =  %d; Product = %d\n", a, b, product);
            printf("SIMULATE SUCCESSFULLY\n");
        }
    }  // Close trace file
    tfp->close();

    // Clean up
    delete top;

    exit(EXIT_SUCCESS);
}

