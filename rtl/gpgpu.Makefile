VERILOG_SOURCES += $(CURDIR)/gpgpu_top.sv

VERILOG_INCLUDE_DIRS += $(CURDIR)/common

include $(CURDIR)/common/common.Makefile
include $(CURDIR)/sm_core/sm_core.Makefile