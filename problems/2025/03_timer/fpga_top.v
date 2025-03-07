module fpga_top(
    input  wire CLK,   // CLOCK
    input  wire RSTN,  // BUTTON RST (NEGATIVE)
    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

reg rst_n, RSTN_d;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

wire  [3:0] anodes;
wire  [7:0] segments;

wire cnt_en;
wire clk_en;

wire digit3_carry;
wire digit2_carry;
wire digit1_carry;
wire digit0_carry;

wire [3:0] digit3;
wire [3:0] digit2; 
wire [3:0] digit1; 
wire [3:0] digit0;

wire [15:0] data;
assign data = {digit3, digit2, digit1, digit0};

assign cnt_en = clk_en && (data != 15'b0);

down_counter #(
    .START (4'd0)
) digit0_cnt (
    .clk     (CLK                   ),
    .rst_n   (rst_n                 ),
    .i_en    (cnt_en                ),
    .o_data  (digit0                ),
    .o_carry (digit0_carry          )
);

down_counter #(
    .START (4'd0)
) digit1_cnt (
    .clk     (CLK                   ),
    .rst_n   (rst_n                 ),
    .i_en    (cnt_en & digit0_carry ),
    .o_data  (digit1                ),
    .o_carry (digit1_carry          )
);

down_counter #(
    .START (4'd6)
) digit2_cnt (
    .clk     (CLK                   ),
    .rst_n   (rst_n                 ),
    .i_en    (cnt_en & digit1_carry ),
    .o_data  (digit2                ),
    .o_carry (digit2_carry          )
);

down_counter #(
    .START (4'd0)
) digit3_cnt (
    .clk     (CLK                   ),
    .rst_n   (rst_n                 ),
    .i_en    (cnt_en & digit2_carry ),
    .o_data  (digit3                ),
    .o_carry (digit3_carry          )
);

clkdiv #(
    .F0 (50_000_000),
    .F1 (10 /* 1/10 second */)
) cnt_ctrl (
    .clk   (CLK     ),
    .rst_n (rst_n   ),
    .out   (clk_en  )        
);

hex_display hex_display(
    .clk        (CLK        ), 
    .rst_n      (rst_n      ), 
    .i_data     (data       ), 
	 .i_dots		 (4'b0010    ),
    .o_anodes   (anodes     ), 
    .o_segments (segments   )
);

ctrl_74hc595 ctrl(
    .clk    (CLK                ),
    .rst_n  (rst_n              ),
    .i_data ({segments, anodes} ),
    .o_stcp (STCP               ),
    .o_shcp (SHCP               ),
    .o_ds   (DS                 ),
    .o_oe   (OE                 )
);

endmodule
