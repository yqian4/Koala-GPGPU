// definitions of all the settings

`define NUM_WARP                8


// code memory
`define CODE_MEM_ADDR_WIDTH     16
`define CODE_MEM_DATA_WIDTH     64

`define DEPTH_WARP              $clog2(`NUM_WARP) //the depth of warp

`define CODE_ADDR_WIDTH         32      // address width of kernel code