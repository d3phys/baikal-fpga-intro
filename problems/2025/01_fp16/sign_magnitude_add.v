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

wire            sign;
reg [WIDTH-1:0] magnitude;
reg             overflow;

wire           lhs_sign,      rhs_sign;
wire [WIDTH:0] lhs_magnitude, rhs_magnitude;

wire swap = i_lhs_magnitude < i_rhs_magnitude;

// Swap if needed (with one guard bit for overflow)
assign {lhs_sign, lhs_magnitude} = swap ? {i_rhs_sign, {1'b0, i_rhs_magnitude}}
                                        : {i_lhs_sign, {1'b0, i_lhs_magnitude}};
assign {rhs_sign, rhs_magnitude} = swap ? {i_lhs_sign, {1'b0, i_lhs_magnitude}}
                                        : {i_rhs_sign, {1'b0, i_rhs_magnitude}};

assign sign = lhs_sign;

always @(*) begin
    if (lhs_sign == rhs_sign) begin
        {overflow, magnitude} = lhs_magnitude + rhs_magnitude;
    end else begin
        {overflow, magnitude} = lhs_magnitude - rhs_magnitude;
    end
end

assign o_sign      = sign;
assign o_magnitude = magnitude;
assign o_overflow  = overflow;

endmodule
