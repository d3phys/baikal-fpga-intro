`include "alu.vh"

module alu #(
    parameter WIDTH = 32
)(
    input wire [`ALU_OP_WIDTH-1:0] i_op,

    input wire         [WIDTH-1:0] i_src1,
    input wire         [WIDTH-1:0] i_src2,

    output reg         [WIDTH-1:0] o_dest
);

// Verilog Std. 2005
// 10.4.5 Use of constant functions
function integer clogb2;
input [31:0] value;
begin
    value = value - 1;
    for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
        value = value >> 1;
    end
end
endfunction

localparam SHIFT_WIDTH = clogb2(WIDTH);
wire [SHIFT_WIDTH-1:0] shift = i_src2[SHIFT_WIDTH-1:0];

always @(*) begin
    case (i_op)
        `ALU_OP_ADD:    o_dest = i_src1 + i_src2;
        `ALU_OP_SUB:    o_dest = i_src1 - i_src2;
        `ALU_OP_XOR:    o_dest = i_src1 ^ i_src2;
        `ALU_OP_OR:     o_dest = i_src1 | i_src2;
        `ALU_OP_AND:    o_dest = i_src1 & i_src2;
        `ALU_OP_SLL:    o_dest = i_src1 << shift;
        `ALU_OP_SRL:    o_dest = i_src1 >> shift;
        `ALU_OP_SRA:    o_dest = $signed(i_src1) >>> shift;
        `ALU_OP_SLT:    o_dest = $signed(i_src1) < $signed(i_src2);
        `ALU_OP_SLTU:   o_dest = i_src1 < i_src2;
        default:        o_dest = {WIDTH{1'bx}};
    endcase
end

endmodule
