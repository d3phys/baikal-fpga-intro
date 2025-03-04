module lfsr
(
    input  wire clk,
    input  wire rst_n,
    input  wire i_en,
    output wire o_data
);

localparam WIDTH = 8;

reg [WIDTH-1:0] data;

assign o_data = data[WIDTH-1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= {{WIDTH-1{1'b0}}, 1'b1};
    end else if (i_en) begin
        // Commonly used p(x) = x^8 + x^6 + x^5 + x^4 + 1
        // with 255 states:
        data <= {data[WIDTH-2:0], data[7] ^ data[5] ^ data[4] ^ data[3]};
    end
end

endmodule

