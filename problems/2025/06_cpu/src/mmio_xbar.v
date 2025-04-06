`include "config.vh"

module mmio_xbar(
    input  wire [29:0] i_mmio_addr,
    input  wire [31:0] i_mmio_data,
    input  wire  [3:0] i_mmio_mask,
    input  wire        i_mmio_wren,
    output wire [31:0] o_mmio_data,

    output reg  [15:0] o_hexd_data,
    output reg         o_hexd_wren
);

// Reading MMIO registers is always zero for now
assign o_mmio_data = 32'b0;

always @(*) begin
    if (i_mmio_addr == `XBAR_HEXD_ADDR0 && i_mmio_mask == 4'b1111) begin
        o_hexd_data = i_mmio_data[15:0];
        o_hexd_wren = i_mmio_wren;
    end else begin
        o_hexd_data = {16{1'bx}};
        o_hexd_wren = i_mmio_wren;
    end
end

endmodule
