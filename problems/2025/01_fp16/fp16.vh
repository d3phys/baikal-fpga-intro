`ifndef FP16_VH
`define FP16_VH

`define FP16_TYPE_WIDTH               3

`define FP16_INF    `FP16_TYPE_WIDTH'h0
`define FP16_NORM   `FP16_TYPE_WIDTH'h1
`define FP16_SUBN   `FP16_TYPE_WIDTH'h2
`define FP16_ZERO   `FP16_TYPE_WIDTH'h3
`define FP16_NAN    `FP16_TYPE_WIDTH'h4

`define FP16_WIDTH          16
`define FP16_EXPONENT_WIDTH  5
`define FP16_FRACTION_WIDTH 10
`define FP16_MANTISSA_WIDTH 11

`define FP16_EXPONENT_BIAS  15

`endif // FP16_VH

