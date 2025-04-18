//
// Register File (2r1w) with Bypass
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

wire bypass1 = i_wr_en && (i_wr_addr == i_rd1_addr);
wire bypass2 = i_wr_en && (i_wr_addr == i_rd2_addr);

wire [WIDTH-1:0] rd1_data = bypass1 ? i_wr_data : data[i_rd1_addr];
wire [WIDTH-1:0] rd2_data = bypass2 ? i_wr_data : data[i_rd2_addr];

// Reading Risc-V r0 register is always zero
assign o_rd1_data = (i_rd1_addr == {$clog2(DEPTH){1'b0}}) ? {WIDTH{1'b0}} : rd1_data;
assign o_rd2_data = (i_rd2_addr == {$clog2(DEPTH){1'b0}}) ? {WIDTH{1'b0}} : rd2_data;

always @(posedge clk) begin
    if (i_wr_en) begin
        data[i_wr_addr] <= i_wr_data;
    end
end

endmodule

