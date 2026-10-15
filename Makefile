NBITS      ?= 4
TEST       ?= test
SEED       ?= 1
NUM_BURSTS ?= 20
VERBOSITY  ?= UVM_MEDIUM

WORK = work
RTL  = source/counter.sv
TB   = tb/counter_if.svh tb/counter_pkg.sv tb/tb_counter.sv

VLOG_FLAGS = -sv -timescale 1ns/10ps +incdir+tb +define+NUM_BIT_CNT=$(NBITS)
VSIM_FLAGS = -sv_seed $(SEED) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSITY) +NUM_BURSTS=$(NUM_BURSTS)

# Questa normally finds UVM on its own; set UVM_HOME if yours does not
ifdef UVM_HOME
VLOG_FLAGS += +incdir+$(UVM_HOME)/src
endif

.PHONY: all build sim gui legacy clean

all: sim

$(WORK):
	vlib $(WORK)

build: $(WORK)
	vlog $(VLOG_FLAGS) $(RTL) $(TB)

sim: build
	vsim -c $(VSIM_FLAGS) -do "run -all; quit -f" tb_counter

gui: build
	vsim $(VSIM_FLAGS) -voptargs=+acc -do "add wave -r /tb_counter/*; run -all" tb_counter

legacy: $(WORK)
	vlog $(VLOG_FLAGS) $(RTL) tb/tb_counter_legacy.sv
	vsim -c -do "run -all; quit -f" tb_socetlib_counter

clean:
	rm -rf $(WORK) transcript vsim.wlf *.vstf
