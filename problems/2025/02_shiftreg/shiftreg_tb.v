module shiftreg_tb;

localparam WIDTH = 8;

reg [WIDTH-1:0] wr_data;
reg             wr_en;
wire            data;

reg clk = 1'b0;
always begin
    #1 clk = ~clk;
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

initial begin
    wr_en   = 1'b1;
    wr_data = 8'b10101011;
    #2; // Load data
    wr_en   = 1'b0;
    #16;
    $finish;
end

shiftreg #(
    .WIDTH (WIDTH)
) sreg (
    .clk       (clk),
    .i_wr_data (wr_data),
    .i_wr_en   (wr_en),
    .o_data    (data)
);

endmodule

