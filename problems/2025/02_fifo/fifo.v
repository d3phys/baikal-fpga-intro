module fifo #(
    parameter DATAW = 8,
    parameter ADDRW = 4
)(
    input  wire             clk,
    input  wire             rst_n,

    input  wire             i_wr_en,
    input  wire [DATAW-1:0] i_wr_data,
    output wire             o_wr_full,

    input  wire             i_rd_en,
    output wire [DATAW-1:0] o_rd_data,
    output wire             o_rd_empty
);

// Memory:
reg [DATAW-1:0] data[2**ADDRW-1:0];

reg    [ADDRW:0] rd_ptr,  wr_ptr;
wire             rd_hi,   wr_hi;
wire [ADDRW-1:0] rd_addr, wr_addr;

assign {rd_hi, rd_addr} = rd_ptr;
assign {wr_hi, wr_addr} = wr_ptr;

// Set full/empty flags:
assign o_rd_empty = (rd_hi == wr_hi) && (rd_addr == wr_addr);
assign o_wr_full  = (rd_hi != wr_hi) && (rd_addr == wr_addr);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <= 0;
    end else begin
        if (i_wr_en) begin
            data[wr_addr] <= i_wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end
end

assign o_rd_data = data[rd_addr];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <= 0;
    end else begin
        if (i_rd_en) begin
            rd_ptr <= rd_ptr + 1;
        end
    end
end

endmodule


