<<<<<<< HEAD
SRC_SV:= src/ARS.sv  			\
	 src/adder.sv  		\
	 src/Booth_Multiplier.sv  	\
	 src/comparator.sv  		\
	 src/Controller.sv  		\
	 src/counter.sv  		\
	 src/Datapath.sv  		\
	 src/final_product.sv  		\
	 src/Input_Register.sv  	\
	 src/mux4x1.sv  		\
	 src/partial_product.sv  	\
	 src/shifting.sv  		\
	 src/twos_complement.sv		\
	 test/tb_Booth_Multiplier.sv

COMP_OPTS_SV := --incr --relax

TB_TOP := tb_Booth_Multiplier
MODULE := Booth_Multiplier

#==== Default target - running VIVADO simulation without drawing waveforms ====#
.PHONY: vivado viv_elaborate viv_compile

vivado : $(TB_TOP)_snapshot.wdb

viv_elaborate : .elab.timestamp

viv_compile : .comp_sv.timestamp .comp_v.timestamp .comp_vhdl.timestamp

#==== WAVEFORM DRAWING ====#
.PHONY: viv_waves
viv_waves : $(TB_TOP)_snapshot.wdb
	@echo
	@echo "### OPENING VIVADO WAVES ###"
	xsim --gui $(TB_TOP)_snapshot.wdb

#==== SIMULATION ====#
$(TB_TOP)_snapshot.wdb : .elab.timestamp 
	@echo
	@echo "### RUNNING SIMULATION ###"
	xsim $(TB_TOP)_snapshot --tclbatch xsim_cfg.tcl

#==== ELABORATION ====#
.elab.timestamp : .comp_sv.timestamp .comp_v.timestamp .comp_vhdl.timestamp
	@echo 
	@echo "### ELABORATION ###"
	xelab -debug all -top $(TB_TOP) -snapshot $(TB_TOP)_snapshot
	touch $@	

#==== COMPILING SYSTEMVERILOG ====#	
ifeq ($(SRC_SV),)
.comp_sv.timestamp :
	@echo 
	@echo "### NO SYSTEMVERILOG SOUCES GIVEN ###"
	@echo "### SKIPPED SYSTEMVERILOG COMPILATION ###"
	touch $@
else 
.comp_sv.timestamp : $(SRC_SV)
	@echo
	@echo "### COMPILING SYSTEMVERILOG ###"
	rm -rf xsim_cfg.tcl
	@echo "log_wave -recursive *" > xsim_cfg.tcl
	@echo "run all" >> xsim_cfg.tcl
	@echo "exit" >> xsim_cfg.tcl
	xvlog --sv $(COMP_OPTS_SV) $(SRC_SV)
	touch $@
endif

#==== COMPILING VERILOG ====#	
ifeq ($(SRC_V),)
.comp_v.timestamp :
	@echo
	@echo "### NO VERILOG SOURCES GIVEN ###"
	@echo "### SKIPPED VERILOG COMPILATION ###"
	touch $@
else
.comp_v.timestamp : $(SRC_V)
	@echo 
	@echo "### COMPILING VERILOG ###"
	xvlog $(COMP_OPTS_V) $(SRC_V)
	touch $@
endif 

#==== COMPILING VHDL ====#	
ifeq ($(SRC_VHDL),)
.comp_vhdl.timestamp :
	@echo
	@echo "### NO VHDL SOURCES GIVEN ###"
	@echo "### SKIPPED VHDL COMPILATION ###"
	touch $@
else
.comp_vhdl.timestamp : $(SRC_VHDL)
	@echo 
	@echo "### COMPILING VHDL ###"
	xvhdl $(COMP_OPTS) $(SRC_VHDL)
	touch $@
endif

.PHONY: verilate ver_waves 

ver_waves: verilate
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd

verilate: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(MODULE)

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: ./src/*.sv ./test/$(TB_TOP).cpp
	@echo
	@echo "### VERILATING ###"
	verilator --trace -cc ./src/*.sv \
	  	  --top-module $(MODULE) \
		  -Wno-DECLFILENAME \
		  -Wno-WIDTH \
		  --exe ./test/$(TB_TOP).cpp
	@touch .stamp.verilate

.PHONY : clean
clean :
	rm -rf *.jou *.log *.pb *.wdb xsim.dir *.str
	rm -rf .*.timestamp *.tcl *.vcd .*.verilate
	rm -rf obj_dir
=======
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
>>>>>>> 7eb7bba08d1306a9c15111599221a5e70da670b0
