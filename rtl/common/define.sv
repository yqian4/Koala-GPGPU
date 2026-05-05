// definitions of all the settings




// code memory
`define CODE_MEM_ADDR_WIDTH     32
`define CODE_MEM_DATA_WIDTH     64
`define CODE_ADDR_WIDTH         `CODE_MEM_ADDR_WIDTH      // address width of kernel code

`define NUM_WARP                8
`define DEPTH_WARP              $clog2(`NUM_WARP)         //the depth of warp

`define NUM_REG                 64
`define DEPTH_REG               $clog2(`NUM_REG)          //the depth of register file
`define REG_DATA_WIDTH          32

