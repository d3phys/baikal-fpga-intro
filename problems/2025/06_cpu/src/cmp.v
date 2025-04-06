`include "cmp.vh"

module cmp #(
    parameter WIDTH = 32
)(
    input wire [`CMP_OP_WIDTH-1:0] i_op,

    input wire         [WIDTH-1:0] i_src1,
    input wire         [WIDTH-1:0] i_src2,

    output reg                     o_taken
);

always @(*) begin
    case (i_op)
        `CMP_OP_BEQ:    o_taken = (i_src1 == i_src2);
        `CMP_OP_BNE:    o_taken = (i_src1 != i_src2);
        `CMP_OP_BLT:    o_taken = ($signed(i_src1) <  $signed(i_src2));
        `CMP_OP_BGE:    o_taken = ($signed(i_src1) >= $signed(i_src2));
        `CMP_OP_BLTU:   o_taken = (i_src1 <  i_src2);
        `CMP_OP_BGEU:   o_taken = (i_src1 >= i_src2);
        default:        o_taken = 1'bx;
    endcase
end

endmodule
