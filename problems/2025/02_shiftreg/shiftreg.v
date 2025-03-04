module shiftreg #(
    parameter WIDTH = 8
)(
    input  wire              clk,
    
    input  wire  [WIDTH-1:0] i_wr_data,
    input  wire              i_wr_en,

    output wire              o_data
);

reg [WIDTH-1:0] data;

assign o_data = data[WIDTH-1];

always @(posedge clk) begin
    if (i_wr_en) begin
        data <= i_wr_data;
    end else begin
        data <= {data[WIDTH-2:0], 1'b0};
    end
end

endmodule

