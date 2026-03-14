TOPMODULE_ARG := -s $(TOPLEVEL)

ifdef VERILOG_INCLUDE_DIRS
    COMPILE_ARGS += $(addprefix -I, $(VERILOG_INCLUDE_DIRS))
endif

.PHONY: test
export LIBPYTHON_LOC=$(shell cocotb-config --libpython)
test_%:
	iverilog -o ./sim.vvp $(TOPMODULE_ARG) -g2012 $(COMPILE_ARGS) $(VERILOG_SOURCES)
	MODULE=test.test_$* vvp -M $$(cocotb-config --prefix)/cocotb/libs -m cocotbvpi_icarus ./sim.vvp