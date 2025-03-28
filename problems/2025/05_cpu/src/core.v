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

    output wire [29:0] o_mem_addr,
    output wire [31:0] o_mem_data,
    output wire        o_mem_we,
    output wire  [3:0] o_mem_mask,

    input  wire [31:0] i_mem_data
);

reg  [29:0] pc;
wire [29:0] pc_next;
wire [29:0] pc_inc;

wire [4:0] rd  = inst[11:7];
wire [4:0] rs1 = inst[19:15];
wire [4:0] rs2 = inst[24:20];

wire [31:0] src1;
wire [31:0] src2;

//
// RV32I immediates produced by each of the base instruction formats:
//
wire [31:0] inst  = i_instr_data;
// I-immediate
wire [31:0] imm_i = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
// S-immediate
wire [31:0] imm_s = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
// B-immediate
wire [31:0] imm_b = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
// U-immediate
wire [31:0] imm_u = {inst[31], inst[30:20], inst[19:12], {12{1'b0}}};
// J-immediate
wire [31:0] imm_j = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};


// Branch Unit
wire                       taken;
wire   [`CMP_OP_WIDTH-1:0] cmp_op;
wire                       jump;
wire                       branch;
wire                       branch_taken;
// Writeback data
wire                 [1:0] wb_sel;
wire                       wb_en;
reg                 [31:0] wb_data;
// ALU control
wire   [`ALU_OP_WIDTH-1:0] alu_op;
wire                 [1:0] alu_sel1;
wire                 [1:0] alu_sel2;
// ALU inputs/output
reg                 [31:0] alu_src1;
reg                 [31:0] alu_src2;
wire                [31:0] alu_res;
// LSU
wire                [31:0] lsu_data;
wire                 [1:0] lsu_size;
wire                       lsu_sign_ext;
wire                       lsu_we;

//
// PC (Program Counter) update logic
//
assign taken   = jump || (branch && branch_taken);

assign pc_inc  = pc + 30'b1;
assign pc_next = taken ? alu_res[31:2] : pc_inc;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc <= 30'h0;
    end else begin
        pc <= pc_next;
    end
end

// Read next instruction at PC
assign o_instr_addr = pc;

//
// Arbitration logic:
//
always @(*) begin
    case (alu_sel1)
        `CTL_ALUSEL1_SRC1: alu_src1 = src1;
        `CTL_ALUSEL1_UIMM: alu_src1 = imm_u;
        `CTL_ALUSEL1_BIMM: alu_src1 = imm_b;
        `CTL_ALUSEL1_JIMM: alu_src1 = imm_j;
    endcase
end

always @(*) begin
    case (alu_sel2)
        `CTL_ALUSEL2_SRC2: alu_src2 = src2;
        `CTL_ALUSEL2_IIMM: alu_src2 = imm_i;
        `CTL_ALUSEL2_SIMM: alu_src2 = imm_s;
        `CTL_ALUSEL2_PC:   alu_src2 = {pc, 2'b00};
    endcase
end

always @(*) begin
    case (wb_sel)
        `CTL_WBSEL_ALU:   wb_data = alu_res;
        `CTL_WBSEL_LSU:   wb_data = lsu_data;
        `CTL_WBSEL_UIMM:  wb_data = imm_u;
        `CTL_WBSEL_PCINC: wb_data = {pc_inc, 2'b00};
    endcase
end

control control(
    .i_inst         (inst              ),
    .o_alu_op       (alu_op            ),
    .o_alu_sel1     (alu_sel1          ),
    .o_alu_sel2     (alu_sel2          ),
    .o_cmp_op       (cmp_op            ),
    .o_branch       (branch            ),
    .o_jump         (jump              ),
    .o_wb_sel       (wb_sel            ),
    .o_wb_en        (wb_en             ),
    .o_lsu_size     (lsu_size          ),
    .o_lsu_sign_ext (lsu_sign_ext      ),
    .o_lsu_we       (lsu_we            )
);

cmp #(
    .WIDTH (32)
) cmp(
    .i_op    (cmp_op                ),
    .i_src1  (src1                  ),
    .i_src2  (src2                  ),
    .o_taken (branch_taken          )
);

alu #(
    .WIDTH (32)
) alu(
    .i_op   (alu_op                ),
    .i_src1 (alu_src1              ),
    .i_src2 (alu_src2              ),
    .o_dest (alu_res               )
);

reg_file #(
    .WIDTH (32),
    .DEPTH (32)
) reg_file(
    .clk        (clk               ),

    .i_rd1_addr (rs1               ),
    .o_rd1_data (src1              ),

    .i_rd2_addr (rs2               ),
    .o_rd2_data (src2              ),

    .i_wr_addr  (rd                ),
    .i_wr_data  (wb_data           ),
    .i_wr_en    (wb_en             )
);

lsu lsu(
    .i_addr      (alu_res          ),
    .i_data      (src2             ),
    .i_we        (lsu_we           ),
    .i_size      (lsu_size         ),
    .i_sign_ext  (lsu_sign_ext     ),
    .o_data      (lsu_data         ),

    .o_mem_addr  (o_mem_addr       ),
    .o_mem_data  (o_mem_data       ),
    .o_mem_we    (o_mem_we         ),
    .o_mem_mask  (o_mem_mask       ),
    .i_mem_data  (i_mem_data       )
);

endmodule



