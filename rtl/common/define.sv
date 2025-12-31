// definitions of all the settings




// code memory
`define CODE_MEM_ADDR_WIDTH     32
`define CODE_MEM_DATA_WIDTH     64
`define CODE_ADDR_WIDTH         `CODE_MEM_ADDR_WIDTH      // address width of kernel code

`define NUM_WARP                8
`define DEPTH_WARP              $clog2(`NUM_WARP)         //the depth of warp

