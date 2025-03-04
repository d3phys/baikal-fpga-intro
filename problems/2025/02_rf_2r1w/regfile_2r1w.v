module regfile_2r1w #(
    parameter WIDTH = 32,
    parameter DEPTH = 32 
)(
    input wire clk,
    
    input  wire  [DEPTH-1:0] i_rd1_addr,
    output wire  [WIDTH-1:0] o_rd1_data,

    input  wire  [DEPTH-1:0] i_rd2_addr,
    output wire  [WIDTH-1:0] o_rd2_data,

    input  wire  [DEPTH-1:0] i_wr_addr,
    input  wire  [WIDTH-1:0] i_wr_data,
    input  wire              i_wr_en
);

reg [WIDTH-1:0] data[DEPTH-1:0];

assign o_rd1_data = data[i_rd1_addr];
assign o_rd2_data = data[i_rd2_addr];

always @(posedge clk) begin
    if (i_wr_en) begin
        data[i_wr_addr] <= i_wr_data;
    end
end

endmodule

