`include "cmp.vh"
`include "alu.vh"
`include "control.vh"

//
// Control/Decode unit
//
module control
(
    // Instruction
    input  wire                     [31:0] i_inst,
    // To ALU
    output reg         [`ALU_OP_WIDTH-1:0] o_alu_op,
    output reg    [`CTL_ALUSEL1_WIDTH-1:0] o_alu_sel1,
    output reg    [`CTL_ALUSEL2_WIDTH-1:0] o_alu_sel2,
    // To Branch Unit (CMP + logic)
    output reg         [`CMP_OP_WIDTH-1:0] o_cmp_op,
    output reg                             o_branch,
    output reg                             o_jump,
    // To Writeback
    output reg      [`CTL_WBSEL_WIDTH-1:0] o_wb_sel,
    output reg                             o_wb_en,
    // To LSU
    output reg                       [1:0] o_lsu_size,
    output reg                             o_lsu_sign_ext,
    output reg                             o_lsu_we
);

wire [2:0] funct3 = i_inst[14:12];
wire [6:0] opcode = i_inst[6:0];
wire [6:0] funct7 = i_inst[31:25];

reg  [5:0] logic_op; // Logic Opcode (Debug)

`define OPCODE( Name, No, Funct7, Funct3, Opcode, ALUSel1, ALUSel2, ALUOp, Branch, Jump, CmpOp, WBSel, WBEn, LSUSize, LSUSign, LSUWrEn) \
    {Funct7, Funct3, Opcode}: begin                \
        o_alu_sel1     = `CTL_ALUSEL1_``ALUSel1``; \
        o_alu_sel2     = `CTL_ALUSEL2_``ALUSel2``; \
        o_alu_op       = `ALU_OP_``ALUOp``;        \
        o_branch       = Branch;                   \
        o_jump         = Jump;                     \
        o_cmp_op       = `CMP_OP_``CmpOp``;        \
        o_wb_sel       = `CTL_WBSEL_``WBSel``;     \
        o_wb_en        = WBEn;                     \
        o_lsu_size     = LSUSize;                  \
        o_lsu_sign_ext = LSUSign;                  \
        o_lsu_we       = LSUWrEn;                  \
        logic_op       = No;                       \
    end
        
always @(*) begin
    casez ({funct7, funct3, opcode})
        `include "opcodes.mac.vh"
        default: begin
            o_alu_sel1     = `CTL_ALUSEL1_NONE;        
            o_alu_sel2     = `CTL_ALUSEL2_NONE;        
            o_alu_op       = `ALU_OP_NONE;             
            o_branch       = 1'b0;                   
            o_jump         = 1'b0;                     
            o_cmp_op       = `CMP_OP_NONE;        
            o_wb_sel       = `CTL_WBSEL_NONE;     
            o_wb_en        = 1'b0;                     
            o_lsu_size     = 2'bxx;                  
            o_lsu_sign_ext = 1'bx;                  
            o_lsu_we       = 1'b0;                  
            logic_op       = 6'bxxxxxx;                       
        end
    endcase
end

`undef OPCODE

endmodule




