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

// Random data
wire        lfsr_en;
wire [15:0] lfsr_data;

lfsr #(
    .SEED (16'h1)
) lfsr (
    .clk    (CLK       ),
    .rst_n  (rst_n     ),
    .i_en   (lfsr_en   ),
    .o_data (lfsr_data )
);

clkdiv #(
    .F0 (50_000_000),
    .F1 (2 /* Two times per second */)
) lfsr_ctrl (
    .clk   (CLK     ),
    .rst_n (rst_n   ),
    .out   (lfsr_en )        
);

hex_display hex_display(
    .clk        (CLK        ), 
    .rst_n      (rst_n      ), 
    .i_data     (lfsr_data  ), 
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
