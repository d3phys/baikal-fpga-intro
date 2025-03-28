`ifndef ALU_VH
`define ALU_VH

`define ALU_OP_WIDTH    4

// Supported ALU operations:
//
// Note: 
//   Use {funct7[5], funct3} encoding to potentially reduce number of converters
//                      

`define ALU_OP_NONE     `ALU_OP_WIDTH'bxxxx
`define ALU_OP_ADD      `ALU_OP_WIDTH'b0000
`define ALU_OP_SUB      `ALU_OP_WIDTH'b1000
`define ALU_OP_SLL      `ALU_OP_WIDTH'b0001
`define ALU_OP_SLT      `ALU_OP_WIDTH'b0010
`define ALU_OP_SLTU     `ALU_OP_WIDTH'b0011
`define ALU_OP_XOR      `ALU_OP_WIDTH'b0100
`define ALU_OP_SRL      `ALU_OP_WIDTH'b0101
`define ALU_OP_SRA      `ALU_OP_WIDTH'b1101
`define ALU_OP_OR       `ALU_OP_WIDTH'b0110
`define ALU_OP_AND      `ALU_OP_WIDTH'b0111

`endif // ALU_VH
