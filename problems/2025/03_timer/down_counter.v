module down_counter #(
    parameter WIDTH = 4,
    parameter START = 4'd0
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             i_en,

    output wire [WIDTH-1:0] o_data,
    output wire             o_carry
);

reg [WIDTH-1:0] data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= START;
    end else begin
        if (i_en) begin
            data <= o_carry ? 4'd9 : data - 4'd1;
        end
    end
end

assign o_data = data;
assign o_carry = i_en && (data == 0);

endmodule


