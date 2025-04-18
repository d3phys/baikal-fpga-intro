module mem_xbar #(
    parameter DATA_START = 30'b0,
    parameter DATA_LIMIT = 30'b0,
    parameter MMIO_START = 30'b0,
    parameter MMIO_LIMIT = 30'b0
)(
    input  wire        clk,

    input  wire [29:0] i_addr,
    input  wire [31:0] i_data,
    input  wire        i_wren,
    input  wire  [3:0] i_mask,
    output reg  [31:0] o_data,

    output reg  [29:0] o_dmem_addr,
    output reg  [31:0] o_dmem_data,
    output reg   [3:0] o_dmem_mask,
    output reg         o_dmem_wren,
    input  wire [31:0] i_dmem_data,

    output reg  [29:0] o_mmio_addr,
    output reg  [31:0] o_mmio_data,
    output reg   [3:0] o_mmio_mask,
    output reg         o_mmio_wren,
    input  wire [31:0] i_mmio_data
);

reg [29:0] addr;
always @(posedge clk) begin
    addr <= i_addr;
end

// Load something at the next clock
always @(*) begin
    if (addr >= DATA_START && addr <= DATA_LIMIT) begin
        o_data = i_dmem_data;
    end else if (addr >= MMIO_START && addr <= MMIO_LIMIT) begin
        o_data = i_mmio_data;
    end else begin
        o_data = {32{1'bx}};
    end
end

// Store something at the current clock
always @(*) begin
    if (i_addr >= MMIO_START && i_addr <= MMIO_LIMIT) begin
        o_mmio_addr = i_addr - MMIO_START;
        o_mmio_data = i_data;
        o_mmio_wren = i_wren;
        o_mmio_mask = i_mask;
    end else begin
        o_mmio_addr = {30{1'bx}};
        o_mmio_data = {32{1'bx}};
        o_mmio_wren = 1'bx;
        o_mmio_mask = 4'bxxxx;
    end
end

always @(*) begin
    if (i_addr >= DATA_START && i_addr <= DATA_LIMIT) begin
        o_dmem_addr = i_addr - DATA_START;
        o_dmem_data = i_data;
        o_dmem_wren = i_wren;
        o_dmem_mask = i_mask;
    end else begin
        o_dmem_addr = {30{1'bx}};
        o_dmem_data = {32{1'bx}};
        o_dmem_wren = 1'bx;
        o_dmem_mask = 4'bxxxx;
    end
end

endmodule
