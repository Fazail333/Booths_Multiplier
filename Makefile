SHELL = /usr/bin/env bash

SRC:= ../src/ARS.sv  			\
	../src/adder.sv  		\
	../src/BoothMultiplier.sv  	\
	../src/comparator.sv  		\
	../src/Controller.sv  		\
	../src/counter.sv  		\
	../src/Datapath.sv  		\
	../src/finalproduct.sv  	\
	../src/InputRegister.sv  	\
	../src/mux4x1.sv  		\
	../src/partialproduct.sv  	\
	../src/shifting.sv  		\
	../src/twoscomplement.sv  	
	
TEST:= ../test/tb_BoothMultiplier.sv

TOP:= tb_BoothMultiplier

snap_name:= BoothMultiplier_snapshot

tcl:= xsim_cfg.tcl

comp_tool:= xvlog  #compilation tool
elab_tool:= xelab  #elaboration tool
sim_tool:= xsim    #Simulaiton tool

.PHONY: vivado
vivado: wave

wave: simulate
	@cd SIM && $(sim_tool) --gui $(snap_name).wdb

simulate: elaborate
	@cd SIM && $(sim_tool) $(snap_name) -R
	@cd SIM && $(sim_tool) $(snap_name) --tclbatch $(tcl)

elaborate: compile
	@cd SIM && $(elab_tool) -debug typical -top $(TOP) -snapshot $(snap_name) 

compile: 
	mkdir SIM 
	@cd SIM && echo "log_wave -recursive *" > $(tcl)
	@cd SIM && echo "run all" >> $(tcl)
	@cd SIM && echo "exit" >> $(tcl)
	@cd SIM && source /tools/Xilinx/Vivado/*/settings64.sh
	@cd SIM && $(comp_tool) -sv $(SRC) $(TEST)
	
clean:
	rm -rf SIM 
