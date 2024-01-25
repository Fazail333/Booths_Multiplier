#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vbooth_multiplier.h"  // Replace with the actual Verilated header file

// Function to advance simulation time
void advance_time(Vbooth_multiplier* top, int time_units) {
    for (int i = 0; i < time_units; ++i) {
        top->clk = !top->clk;
        top->eval();
    }
}

int main(int argc, char** argv) {
    // Verilator setup
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // Instantiate the Verilated model
    Vbooth_multiplier* top = new Vbooth_multiplier;

    // Initialize trace dump
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);  // Trace 99 levels of hierarchy
    tfp->open("dump.vcd");

    // Set initial values
    top->clk = 1;
    top->reset = 0;

    // Simulate for 10 clock cycles
    for (int i = 0; i < 10; ++i) {
        // Toggle clock
        top->eval();
        tfp->dump(10 * i);  // Dump waveform every 10 time units

        top->clk = !top->clk;
        top->eval();
        tfp->dump(10 * i + 5);  // Dump waveform at half the clock cycle

        // Your stimulus here
        top->in_a = rand();
        top->in_b = rand();
        top->ld = 1;
        top->ld_pp = 1;

        // Execute one clock cycle
        top->eval();
        tfp->dump(10 * i + 10);  // Dump waveform at the next clock edge

        top->ld = 0;
        top->ld_pp = 0;

        // Advance time to next clock edge
        advance_time(top, 1);
    }

    // Close trace file
    tfp->close();

    // Clean up
    delete top;
    exit(EXIT_SUCCESS);
}

