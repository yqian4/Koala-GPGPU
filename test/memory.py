from typing import List
from .logger import logger

class Memory:
    def __init__(self, dut, addr_bits, data_bits, wid_bits, name):
        self.dut = dut
        self.addr_bits = addr_bits
        self.data_bits = data_bits
        self.data_bytes = data_bits // 8
        self.wid_bits = wid_bits
        self.memory = [0] * (2**addr_bits)
        self.name = name

        self.mem_ready = getattr(dut, f"{name}_mem_ready_i")
        self.mem_rd_req_valid = getattr(dut, f"{name}_rd_req_valid_o")
        self.mem_rd_req_addr = getattr(dut, f"{name}_rd_req_addr_o")
        self.mem_rd_req_wid = getattr(dut, f"{name}_rd_req_wid_o")
        self.mem_rd_rsp_valid = getattr(dut, f"{name}_rd_rsp_valid_i")
        self.mem_rd_rsp_addr = getattr(dut, f"{name}_rd_rsp_addr_i")
        self.mem_rd_rsp_wid = getattr(dut, f"{name}_rd_rsp_wid_i")
        self.mem_rd_rsp_data = getattr(dut, f"{name}_rd_rsp_data_i")
        self.mem_ready.value = 1
        self.mem_rd_rsp_valid.value=0

    def run(self):
        mem_rd_req_valid = int(str(self.mem_rd_req_valid.value), 2)
        mem_rd_req_addr = int(str(self.mem_rd_req_addr.value), 2)
        mem_rd_req_wid = int(str(self.mem_rd_req_wid.value), 2)
        
        mem_rd_rsp_valid = 0
        mem_rd_rsp_addr = 0
        mem_rd_rsp_wid = 0
        mem_rd_rsp_data = 0

        if mem_rd_req_valid == 1:
            mem_rd_index = mem_rd_req_addr // self.data_bytes
            if (mem_rd_index < len(self.memory)):
                mem_rd_rsp_data = self.memory[mem_rd_index]
            else:
                mem_rd_rsp_data = 0
            mem_rd_rsp_addr = mem_rd_req_addr
            mem_rd_rsp_wid = mem_rd_req_wid
            mem_rd_rsp_valid = 1
        else:
            mem_rd_rsp_valid = 0
        
        self.mem_rd_rsp_wid.value = int(format(mem_rd_rsp_wid, '0'+str(self.wid_bits)+'b'),2)
        self.mem_rd_rsp_addr.value = int(format(mem_rd_rsp_addr, '0'+str(self.addr_bits)+'b'),2)
        self.mem_rd_rsp_data.value = int(format(mem_rd_rsp_data, '0'+str(self.data_bits)+'b'),2)
        self.mem_rd_rsp_valid.value = int(format(mem_rd_rsp_valid, '01b'),2)
    
    def write(self, address, data):
        if address < len(self.memory):
            self.memory[address] = data

    def load(self, rows: List[int]):
        for address, data in enumerate(rows):
            self.write(address, data)

    def display(self, rows, decimal=True):
        logger.info("\n")
        logger.info(f"{self.name.upper()} MEMORY")
        
        table_size = (8 * 2) + 3
        logger.info("+" + "-" * (table_size - 3) + "+")

        header = "| Addr | Data "
        logger.info(header + " " * (table_size - len(header) - 1) + "|")

        logger.info("+" + "-" * (table_size - 3) + "+")
        for i, data in enumerate(self.memory):
            if i < rows:
                if decimal:
                    row = f"| {i:<4} | {data:<4}"
                    logger.info(row + " " * (table_size - len(row) - 1) + "|")
                else:
                    data_bin = format(data, f'0{16}b')
                    row = f"| {i:<4} | {data_bin} |"
                    logger.info(row + " " * (table_size - len(row) - 1) + "|")
        logger.info("+" + "-" * (table_size - 3) + "+")