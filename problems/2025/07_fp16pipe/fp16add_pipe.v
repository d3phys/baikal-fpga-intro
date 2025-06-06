`include "fp16.vh"

module fp16add_pipe
(
    input  wire                   clk,
    input  wire [`FP16_WIDTH-1:0] i_a,
    input  wire [`FP16_WIDTH-1:0] i_b,
    output wire [`FP16_WIDTH-1:0] o_res
);

// Operands:
wire                            a_sign,     b_sign;
wire [`FP16_EXPONENT_WIDTH-1:0] a_exponent, b_exponent;
wire [`FP16_MANTISSA_WIDTH-1:0] a_mantissa, b_mantissa;
wire [`FP16_TYPE_WIDTH-1:0]     a_type,     b_type;

// Left-hand-side and Right-hand-side operands:
wire                            lhs_sign,     rhs_sign;
wire [`FP16_EXPONENT_WIDTH-1:0] lhs_exponent, rhs_exponent;
wire [`FP16_MANTISSA_WIDTH-1:0] lhs_mantissa, rhs_mantissa;
wire [`FP16_TYPE_WIDTH-1:0]     lhs_type,     rhs_type;

wire                            swap;
wire [`FP16_EXPONENT_WIDTH-1:0] diff, abs_diff;

reg                             buf_a_sign,       buf_b_sign;
reg  [`FP16_EXPONENT_WIDTH-1:0] buf_a_exponent,   buf_b_exponent;
reg  [`FP16_MANTISSA_WIDTH-1:0] buf_a_mantissa,   buf_b_mantissa;
reg  [`FP16_TYPE_WIDTH-1:0]     buf_a_type,       buf_b_type;

reg                             buf_lhs_sign,     buf_rhs_sign;
reg  [`FP16_EXPONENT_WIDTH-1:0] buf_lhs_exponent, buf_rhs_exponent;
reg  [`FP16_MANTISSA_WIDTH-1:0] buf_lhs_mantissa, buf_rhs_mantissa;
reg  [`FP16_TYPE_WIDTH-1:0]     buf_lhs_type,     buf_rhs_type;

// Result for normals:
wire                            sign;
wire [`FP16_EXPONENT_WIDTH-1:0] exponent;
wire [`FP16_MANTISSA_WIDTH-1:0] mantissa;
reg  [`FP16_TYPE_WIDTH-1:0]     calc_type;

// Final result:
reg                             res_sign;
wire [`FP16_EXPONENT_WIDTH-1:0] res_exponent;
wire [`FP16_MANTISSA_WIDTH-1:0] res_mantissa;
reg  [`FP16_TYPE_WIDTH-1:0]     res_type;

assign {swap, diff} = a_exponent - b_exponent;

// Find the absolute exponents difference
assign abs_diff = swap ? -diff : diff;

// Swap significands if needed
assign {lhs_sign, lhs_exponent, lhs_mantissa} = swap ? {b_sign, b_exponent, b_mantissa}
                                                     : {a_sign, a_exponent, a_mantissa};
assign {rhs_sign, rhs_exponent, rhs_mantissa} = swap ? {a_sign, a_exponent, a_mantissa}
                                                     : {b_sign, b_exponent, b_mantissa};

// Align mantissas (use one guard bit for magnitudes)
wire [`FP16_MANTISSA_WIDTH:0] lhs_magnitude, rhs_magnitude;
assign lhs_magnitude = {lhs_mantissa, 1'b0};
assign rhs_magnitude = {rhs_mantissa, 1'b0} >> abs_diff;

// Sign-magnitude addition result
wire [`FP16_MANTISSA_WIDTH:0] add_magnitude;
wire                          add_overflow;
wire                          add_sign;

// Sign-magnitude addition result (Stage 2)
reg  [`FP16_MANTISSA_WIDTH:0] buf_add_magnitude;
reg                           buf_add_overflow;
reg                           buf_add_sign;      

sign_magnitude_add #(
    .WIDTH(`FP16_MANTISSA_WIDTH + 1 /* Guard bit */)
) add_mantissas (
    .i_lhs_sign        (lhs_sign),
    .i_lhs_magnitude   (lhs_magnitude),

    .i_rhs_sign        (rhs_sign),
    .i_rhs_magnitude   (rhs_magnitude),

    .o_sign            (add_sign),
    .o_magnitude       (add_magnitude),
    .o_overflow        (add_overflow)
);

always @(posedge clk) begin
    buf_a_sign        <= a_sign;
    buf_a_exponent    <= a_exponent;
    buf_a_mantissa    <= a_mantissa;
    buf_a_type        <= a_type;

    buf_b_sign        <= b_sign;
    buf_b_exponent    <= b_exponent;
    buf_b_mantissa    <= b_mantissa;
    buf_b_type        <= b_type;

    buf_rhs_sign      <= rhs_sign;
    buf_rhs_exponent  <= rhs_exponent;
    buf_rhs_mantissa  <= rhs_mantissa;
    buf_rhs_type      <= rhs_type;

    buf_lhs_sign      <= lhs_sign;
    buf_lhs_exponent  <= lhs_exponent;
    buf_lhs_mantissa  <= lhs_mantissa;
    buf_lhs_type      <= lhs_type;

    buf_add_magnitude <= add_magnitude;
    buf_add_overflow  <= add_overflow;
    buf_add_sign      <= add_sign;     
end

wire        enc_vld;
wire  [3:0] enc_position;
wire [15:0] enc_data;

assign enc_data = {{4{1'b0}}, buf_add_magnitude};

priority_msb16_encoder position_encoder
(
    .i_data (enc_data),
    .o_enc  (enc_position),
    .o_vld  (enc_vld)
);

wire [3:0] shift;
assign shift = 16'd11 - enc_position;

wire [`FP16_MANTISSA_WIDTH:0] shift_magnitude;
assign shift_magnitude = buf_add_magnitude << shift;

// Round Toward Zero -- simply drop guard bits
assign mantissa = buf_add_overflow ? {1'b1, buf_add_magnitude[`FP16_MANTISSA_WIDTH:2]}
                                   : shift_magnitude[`FP16_MANTISSA_WIDTH:1];

// Is zero?
wire zero = (buf_add_magnitude == 0 && !buf_add_overflow);

// Calculate Exponent of the result:
// Use two "guard bits" to handle overflow and underflow
wire  underflow;
wire   overflow;

assign {underflow, overflow, exponent} = buf_add_overflow ? buf_lhs_exponent + 1'b1
                                                          : buf_lhs_exponent - shift;

// Simply copy sign
assign sign = buf_add_sign;

// Calculate type of the result:
always @(*) begin
    if ( zero || underflow ) begin
        calc_type = `FP16_ZERO;
    end else if ( overflow ) begin
        calc_type = `FP16_INF;
    end else if ( res_exponent == 0 ) begin
        calc_type = `FP16_SUBN;
    end else begin
        calc_type = `FP16_NORM;
    end
end

always @(*) begin
    case ( {buf_a_type, buf_b_type} )
        {`FP16_NAN,  `FP16_NAN  }: {res_sign, res_type} = {      1'b0, `FP16_NAN};
        {`FP16_NAN,  `FP16_ZERO }: {res_sign, res_type} = {      1'b0, `FP16_NAN};
        {`FP16_NAN,  `FP16_INF  }: {res_sign, res_type} = {      1'b0, `FP16_NAN};
        {`FP16_NAN,  `FP16_NORM }: {res_sign, res_type} = {      1'b0, `FP16_NAN};
        {`FP16_ZERO, `FP16_NAN  }: {res_sign, res_type} = {      1'b0, `FP16_NAN};
        {`FP16_INF,  `FP16_NAN  }: {res_sign, res_type} = {      1'b0, `FP16_NAN};
        {`FP16_NORM, `FP16_NAN  }: {res_sign, res_type} = {      1'b0, `FP16_NAN};

        {`FP16_INF,  `FP16_ZERO }: {res_sign, res_type} = {buf_a_sign, `FP16_INF};
        {`FP16_ZERO, `FP16_INF  }: {res_sign, res_type} = {buf_b_sign, `FP16_INF};
        {`FP16_INF,  `FP16_NORM }: {res_sign, res_type} = {buf_a_sign, `FP16_INF};
        {`FP16_NORM, `FP16_INF  }: {res_sign, res_type} = {buf_b_sign, `FP16_INF};

        {`FP16_INF,  `FP16_INF  }: {res_sign, res_type} = (buf_a_sign == buf_b_sign)
                                                        ? {buf_a_sign, `FP16_INF}
                                                        : {      1'b0, `FP16_NAN};

        {`FP16_ZERO, `FP16_ZERO }: {res_sign, res_type} = {      1'b0, `FP16_ZERO};

        // Corner case here...
        {`FP16_NORM, `FP16_ZERO }: {res_sign, res_type} = {buf_a_sign, `FP16_NORM};
        {`FP16_ZERO, `FP16_NORM }: {res_sign, res_type} = {buf_b_sign, `FP16_NORM};

        // Select deduced type
        {`FP16_NORM, `FP16_NORM }: {res_sign, res_type} = {sign, calc_type};

        default:                   {res_sign, res_type} = {1'b1, {`FP16_TYPE_WIDTH{1'b1}}};
    endcase
end

// Handle corner case:
assign {res_mantissa, res_exponent} =
    ({a_type, b_type} == {`FP16_NORM, `FP16_ZERO}) ? {buf_a_mantissa, buf_a_exponent} :
    ({a_type, b_type} == {`FP16_ZERO, `FP16_NORM}) ? {buf_b_mantissa, buf_b_exponent} :
                                                     {      mantissa,       exponent};

fp16daz_decoder a_decoder (
    .i_encoded  (i_a),
    .o_sign     (a_sign),
    .o_exponent (a_exponent),
    .o_mantissa (a_mantissa),
    .o_type     (a_type)
);

fp16daz_decoder b_decoder (
    .i_encoded  (i_b),
    .o_sign     (b_sign),
    .o_exponent (b_exponent),
    .o_mantissa (b_mantissa),
    .o_type     (b_type)
);

fp16ftz_encoder res_encoder (
    .i_sign     (res_sign),
    .i_exponent (res_exponent),
    .i_mantissa (res_mantissa),
    .i_type     (res_type),
    .o_encoded  (o_res)
);

endmodule

