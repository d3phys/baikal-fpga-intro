// Test helpers:
`define ASSERT(condition, msg)                                    \
    if(!(condition)) begin                                        \
        $display("FAIL: %s at %s:%d", msg, `__FILE__, `__LINE__); \
        $finish(1);                                               \
    end

module fifo_tb;

localparam DATAW = 8;
localparam ADDRW = 2;

reg clk = 1'b0;
always begin
    #1 clk = ~clk;
end

reg              rst_n;

reg              wr_en;
reg  [DATAW-1:0] wr_data;
wire             wr_full;

reg              rd_en;
wire [DATAW-1:0] rd_data;
wire             rd_empty;

initial begin
    // Initial state
       wr_en   = 1'b0;
       rd_en   = 1'b0;

    // Reset FIFO
    #1 rst_n = 1'b0;
    #1 rst_n = 1'b1;

    #2 `ASSERT(rd_empty, "FIFO must be empty");

       wr_en   = 1'b1;
       wr_data = 1;
    #2 wr_data = 2;
    #2 wr_data = 3;
    #2 wr_data = 4;
    #2 wr_en   = 1'b0;

    #2 `ASSERT(wr_full, "FIFO must be full");

       rd_en   = 1'b1;
       `ASSERT(rd_data == 1, "Invalid data");
    #2 `ASSERT(rd_data == 2, "Invalid data");
    #2 `ASSERT(rd_data == 3, "Invalid data");
    #2 `ASSERT(rd_data == 4, "Invalid data");
    #2 rd_en   = 1'b0;

    #4 `ASSERT(rd_empty, "FIFO must be empty");

    $finish;
end

fifo #(
    .DATAW (DATAW),
    .ADDRW (ADDRW)
) fifo_inst (
    .clk        (clk),
    .rst_n      (rst_n),

    .i_wr_en    (wr_en),
    .i_wr_data  (wr_data),
    .o_wr_full  (wr_full),

    .i_rd_en    (rd_en),
    .o_rd_data  (rd_data),
    .o_rd_empty (rd_empty)
);

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

endmodule

