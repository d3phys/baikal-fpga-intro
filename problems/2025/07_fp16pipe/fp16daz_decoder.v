`include "fp16.vh"

module fp16daz_decoder
(
    input  wire [`FP16_WIDTH-1:0]          i_encoded,

    output wire                            o_sign,
    output wire [`FP16_EXPONENT_WIDTH-1:0] o_exponent,
    output wire [`FP16_MANTISSA_WIDTH-1:0] o_mantissa,
    output reg  [`FP16_TYPE_WIDTH-1:0]     o_type
);

// IEEE-754
wire                                     sign;
wire          [`FP16_EXPONENT_WIDTH-1:0] exponent;
wire          [`FP16_FRACTION_WIDTH-1:0] fraction;

assign {sign, exponent, fraction} = i_encoded;

always @(*) begin
    if ( exponent == {`FP16_EXPONENT_WIDTH{1'b1}} ) begin
        if ( fraction == 0 ) begin
            o_type = `FP16_INF;
        end else begin
            o_type = `FP16_NAN;
        end
    end else if ( exponent == 0 ) begin
        if ( fraction == 0 ) begin
            o_type = `FP16_ZERO;
        end else begin
            // Denormal as Zero:
            o_type = `FP16_ZERO;
        end
    end else begin
        o_type = `FP16_NORM;
    end
end

// Extract fields for Normal numbers:
assign o_sign     = sign;
assign o_exponent = exponent;
assign o_mantissa = {1'b1, fraction};

endmodule
