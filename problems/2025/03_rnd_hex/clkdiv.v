module clkdiv #(
    parameter F0 = 50_000_000,
    parameter F1 = 12_500_000
)(
    input  clk,
    input  rst_n,
    output out
);

localparam PERIOD = F0 / F1;
localparam CNT_WIDTH = $clog2(PERIOD);

reg [CNT_WIDTH-1:0] cnt;

wire overflow;
assign overflow = (cnt == PERIOD - 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
    end else begin
        if (overflow) begin
            cnt <= {CNT_WIDTH{1'b0}};
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

assign out = overflow;

endmodule
