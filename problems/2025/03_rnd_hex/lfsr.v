module lfsr #(
    parameter WIDTH = 16,
    parameter SEED  = 16'h01
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             i_en,
    output reg  [WIDTH-1:0] o_data
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_data <= SEED;
    end else if (i_en) begin
        // Polynomial used p(x) = x^16 + x^14 + x^13 + x^11 + 1
        // Gives: 2^16-1 states
        o_data <= {o_data[WIDTH-2:0], o_data[15] ^ o_data[13] ^ o_data[12] ^ o_data[10]};
    end
end

endmodule

