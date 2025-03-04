module regfile_2r1w_tb;

localparam WIDTH = 32;
localparam DEPTH = 32;

reg clk = 1'b0;

reg   [DEPTH-1:0] rd1_addr;
wire  [WIDTH-1:0] rd1_data;

reg   [DEPTH-1:0] rd2_addr;
wire  [WIDTH-1:0] rd2_data;

reg   [DEPTH-1:0] wr_addr;
reg   [WIDTH-1:0] wr_data;
reg               wr_en;

regfile_2r1w #(
    .WIDTH (WIDTH),
    .DEPTH (DEPTH)
) regfile (
    .clk        (clk),
    
    .i_rd1_addr (rd1_addr),
    .o_rd1_data (rd1_data),

    .i_rd2_addr (rd2_addr),
    .o_rd2_data (rd2_data),

    .i_wr_addr  (wr_addr),
    .i_wr_data  (wr_data),
    .i_wr_en    (wr_en)  
);

always begin
    #1 clk = ~clk;
end

always @(posedge clk) begin
    wr_addr <= wr_addr + 1;
    wr_data <= wr_data + 1;
end

reg read = 1'b0;
always @(posedge clk) begin
    if (read) begin
        rd1_addr <= rd1_addr + 1'b1;
        rd2_addr <= rd2_addr + 1'b1;
    end
end

always begin
    #2;

    if (read) begin
        if (rd1_addr == rd1_data) begin
            $display("[%0t] Port1: addr = %d OK", $realtime, rd1_addr);
        end else begin
            $display("[%0t] Port1: addr = %d FAIL", $realtime, rd1_addr);
        end

        if (rd2_addr == rd2_data) begin
            $display("[%0t] Port2: addr = %d OK", $realtime, rd1_addr);
        end else begin
            $display("[%0t] Port2: addr = %d FAIL", $realtime, rd1_addr);
        end
    end
end

initial begin
    rd1_addr = 0;
    rd2_addr = 0;

    wr_addr  = 0;
    wr_data  = 0;
    wr_en    = 1;

    #4;
    // Start reading
    read = 1'b1;

    #60;
    wr_en = 1'b0;
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
    #66 $finish;
end

endmodule

