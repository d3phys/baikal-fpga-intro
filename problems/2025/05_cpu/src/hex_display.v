module hex_display #(
    parameter CNT_WIDTH = 14
)(
   input  wire        clk,
   input  wire        rst_n,
   input  wire [15:0] i_data,
   output wire  [3:0] o_anodes,
   output reg   [7:0] o_segments
);

reg [CNT_WIDTH-1:0] cnt;
wire          [1:0] pos = cnt[CNT_WIDTH-1:CNT_WIDTH-2];

// Input is 4 digits:
wire [3:0] digit3, digit2, digit1, digit0;
assign {digit3, digit2, digit1, digit0} = i_data;

reg [3:0] digit;

always @(*) begin
    case (pos)
       2'h0: digit = digit0;
       2'h1: digit = digit1;
       2'h2: digit = digit2;
       2'h3: digit = digit3;
    endcase
end

always @(posedge clk or negedge rst_n)
   cnt <= !rst_n ? {CNT_WIDTH{1'b0}} : (cnt + 1'b1);

assign o_anodes = ~(4'b1 << pos);

//
// 7-segment display:
//
//       +-A-+     +-A-+     +-A-+     +-A-+
//       F   B     F   B     F   B     F   B
//       +-G-+     +-G-+     +-G-+     +-G-+
//       E   C     E   C     E   C     E   C
//       +-D-+ P   +-D-+ P   +-D-+ P   +-D-+ P
//
//         ^         ^         ^         ^
// Anode:  0         1         2         3
// 
always @(*) begin
   case (digit)           // ABCDEFG P (Point/Dot)
       4'h0: o_segments = 8'b1111110_0;
       4'h1: o_segments = 8'b0110000_0;
       4'h2: o_segments = 8'b1101101_0;
       4'h3: o_segments = 8'b1111001_0;
       4'h4: o_segments = 8'b0110011_0;
       4'h5: o_segments = 8'b1011011_0;
       4'h6: o_segments = 8'b1011111_0;
       4'h7: o_segments = 8'b1110000_0;
       4'h8: o_segments = 8'b1111111_0;
       4'h9: o_segments = 8'b1111011_0;
       4'hA: o_segments = 8'b1110111_0;
       4'hB: o_segments = 8'b0011111_0;
       4'hC: o_segments = 8'b1001110_0;
       4'hD: o_segments = 8'b0111101_0;
       4'hE: o_segments = 8'b1001111_0;
       4'hF: o_segments = 8'b1000111_0;
   endcase
end

endmodule
