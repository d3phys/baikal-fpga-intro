`include "fp16.vh"

module fp16mul
(
    input  wire [`FP16_WIDTH-1:0] i_a,
    input  wire [`FP16_WIDTH-1:0] i_b,
    output wire [`FP16_WIDTH-1:0] o_res
);

// Operands:
wire                            a_sign,     b_sign;
wire [`FP16_EXPONENT_WIDTH-1:0] a_exponent, b_exponent;
wire [`FP16_MANTISSA_WIDTH-1:0] a_mantissa, b_mantissa;
wire [`FP16_TYPE_WIDTH-1:0]     a_type,     b_type;

// Result:
wire                            res_sign;
wire [`FP16_EXPONENT_WIDTH-1:0] res_exponent;
wire [`FP16_MANTISSA_WIDTH-1:0] res_mantissa;
reg  [`FP16_TYPE_WIDTH-1:0]     res_type;

// Calculate sign of the result:
assign res_sign = a_sign ^ b_sign;

// Calculate mantissa of the result:
wire                            normalize;
wire [`FP16_MANTISSA_WIDTH-1:0] significant_bits;
wire [`FP16_MANTISSA_WIDTH-2:0] guard_bits;

assign {normalize, significant_bits, guard_bits} = a_mantissa * b_mantissa;

// Round Toward Zero -- simply drop guard bits
assign res_mantissa = normalize ? {1'b1, significant_bits[`FP16_MANTISSA_WIDTH-1:1]} 
                                : significant_bits;

// Calculate Exponent of the result:
// Use two "guard bits" to handle overflow and underflow
wire  underflow;
wire   overflow;

assign {underflow, overflow, res_exponent} = a_exponent + b_exponent - `FP16_EXPONENT_BIAS + normalize;

// Calculate type of the result:
reg [`FP16_TYPE_WIDTH-1:0] calc_type;
always @(*) begin
    if ( overflow ) begin
        calc_type = `FP16_INF;
    end else if ( underflow ) begin
        calc_type = `FP16_ZERO;
    end else if ( res_exponent == 0 ) begin
        calc_type = `FP16_SUBN;
    end else begin
        calc_type = `FP16_NORM;
    end
end

always @(*) begin
    case ( {a_type, b_type} )
        // Combinations give special value NaN
        {`FP16_NAN,  `FP16_NAN  }: res_type = `FP16_NAN;
        {`FP16_NAN,  `FP16_ZERO }: res_type = `FP16_NAN;
        {`FP16_NAN,  `FP16_INF  }: res_type = `FP16_NAN;
        {`FP16_NAN,  `FP16_NORM }: res_type = `FP16_NAN;
        {`FP16_ZERO, `FP16_NAN  }: res_type = `FP16_NAN;
        {`FP16_INF,  `FP16_NAN  }: res_type = `FP16_NAN;
        {`FP16_NORM, `FP16_NAN  }: res_type = `FP16_NAN;
        {`FP16_INF,  `FP16_ZERO }: res_type = `FP16_NAN;
        {`FP16_ZERO, `FP16_INF  }: res_type = `FP16_NAN;

        // Combinations give special value Inf 
        {`FP16_INF,  `FP16_INF  }: res_type = `FP16_INF;
        {`FP16_INF,  `FP16_NORM }: res_type = `FP16_INF;
        {`FP16_NORM, `FP16_INF  }: res_type = `FP16_INF;

        // Combinations give special value Zero
        {`FP16_ZERO, `FP16_ZERO }: res_type = `FP16_ZERO;
        {`FP16_ZERO, `FP16_NORM }: res_type = `FP16_ZERO;
        {`FP16_NORM, `FP16_ZERO }: res_type = `FP16_ZERO;

        // Select deduced type
        {`FP16_NORM, `FP16_NORM }: res_type = calc_type;

        default:                   res_type = {`FP16_TYPE_WIDTH{1'b1}};
    endcase
end

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

