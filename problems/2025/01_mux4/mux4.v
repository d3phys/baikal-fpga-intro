module mux4 #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] i_val0,
                            i_val1,
                            i_val2,
                            i_val3,

    input  wire [1:0]       i_sel,

    output reg  [WIDTH-1:0] o_val
);

always @(*) begin
    case (i_sel)
        2'b00: o_val = i_val0;
        2'b01: o_val = i_val1;
        2'b10: o_val = i_val2;
        2'b11: o_val = i_val3;
    endcase
end

endmodule
