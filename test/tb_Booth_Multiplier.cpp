#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VBooth_Multiplier.h"

#define MAX_SIM_TIME 48
#define VERIF_START_TIME 7
vluint64_t sim_time = 0;
vluint64_t posedge_cnt = 0;

void dut_reset (VBooth_Multiplier *dut, vluint64_t &sim_time){
    dut->reset = 0;
    if(sim_time >= 2 && sim_time < 4){
        dut->reset = 1;
        dut->in_A = 0;
        dut->in_B = 0;
        dut->ld_PP = 0;
        dut->ld = 0;
        dut->product = 0;
    }
}

void dut_inputs (VBooth_Multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 4 && sim_time < 5){
        dut->reset = 0;
        dut->in_A = rand() % (32767 - (-32768) + 1) + (-32768);
        dut->in_B = rand() % (32767 - (-32768) + 1) + (-32768);
        dut->ld_PP = 0;
        dut->ld = 1;
    }
}

void dut_load (VBooth_Multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 6 && sim_time < 8){
        dut->reset = 0;
        dut->in_A = 0;
        dut->in_B = 0;
        dut->ld_PP = 0;
        dut->ld = 0;
    }
}

void dut_loadpp (VBooth_Multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 8 && sim_time < 10){
        dut->reset = 0;
        dut->in_A = 0;
        dut->in_B = 0;
        dut->ld_PP = 1;
        dut->ld = 0;
    }
}

void dut_loadoff (VBooth_Multiplier *dut, vluint64_t &sim_time){
    if(sim_time >= 10 && sim_time < 12){
        dut->reset = 0;
        dut->in_A = 0;
        dut->in_B = 0;
        dut->ld_PP = 0;
        dut->ld = 0;
    }
}


int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    VBooth_Multiplier *dut = new VBooth_Multiplier;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");
    
        while (sim_time < MAX_SIM_TIME) {
        	dut_reset(dut, sim_time);

        	dut->clk ^= 1;
        	dut->eval();

        	if (dut->clk == 1){
        	    posedge_cnt++;
        	}
        
        	dut_inputs (dut, sim_time);
        	dut_load (dut, sim_time);
        	dut_loadpp (dut, sim_time);
        	dut_loadoff (dut, sim_time);
        	
        	m_trace->dump(sim_time);
        	sim_time++;
        }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
