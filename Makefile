SRC_SV:= src/ars.sv  			\
	 src/adder.sv  				\
	 src/booth_multiplier.sv  	\
	 src/comparator.sv  		\
	 src/controller.sv  		\
	 src/counter.sv  			\
	 src/datapath.sv  		\
	 src/final_product.sv  		\
	 src/input_register.sv  	\
	 src/mux_4x1.sv  		\
	 src/partial_product.sv  	\
	 src/shifting.sv  		\
	 src/twos_complement.sv		\
	 test/tb_booth_multiplier.sv

DEFINES_VER:= src/defines/verilator.svh
DEFINES_VIV:= src/defines/vivado.svh

COMP_OPTS_SV := --incr --relax

TB_TOP := tb_booth_multiplier
MODULE := tb_booth_multiplier

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
	#verilog -VIVADO  
	xvlog -sv $(COMP_OPTS_SV) $(SRC_SV) $(DEFINES_VIV)
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

#----------------------#
#----- VERILATOR ------#
#----------------------#

.PHONY: verilator ver_waves 

ver_waves: verilator
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd

verilator: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(MODULE)

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: ./src/*.sv ./test/$(TB_TOP).*
	@echo
	@echo "### VERILATING ###"
	verilator --trace -cc $(SRC_SV) $(DEFINES_VER) 	\
	  	  --top-module $(MODULE) 		\
		  -Wno-DECLFILENAME 			\
		  -Wno-WIDTH 				\
		  -Wno-REDEFMACRO			\
		  -Wno-INITIALDLY			\
		  --exe ./test/$(TB_TOP).cpp 		\
		  --timing
	@touch .stamp.verilate

.PHONY : clean
clean :
	rm -rf *.jou *.log *.pb *.wdb xsim.dir *.str
	rm -rf .*.timestamp *.tcl *.vcd .*.verilate
	rm -rf obj_dir .Xil
