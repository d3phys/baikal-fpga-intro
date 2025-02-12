/*
 * Sign extension module
 */
module signext #(
    parameter N = 2,
    parameter M = 5
)(
    input  logic [N-1:0] i_val,
    output logic [M-1:0] o_val
);

assign o_val = {{M-N{i_val[N-1]}}, i_val};

endmodule
