`include "control.vh"
`include "alu.vh"
`include "cmp.vh"

module core #(
    parameter WIDTH = 32
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire [31:0] i_instr_data,
    output wire [29:0] o_instr_addr,
    
    output wire        o_instr_stall,

    output wire [29:0] o_mem_addr,
    output wire [31:0] o_mem_data,
    output wire        o_mem_we,
    output wire  [3:0] o_mem_mask,

    input  wire [31:0] i_mem_data
);

////////////////////////////////////////////////////////////////
//                       STAGE F0
////////////////////////////////////////////////////////////////

// RV32I immediates produced by each of the base instruction formats:
wire [31:0] f0_inst  = i_instr_data;
// I-immediate
wire [31:0] f0_imm_i = {{21{f0_inst[31]}}, f0_inst[30:25], f0_inst[24:21], f0_inst[20]};
// S-immediate
wire [31:0] f0_imm_s = {{21{f0_inst[31]}}, f0_inst[30:25], f0_inst[11:8], f0_inst[7]};
// B-immediate
wire [31:0] f0_imm_b = {{20{f0_inst[31]}}, f0_inst[7], f0_inst[30:25], f0_inst[11:8], 1'b0};
// U-immediate
wire [31:0] f0_imm_u = {f0_inst[31], f0_inst[30:20], f0_inst[19:12], {12{1'b0}}};
// J-immediate
wire [31:0] f0_imm_j = {{12{f0_inst[31]}}, f0_inst[19:12], f0_inst[20], f0_inst[30:25], f0_inst[24:21], 1'b0};

// RV32I Registers
wire                            [4:0] f0_rd  = f0_inst[11:7];
wire                            [4:0] f0_rs1 = f0_inst[19:15];
wire                            [4:0] f0_rs2 = f0_inst[24:20];
// Program Counter
reg                            [29:0] f0_pc;
wire                           [29:0] f0_pc_next;
wire                           [29:0] f0_pc_inc;
wire                           [29:0] f0_pc_target;
reg                            [29:0] f0_pc_target_base;
// Operands (read from Register file)
wire                           [31:0] f0_src1;
wire                           [31:0] f0_src2;
// Branch Unit
wire                                  f0_taken;
wire              [`CMP_OP_WIDTH-1:0] f0_cmp_op;
wire                                  f0_jump;
wire                                  f0_branch;
wire                                  f0_branch_taken;
// ALU control
wire              [`ALU_OP_WIDTH-1:0] f0_alu_op;
wire         [`CTL_ALUSEL1_WIDTH-1:0] f0_alu_sel1;
wire         [`CTL_ALUSEL2_WIDTH-1:0] f0_alu_sel2;
// ALU inputs/output
reg                            [31:0] f0_alu_src1;
reg                            [31:0] f0_alu_src2;
wire                           [31:0] f0_alu_res;
// LSU
wire                           [31:0] f0_lsu_addr;
wire                            [1:0] f0_lsu_size;
wire                                  f0_lsu_sign_ext;
wire                                  f0_lsu_we;
// Writeback
wire           [`CTL_WBSEL_WIDTH-1:0] f0_wb_sel;
wire                                  f0_wb_en;
// PC Target Base selector
wire  [`CTL_PC_TARGET_BASE_WIDTH-1:0] f0_pc_target_sel;
// Immediates selector
wire          [`CTL_IMMSEL_WIDTH-1:0] f0_imm_sel;
// Selected immediate
reg                            [31:0] f0_imm;

wire [31:0] f0_dbg_pc = {f0_pc, 2'b0};

//
// PC (Program Counter) update logic
//
always @(*) begin
    case (f0_pc_target_sel)
        `CTL_PC_TARGET_BASE_SRC1: f0_pc_target_base = f0_src1[31:2];
        `CTL_PC_TARGET_BASE_PC:   f0_pc_target_base = f0_pc;
        default:                  f0_pc_target_base = {30{1'bx}};
    endcase
end

assign f0_pc_target = f0_pc_target_base + f0_imm[31:2];
assign f0_taken     = f0_jump || (f0_branch && f0_branch_taken);
assign f0_pc_inc    = f0_pc + 30'b1;
assign f0_pc_next   = f0_taken ? f0_pc_target : f0_pc_inc;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        f0_pc <= 30'h0;
    end else begin
        f0_pc <= f0_pc_next;
    end
end

// Read next instruction
assign o_instr_addr  = f0_pc_next;
assign o_instr_stall = 1'b0;

cmp #(
    .WIDTH (32)
) cmp(
    .i_op    (f0_cmp_op                ),
    .i_src1  (f0_src1                  ),
    .i_src2  (f0_src2                  ),
    .o_taken (f0_branch_taken          )
);

// ALU Left-hand-side operand selector
always @(*) begin
    case (f0_alu_sel1)
        `CTL_ALUSEL1_SRC1: f0_alu_src1 = f0_src1;
        `CTL_ALUSEL1_IMM:  f0_alu_src1 = f0_imm;
        default:           f0_alu_src1 = {32{1'bx}};
    endcase
end

// ALU Right-hand-side operand selector
always @(*) begin
    case (f0_alu_sel2)
        `CTL_ALUSEL2_SRC2: f0_alu_src2 = f0_src2;
        `CTL_ALUSEL2_IMM:  f0_alu_src2 = f0_imm;
        `CTL_ALUSEL2_PC:   f0_alu_src2 = {f0_pc, 2'b00};
        default:           f0_alu_src2 = {32{1'bx}};
    endcase
end

alu #(
    .WIDTH (32)
) alu(
    .i_op   (f0_alu_op                ),
    .i_src1 (f0_alu_src1              ),
    .i_src2 (f0_alu_src2              ),
    .o_dest (f0_alu_res               )
);

// Decode immediate (to immediates decoder?)
always @(*) begin
    case (f0_imm_sel)
        `CTL_IMMSEL_IIMM: f0_imm = f0_imm_i;
        `CTL_IMMSEL_SIMM: f0_imm = f0_imm_s;
        `CTL_IMMSEL_BIMM: f0_imm = f0_imm_b;
        `CTL_IMMSEL_UIMM: f0_imm = f0_imm_u;
        `CTL_IMMSEL_JIMM: f0_imm = f0_imm_j;
        default:          f0_imm = {32{1'bx}};
    endcase
end

// Calculate LSU address
assign f0_lsu_addr = f0_src1 + f0_imm;

control control(
    .i_inst         (f0_inst              ),
    .o_alu_op       (f0_alu_op            ),
    .o_alu_sel1     (f0_alu_sel1          ),
    .o_alu_sel2     (f0_alu_sel2          ),
    .o_cmp_op       (f0_cmp_op            ),
    .o_branch       (f0_branch            ),
    .o_jump         (f0_jump              ),
    .o_wb_sel       (f0_wb_sel            ),
    .o_wb_en        (f0_wb_en             ),
    .o_lsu_size     (f0_lsu_size          ),
    .o_lsu_sign_ext (f0_lsu_sign_ext      ),
    .o_lsu_we       (f0_lsu_we            ),
    .o_imm_sel      (f0_imm_sel           ),
    .o_pc_base_sel  (f0_pc_target_sel     )
);

////////////////////////////////////////////////////////////////
//                       STAGE F1
////////////////////////////////////////////////////////////////

// RV32I Registers
reg                  [4:0] f1_rd;
// Program Counter
reg                 [29:0] f1_pc_inc;
// ALU
reg                 [31:0] f1_alu_res;
// Writeback
reg                  [1:0] f1_wb_sel;
reg                        f1_wb_en;
reg                 [31:0] f1_wb_data;
// U-immediate
reg                 [31:0] f1_imm_u;
// LSU
wire                [31:0] f1_lsu_data;

always @(*) begin
    case (f1_wb_sel)
        `CTL_WBSEL_ALU:   f1_wb_data = f1_alu_res;
        `CTL_WBSEL_LSU:   f1_wb_data = f1_lsu_data;
        `CTL_WBSEL_UIMM:  f1_wb_data = f1_imm_u;
        `CTL_WBSEL_PCINC: f1_wb_data = {f1_pc_inc, 2'b00};
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        f1_rd       <= 0;      
        f1_pc_inc   <= 0;         
        f1_alu_res  <= 0;         
        f1_wb_sel   <= 0;         
        f1_wb_en    <= 0;         
        f1_imm_u    <= 0;
    end else begin
        f1_rd       <= f0_rd;
        f1_pc_inc   <= f0_pc_inc;
        f1_alu_res  <= f0_alu_res;
        f1_wb_sel   <= f0_wb_sel;
        f1_wb_en    <= f0_wb_en;
        f1_imm_u    <= f0_imm_u;
    end
end

lsu lsu(
    .clk        (clk              ),
    .i_addr     (f0_lsu_addr      ),
    .i_data     (f0_src2          ),
    .i_we       (f0_lsu_we        ),
    .i_size     (f0_lsu_size      ),
    .i_sign_ext (f0_lsu_sign_ext  ),
    .o_data     (f1_lsu_data      ),

    .o_mem_addr (o_mem_addr       ),
    .o_mem_data (o_mem_data       ),
    .o_mem_we   (o_mem_we         ),
    .o_mem_mask (o_mem_mask       ),
    .i_mem_data (i_mem_data       )
);

// Register file (with bypass)
reg_file #(
    .WIDTH (32),
    .DEPTH (32)
) reg_file(
    .clk        (clk              ),

    .i_rd1_addr (f0_rs1           ),
    .o_rd1_data (f0_src1          ),

    .i_rd2_addr (f0_rs2           ),
    .o_rd2_data (f0_src2          ),

    .i_wr_addr  (f1_rd            ),
    .i_wr_data  (f1_wb_data       ),
    .i_wr_en    (f1_wb_en         )
);

endmodule



