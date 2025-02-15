`timescale 1ns/1ps

`include "alu.vh"

// Additionaly define "Unknown ALU Operation"
`define ALU_OP_UNKNOWN  `ALU_OP_WIDTH'hC

module alu_tb;

localparam WIDTH = 32;

reg [`ALU_OP_WIDTH-1:0] op = `ALU_OP_UNKNOWN;

reg         [WIDTH-1:0] src1;
reg         [WIDTH-1:0] src2;

wire        [WIDTH-1:0] dest;

task test_alu_op (
    input [`ALU_OP_WIDTH-1:0] op,
    input         [WIDTH-1:0] src1,
    input         [WIDTH-1:0] src2,
    input         [WIDTH-1:0] expect
);
begin
    alu_tb.op     = op;
    alu_tb.src1   = src1;
    alu_tb.src2   = src2;

    #1 /* Wait for ALU */;

    if (expect == alu_tb.dest) begin
        $display("[%0t] op=%h PASSED", $realtime, op);
    end else begin
        $display("[%0t] op=%h src1=%b src2=%b\ndest   = %b\nexpect = %b FAIL",
                 $realtime, op, src1, src2, alu_tb.dest, expect);
    end
end
endtask

initial begin
    #1 test_alu_op(`ALU_OP_ADD,      32'd10,        32'd13,        32'd23       );
    #1 test_alu_op(`ALU_OP_SUB,      32'd33,        32'd01,        32'd32       );
    #1 test_alu_op(`ALU_OP_XOR,      32'b0010_1111, 32'b1110_0111, 32'b1100_1000);
    #1 test_alu_op(`ALU_OP_OR,       32'b0101_1101, 32'b1010_0010, 32'b1111_1111);
    #1 test_alu_op(`ALU_OP_AND,      32'b0101_1101, 32'b1111_1111, 32'b0101_1101);
    #1 test_alu_op(`ALU_OP_SLT,     -32'd10,        32'd01,        32'd1        );
    #1 test_alu_op(`ALU_OP_SLTU,    -32'd10,        32'd01,        32'd0        );

    #1 test_alu_op(`ALU_OP_SLL,
                    32'b10010010_01001000_10101011_00100100,
                    32'b11010100_00001000_10101011_01001000,
                    32'b01001000_10101011_00100100_00000000);

    #1 test_alu_op(`ALU_OP_SRL,
                    32'b10010010_01001000_10101011_00100100,
                    32'b11010100_00001000_10101011_01001000,
                    32'b00000000_10010010_01001000_10101011);

    #1 test_alu_op(`ALU_OP_SRA,
                    32'b10010010_01001000_10101011_00100100,
                    32'b11010100_00001000_10101011_01001000,
                    32'b11111111_10010010_01001000_10101011);
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

alu #(
    .WIDTH  (WIDTH)
) alu_inst (
    .i_op   (op),
    .i_src1 (src1),
    .i_src2 (src2),
    .o_dest (dest)
);

endmodule

