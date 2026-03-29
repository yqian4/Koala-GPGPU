from typing import List
from .logger import logger

class host_interface:
    def __init__(self, dut, addr_bits, wid_bits):
        self.dut = dut
        self.addr_bits = addr_bits
        self.wid_bits = wid_bits

        self.host_req_ready = getattr(dut, f"host_req_ready_o")
        self.host_req_valid = getattr(dut, f"host_req_valid_i")
        self.host_req_start_addr = getattr(dut, f"host_req_start_addr_i")
        self.host_rsp_ready = getattr(dut, f"host_rsp_ready_i")
        self.host_rsp_valid = getattr(dut, f"host_rsp_valid_o")
        self.host_rsp_wid = getattr(dut, f"host_rsp_wid_o")
        self.host_rsp_ready.value = 1
        self.host_req_valid.value = 0


    
    def launch_kernel(self, kernel_addr):
        host_req_ready = int(str(self.host_req_ready.value), 2)
        host_req_valid = 0
        host_req_start_addr = 0

        if host_req_ready == 1:
            host_req_start_addr = kernel_addr
            host_req_valid = 1
        
        self.host_req_start_addr.value = int(format(host_req_start_addr, '0'+str(self.addr_bits)+'b'),2)
        self.host_req_valid.value = int(format(host_req_valid, '01b'),2)

    def clear(self):
        host_req_valid = 0
        host_req_start_addr = 0
        self.host_req_start_addr.value = int(format(host_req_start_addr, '0'+str(self.addr_bits)+'b'),2)
        self.host_req_valid.value = int(format(host_req_valid, '01b'),2)



        

