`ifndef CMP_VH
`define CMP_VH

`define CMP_OP_WIDTH  3

// Supported CMP operations:

`define CMP_OP_BEQ    `CMP_OP_WIDTH'h0
`define CMP_OP_BNE    `CMP_OP_WIDTH'h1
`define CMP_OP_BLT    `CMP_OP_WIDTH'h2
`define CMP_OP_BGE    `CMP_OP_WIDTH'h3
`define CMP_OP_BLTU   `CMP_OP_WIDTH'h4
`define CMP_OP_BGEU   `CMP_OP_WIDTH'h5

`endif // CMP_VH
