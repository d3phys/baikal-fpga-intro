`ifndef __CONFIG_VH__
`define __CONFIG_VH__

`define IMEM_FILE_TXT   "samples/fib_fpga.txt"
`define IMEM_ADDR_WIDTH 5

`define DMEM_ADDR_WIDTH 5

`define XBAR_MMIO_START 30'h0000
`define XBAR_MMIO_LIMIT 30'h03FF
`define XBAR_DATA_START 30'h0400
`define XBAR_DATA_LIMIT 30'h3FFF

`define XBAR_HEXD_ADDR0 30'h0008


`endif // __CONFIG_VH__
