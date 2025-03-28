`ifndef __CMP_VH__
`define __CMP_VH__

`define CMP_OP_WIDTH  3

// Supported CMP operations:
//
// Note: 
//   Use {funct3} encoding to potentially reduce number of converters
//                      

`define CMP_OP_NONE   `CMP_OP_WIDTH'bxxx
`define CMP_OP_BEQ    `CMP_OP_WIDTH'b000
`define CMP_OP_BNE    `CMP_OP_WIDTH'b001
`define CMP_OP_BLT    `CMP_OP_WIDTH'b100
`define CMP_OP_BGE    `CMP_OP_WIDTH'b101
`define CMP_OP_BLTU   `CMP_OP_WIDTH'b110
`define CMP_OP_BGEU   `CMP_OP_WIDTH'b111

`endif // __CMP_VH__
