module down_counter_tb;

localparam WIDTH = 4;
localparam START = 4'd8;

reg              clk;
reg              rst_n;
wire             en;
wire [WIDTH-1:0] data;
wire             carry;

initial clk = 0;
always begin
    #1 clk = ~clk;
end

reg [2:0] cnt = 0;
always @(posedge clk) begin
    cnt <= cnt + 1;
end

assign en = (cnt == 0);

initial begin
    rst_n = 1;
    #1 rst_n = 0;
    #1 rst_n = 1;

    #20 $finish;
end

initial begin
    $dumpvars;
    $display("Test started...");
end

down_counter #(
    .START (START)
) counter (
    .clk      (clk      ),
    .rst_n    (rst_n    ),
    .i_en     (en       ),
    .o_data   (data     ),
    .o_carry  (carry    )
);

endmodule


