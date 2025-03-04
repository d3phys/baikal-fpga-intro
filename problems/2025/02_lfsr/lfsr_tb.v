module lfsr_tb;

reg rst_n;
reg en;
wire data;

reg clk = 1'b0;
always begin
    #1 clk = ~clk;
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

initial begin
    rst_n = 1'b0;
    #1;
    rst_n = 1'b1;
    #1;
    en = 1'b1;
    #32;
    $finish;
end

lfsr lfsr_inst
(
    .clk    (clk),
    .rst_n  (rst_n),
    .i_en   (en),
    .o_data (data)
);

endmodule

