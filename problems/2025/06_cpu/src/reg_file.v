//
// Register File (2r1w)
//
module reg_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 32
)(
    input wire                       clk,
    
    input  wire  [$clog2(DEPTH)-1:0] i_rd1_addr,
    output wire          [WIDTH-1:0] o_rd1_data,

    input  wire  [$clog2(DEPTH)-1:0] i_rd2_addr,
    output wire          [WIDTH-1:0] o_rd2_data,

    input  wire  [$clog2(DEPTH)-1:0] i_wr_addr,
    input  wire          [WIDTH-1:0] i_wr_data,
    input  wire                      i_wr_en
);

reg [WIDTH-1:0] data[DEPTH-1:0];

// Reading Risc-V r0 register is always zero
assign o_rd1_data = (i_rd1_addr == {$clog2(DEPTH){1'b0}}) ? {WIDTH{1'b0}} : data[i_rd1_addr];
assign o_rd2_data = (i_rd2_addr == {$clog2(DEPTH){1'b0}}) ? {WIDTH{1'b0}} : data[i_rd2_addr];

always @(posedge clk) begin
    if (i_wr_en) begin
        data[i_wr_addr] <= i_wr_data;
    end
end

endmodule

