module hex_display #(
    parameter CNT_WIDTH = 14
)(
   input  wire        clk,
   input  wire        rst_n,
   input  wire [15:0] i_data,
   input  wire  [3:0] i_dots,
   output wire  [3:0] o_anodes,
   output wire  [7:0] o_segments
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

wire       dot;
reg  [6:0] segments;

assign dot        = i_dots[pos];
assign o_segments = {segments, dot};
assign o_anodes   = ~(4'b1 << pos);

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
   case (digit)         // ABCDEFG
       4'h0: segments = 8'b1111110;
       4'h1: segments = 8'b0110000;
       4'h2: segments = 8'b1101101;
       4'h3: segments = 8'b1111001;
       4'h4: segments = 8'b0110011;
       4'h5: segments = 8'b1011011;
       4'h6: segments = 8'b1011111;
       4'h7: segments = 8'b1110000;
       4'h8: segments = 8'b1111111;
       4'h9: segments = 8'b1111011;
       4'hA: segments = 8'b1110111;
       4'hB: segments = 8'b0011111;
       4'hC: segments = 8'b1001110;
       4'hD: segments = 8'b0111101;
       4'hE: segments = 8'b1001111;
       4'hF: segments = 8'b1000111;
   endcase
end

endmodule
