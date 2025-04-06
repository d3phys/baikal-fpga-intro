//
// See: The RISC-V Instruction Set Manual Volume I: Unprivileged Architecture
//      Chapter 37. RV32/64G Instruction Set Listings
//
//
//       Name    No.    funct7      funct3  Opcode      ALU select 1
//       |       |      |           |       |           |      ALU select 2
//       |       |      |           |       |           |      |     ALU operation
//       |       |      |           |       |           |      |     |     Is Branch?
//       |       |      |           |       |           |      |     |     |     Is Jump?
//       |       |      |           |       |           |      |     |     |     |     CMP Unit operation
//       |       |      |           |       |           |      |     |     |     |     |     Writeback select
//       |       |      |           |       |           |      |     |     |     |     |     |      Writeback enable?
//       |       |      |           |       |           |      |     |     |     |     |     |      |     LSU Size (2^x)
//       |       |      |           |       |           |      |     |     |     |     |     |      |     |      LSU Sign Extend?
//       |       |      |           |       |           |      |     |     |     |     |     |      |     |      |     LSU Write enable?
//       |       |      |           |       |           |      |     |     |     |     |     |      |     |      |     |     Is Load?
//       |       |      |           |       |           |      |     |     |     |     |     |      |     |      |     |     |
`OPCODE( LUI   , 6'h00, 7'b???????, 3'b???, 7'b0110111, NONE,  NONE, NONE, 1'b0, 1'b0, NONE,  UIMM, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( AUIPC , 6'h01, 7'b???????, 3'b???, 7'b0010111, UIMM,    PC,  ADD, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )

`OPCODE( JAL   , 6'h02, 7'b???????, 3'b???, 7'b1101111, JIMM,    PC,  ADD, 1'b0, 1'b1, NONE, PCINC, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( JALR  , 6'h03, 7'b???????, 3'b000, 7'b1100111, SRC1,  IIMM,  ADD, 1'b0, 1'b1, NONE, PCINC, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )

`OPCODE( BEQ   , 6'h04, 7'b???????, 3'b000, 7'b1100011, BIMM,    PC,  ADD, 1'b1, 1'b0,  BEQ,  NONE, 1'b0, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( BNE   , 6'h05, 7'b???????, 3'b001, 7'b1100011, BIMM,    PC,  ADD, 1'b1, 1'b0,  BNE,  NONE, 1'b0, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( BLT   , 6'h06, 7'b???????, 3'b100, 7'b1100011, BIMM,    PC,  ADD, 1'b1, 1'b0,  BLT,  NONE, 1'b0, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( BGE   , 6'h07, 7'b???????, 3'b101, 7'b1100011, BIMM,    PC,  ADD, 1'b1, 1'b0,  BGE,  NONE, 1'b0, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( BLTU  , 6'h08, 7'b???????, 3'b110, 7'b1100011, BIMM,    PC,  ADD, 1'b1, 1'b0, BLTU,  NONE, 1'b0, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( BGEU  , 6'h09, 7'b???????, 3'b111, 7'b1100011, BIMM,    PC,  ADD, 1'b1, 1'b0, BGEU,  NONE, 1'b0, 2'bxx, 1'bx, 1'b0, 1'b0 )

`OPCODE( LB    , 6'h0A, 7'b???????, 3'b000, 7'b0000011, SRC1,  IIMM,  ADD, 1'b0, 1'b0, NONE,   LSU, 1'b1, 2'b00, 1'b1, 1'b0, 1'b1 )
`OPCODE( LH    , 6'h0B, 7'b???????, 3'b001, 7'b0000011, SRC1,  IIMM,  ADD, 1'b0, 1'b0, NONE,   LSU, 1'b1, 2'b01, 1'b1, 1'b0, 1'b1 )
`OPCODE( LW    , 6'h0C, 7'b???????, 3'b010, 7'b0000011, SRC1,  IIMM,  ADD, 1'b0, 1'b0, NONE,   LSU, 1'b1, 2'b10, 1'b1, 1'b0, 1'b1 )
`OPCODE( LBU   , 6'h0D, 7'b???????, 3'b100, 7'b0000011, SRC1,  IIMM,  ADD, 1'b0, 1'b0, NONE,   LSU, 1'b1, 2'b00, 1'b0, 1'b0, 1'b1 )
`OPCODE( LHU   , 6'h0E, 7'b???????, 3'b101, 7'b0000011, SRC1,  IIMM,  ADD, 1'b0, 1'b0, NONE,   LSU, 1'b1, 2'b01, 1'b0, 1'b0, 1'b1 )

`OPCODE( SB    , 6'h0F, 7'b???????, 3'b000, 7'b0100011, SRC1,  SIMM,  ADD, 1'b0, 1'b0, NONE,  NONE, 1'b0, 2'b00, 1'bx, 1'b1, 1'b0 )
`OPCODE( SH    , 6'h10, 7'b???????, 3'b001, 7'b0100011, SRC1,  SIMM,  ADD, 1'b0, 1'b0, NONE,  NONE, 1'b0, 2'b01, 1'bx, 1'b1, 1'b0 )
`OPCODE( SW    , 6'h11, 7'b???????, 3'b010, 7'b0100011, SRC1,  SIMM,  ADD, 1'b0, 1'b0, NONE,  NONE, 1'b0, 2'b10, 1'bx, 1'b1, 1'b0 )

`OPCODE( ADDI  , 6'h12, 7'b???????, 3'b000, 7'b0010011, SRC1,  IIMM,  ADD, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SLTI  , 6'h13, 7'b???????, 3'b010, 7'b0010011, SRC1,  IIMM,  SLT, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SLTIU , 6'h14, 7'b???????, 3'b011, 7'b0010011, SRC1,  IIMM, SLTU, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( XORI  , 6'h15, 7'b???????, 3'b100, 7'b0010011, SRC1,  IIMM,  XOR, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( ORI   , 6'h16, 7'b???????, 3'b110, 7'b0010011, SRC1,  IIMM,   OR, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( ANDI  , 6'h17, 7'b???????, 3'b111, 7'b0010011, SRC1,  IIMM,  AND, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SLLI  , 6'h18, 7'b0000000, 3'b001, 7'b0010011, SRC1,  IIMM,  SLL, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SRLI  , 6'h19, 7'b0000000, 3'b101, 7'b0010011, SRC1,  IIMM,  SRL, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SRAI  , 6'h1A, 7'b0100000, 3'b101, 7'b0010011, SRC1,  IIMM,  SRA, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )

`OPCODE( ADD   , 6'h1B, 7'b0000000, 3'b000, 7'b0110011, SRC1,  SRC2,  ADD, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SUB   , 6'h1C, 7'b0100000, 3'b000, 7'b0110011, SRC1,  SRC2,  SUB, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SLL   , 6'h1D, 7'b0000000, 3'b001, 7'b0110011, SRC1,  SRC2,  SLL, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SLT   , 6'h1E, 7'b0000000, 3'b010, 7'b0110011, SRC1,  SRC2,  SLT, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SLTU  , 6'h1F, 7'b0000000, 3'b011, 7'b0110011, SRC1,  SRC2, SLTU, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( XOR   , 6'h20, 7'b0000000, 3'b100, 7'b0110011, SRC1,  SRC2,  XOR, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SRL   , 6'h21, 7'b0000000, 3'b101, 7'b0110011, SRC1,  SRC2,  SRL, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( SRA   , 6'h22, 7'b0100000, 3'b101, 7'b0110011, SRC1,  SRC2,  SRA, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( OR    , 6'h23, 7'b0000000, 3'b110, 7'b0110011, SRC1,  SRC2,   OR, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )
`OPCODE( AND   , 6'h24, 7'b0000000, 3'b111, 7'b0110011, SRC1,  SRC2,  AND, 1'b0, 1'b0, NONE,   ALU, 1'b1, 2'bxx, 1'bx, 1'b0, 1'b0 )

