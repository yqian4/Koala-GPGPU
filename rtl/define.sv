// definitions of all the settings

`define NUM_WARP                8


// program memory
`define PROGRAM_MEM_ADDR_BITS   16
`define PROGRAM_MEM_DATA_BITS   64

`define DEPTH_WARP              $clog2(`NUM_WARP) //the depth of warp