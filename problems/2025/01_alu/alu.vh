`ifndef ALU_VH
`define ALU_VH

`define ALU_OP_WIDTH    4

// Supported ALU operations:

`define ALU_OP_ADD      `ALU_OP_WIDTH'h0
`define ALU_OP_SUB      `ALU_OP_WIDTH'h1
`define ALU_OP_XOR      `ALU_OP_WIDTH'h2
`define ALU_OP_OR       `ALU_OP_WIDTH'h3
`define ALU_OP_AND      `ALU_OP_WIDTH'h4
`define ALU_OP_SLL      `ALU_OP_WIDTH'h5
`define ALU_OP_SRL      `ALU_OP_WIDTH'h6
`define ALU_OP_SRA      `ALU_OP_WIDTH'h7
`define ALU_OP_SLT      `ALU_OP_WIDTH'h8
`define ALU_OP_SLTU     `ALU_OP_WIDTH'h9

`endif // ALU_VH
