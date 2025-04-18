`ifndef __CONTROL_VH__
`define __CONTROL_VH__

// ALU operand (LHS) selector
`define CTL_ALUSEL1_WIDTH   2

`define CTL_ALUSEL1_NONE    `CTL_ALUSEL1_WIDTH'bxx
`define CTL_ALUSEL1_SRC1    `CTL_ALUSEL1_WIDTH'b00
`define CTL_ALUSEL1_IMM     `CTL_ALUSEL1_WIDTH'b01

// ALU operand (RHS) selector
`define CTL_ALUSEL2_WIDTH   2

`define CTL_ALUSEL2_NONE    `CTL_ALUSEL2_WIDTH'bxx
`define CTL_ALUSEL2_SRC2    `CTL_ALUSEL2_WIDTH'b00
`define CTL_ALUSEL2_IMM     `CTL_ALUSEL2_WIDTH'b01
`define CTL_ALUSEL2_PC      `CTL_ALUSEL2_WIDTH'b11

// Writeback selector
`define CTL_WBSEL_WIDTH     2

`define CTL_WBSEL_NONE      `CTL_WBSEL_WIDTH'bxx
`define CTL_WBSEL_ALU       `CTL_WBSEL_WIDTH'b00
`define CTL_WBSEL_LSU       `CTL_WBSEL_WIDTH'b01
`define CTL_WBSEL_UIMM      `CTL_WBSEL_WIDTH'b10
`define CTL_WBSEL_PCINC     `CTL_WBSEL_WIDTH'b11

// Immediates selector
`define CTL_IMMSEL_WIDTH    3

`define CTL_IMMSEL_NONE     `CTL_IMMSEL_WIDTH'bxxx
`define CTL_IMMSEL_IIMM     `CTL_IMMSEL_WIDTH'b000
`define CTL_IMMSEL_SIMM     `CTL_IMMSEL_WIDTH'b001
`define CTL_IMMSEL_BIMM     `CTL_IMMSEL_WIDTH'b010
`define CTL_IMMSEL_UIMM     `CTL_IMMSEL_WIDTH'b011
`define CTL_IMMSEL_JIMM     `CTL_IMMSEL_WIDTH'b100

// PC target base selector
`define CTL_PC_TARGET_BASE_WIDTH    1

`define CTL_PC_TARGET_BASE_NONE     `CTL_PC_TARGET_BASE_WIDTH'bx
`define CTL_PC_TARGET_BASE_SRC1     `CTL_PC_TARGET_BASE_WIDTH'b0
`define CTL_PC_TARGET_BASE_PC       `CTL_PC_TARGET_BASE_WIDTH'b1

`endif // __CONTROL_VH__
