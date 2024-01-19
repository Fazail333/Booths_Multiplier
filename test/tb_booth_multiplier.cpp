#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vbooth_multiplier.h"

#define MAX_SIM_TIME 48
#define VERIF_START_TIME 7
vluint64_t sim_time = 0;
vluint64_t posedge_cnt = 0;

void dut_reset (Vbooth_multiplier *dut, vluint64_t &sim_time){
    dut->reset = 0;
    if(sim_time >= 2 && sim_time < 4){
        dut->reset = 1;
        dut->in_a = 0;
        dut->in_b = 0;
        dut->ld_pp = 0;
        dut->ld = 0;
        dut->product = 0;
    }
}

void dut_inputs (Vbooth_multiplier *dut, vluint64_t &sim_time, int a, int b){
    if(sim_time >= 4 && sim_time < 5){
        dut->reset = 0;
        dut->in_a = a;
        dut->in_b = b;
        dut->ld_pp = 0;
        dut->ld = 1;
    }
}

void dut_load (Vbooth_multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 6 && sim_time < 8){
        dut->reset = 0;
        dut->in_a = 0;
        dut->in_b = 0;
        dut->ld_pp = 0;
        dut->ld = 0;
    }
}

void dut_loadpp (Vbooth_multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 8 && sim_time < 10){
        dut->reset = 0;
        dut->in_a = 0;
        dut->in_b = 0;
        dut->ld_pp = 1;
        dut->ld = 0;
    }
}

void dut_loadoff (Vbooth_multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 10 && sim_time < 12){
        dut->reset = 0;
        dut->in_a = 0;
        dut->in_b = 0;
        dut->ld_pp = 0;
        dut->ld = 0;
    }
}


int main(int argc, char** argv, char** env) {
    int a,b;
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    Vbooth_multiplier *dut = new Vbooth_multiplier;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");
    
    a = rand() % (32767 - (-32768) + 1) + (-32768);
    b = rand() % (32767 - (-32768) + 1) + (-32768);
    
        while (sim_time < MAX_SIM_TIME) {
        	dut_reset(dut, sim_time);

        	dut->clk ^= 1;
        	dut->eval();

        	if (dut->clk == 1){
        	    posedge_cnt++;
        	}
        
        	dut_inputs (dut, sim_time, a, b);
        	dut_load (dut, sim_time);
        	dut_loadpp (dut, sim_time);
        	dut_loadoff (dut, sim_time);
        	
        	m_trace->dump(sim_time);
        	sim_time++;
        }
	if ((a)*(b) == (dut->product)) {
		printf("Multiplican =  %d; Multiplier =  %d; Product = %d\n" , a,b, dut->product); 
		printf("SIMULATE SUCCESSFULLY\n");
	}
    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
