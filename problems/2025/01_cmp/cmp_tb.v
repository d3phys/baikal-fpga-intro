`timescale 1ns/1ps

`include "cmp.vh"

module cmp_tb;

localparam WIDTH = 32;

reg [`CMP_OP_WIDTH-1:0] op;

reg         [WIDTH-1:0] src1;
reg         [WIDTH-1:0] src2;

wire                    taken;

task test_cmp_op (
    input [`CMP_OP_WIDTH-1:0] op,
    input         [WIDTH-1:0] src1,
    input         [WIDTH-1:0] src2,
    input                     expect
);
begin
    cmp_tb.op     = op;
    cmp_tb.src1   = src1;
    cmp_tb.src2   = src2;

    #1 /* Wait for CMP Unit */;

    if (expect == cmp_tb.taken) begin
        $display("[%0t] op=%h PASSED", $realtime, op);
    end else begin
        $display("[%0t] op=%h src1=%b src2=%b\ntaken = %b\nexpect = %b FAIL",
                 $realtime, op, src1, src2, cmp_tb.taken, expect);
    end
end
endtask

initial begin
    #1 test_cmp_op(`CMP_OP_BEQ,      32'd13,        32'd13,        1'b1);
    #1 test_cmp_op(`CMP_OP_BEQ,      32'd11,        32'd13,        1'b0);

    #1 test_cmp_op(`CMP_OP_BNE,      32'd13,        32'd11,        1'b1);
    #1 test_cmp_op(`CMP_OP_BNE,      32'd13,        32'd13,        1'b0);

    #1 test_cmp_op(`CMP_OP_BLT,      32'd03,        32'd04,        1'b1);
    #1 test_cmp_op(`CMP_OP_BLT,      32'd22,        32'd02,        1'b0);
    #1 test_cmp_op(`CMP_OP_BLT,     -32'd22,        32'd02,        1'b1);

    #1 test_cmp_op(`CMP_OP_BGE,      32'd12,        32'd02,        1'b1);
    #1 test_cmp_op(`CMP_OP_BGE,      32'd12,        32'd12,        1'b1);
    #1 test_cmp_op(`CMP_OP_BGE,      32'd11,        32'd12,        1'b0);

    #1 test_cmp_op(`CMP_OP_BLTU,    -32'd12,        32'd10,        1'b0);
    #1 test_cmp_op(`CMP_OP_BLTU,     32'd02,       -32'd01,        1'b1);
    #1 test_cmp_op(`CMP_OP_BLTU,     32'd02,        32'd04,        1'b1);

    #1 test_cmp_op(`CMP_OP_BGEU,    -32'd10,        32'd01,        1'b1);
    #1 test_cmp_op(`CMP_OP_BGEU,     32'd10,        32'd02,        1'b1);
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

cmp #(
    .WIDTH  (WIDTH)
) cmp_inst (
    .i_op    (op),
    .i_src1  (src1),
    .i_src2  (src2),
    .o_taken (taken)
);

endmodule

