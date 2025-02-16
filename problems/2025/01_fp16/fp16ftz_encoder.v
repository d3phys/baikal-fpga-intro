`include "fp16.vh"

module fp16ftz_encoder
(
    input  wire                            i_sign,
    input  wire [`FP16_EXPONENT_WIDTH-1:0] i_exponent,
    input  wire [`FP16_MANTISSA_WIDTH-1:0] i_mantissa,
    input  wire     [`FP16_TYPE_WIDTH-1:0] i_type,

    output reg           [`FP16_WIDTH-1:0] o_encoded
);

// IEEE-754
wire                                     sign;
wire          [`FP16_EXPONENT_WIDTH-1:0] exponent;
wire          [`FP16_FRACTION_WIDTH-1:0] fraction;

always @(*) begin
    case ( i_type )
        `FP16_INF:  o_encoded = {sign, {`FP16_EXPONENT_WIDTH{1'b1}}, {`FP16_FRACTION_WIDTH{1'b0}}};
        `FP16_NAN:  o_encoded = {sign, {`FP16_EXPONENT_WIDTH{1'b1}}, {`FP16_FRACTION_WIDTH{1'b1}}};
        `FP16_ZERO: o_encoded = {sign, {`FP16_EXPONENT_WIDTH{1'b0}}, {`FP16_FRACTION_WIDTH{1'b0}}};
        // Flush to Zero encoding:
        `FP16_SUBN: o_encoded = {sign, {`FP16_EXPONENT_WIDTH{1'b0}}, {`FP16_FRACTION_WIDTH{1'b0}}};
        `FP16_NORM: o_encoded = {sign, exponent, fraction};
        default:    o_encoded = {`FP16_WIDTH{1'bx}};
    endcase
end

// Encode Normal numbers:
assign sign     = i_sign;
assign exponent = i_exponent;
assign fraction = i_mantissa[`FP16_FRACTION_WIDTH-1:0];

endmodule
