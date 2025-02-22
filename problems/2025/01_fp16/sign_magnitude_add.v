module sign_magnitude_add #(
    parameter WIDTH = 16
)(
    input  wire             i_lhs_sign,
    input  wire [WIDTH-1:0] i_lhs_magnitude,

    input  wire             i_rhs_sign,
    input  wire [WIDTH-1:0] i_rhs_magnitude,

    output wire             o_sign,
    output wire [WIDTH-1:0] o_magnitude,
    output wire             o_overflow
);

reg             sign;
reg [WIDTH-1:0] result;
reg             overflow;

wire [WIDTH+1:0] lhs_magnitude, rhs_magnitude;

// Zero extend operands:
assign lhs_magnitude = {2'b00, i_lhs_magnitude};
assign rhs_magnitude = {2'b00, i_rhs_magnitude};

always @(*) begin
    case ({i_lhs_sign, i_rhs_sign})
        2'b00: {sign, overflow, result} = (+lhs_magnitude) + (+rhs_magnitude);
        2'b01: {sign, overflow, result} = (+lhs_magnitude) + (-rhs_magnitude);
        2'b10: {sign, overflow, result} = (-lhs_magnitude) + (+rhs_magnitude);
        2'b11: {sign, overflow, result} = (-lhs_magnitude) + (-rhs_magnitude);
    endcase
end

assign o_sign      = sign;
assign o_magnitude = sign ? -result : +result;
assign o_overflow  = (overflow && !sign) || (!overflow && sign);

endmodule
