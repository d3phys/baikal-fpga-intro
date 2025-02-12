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

// Copy value
copy #(
    .WIDTH(N)
) copy_inst (
    .i_val(i_val),
    .o_val(o_val[N-1:0])
);

// Copy sign bit
generate
    genvar i;
    for (i = N; i < M; i = i + 1) begin : gen_sign
        copy #(
            .WIDTH(1)
        ) copy_inst (
            .i_val(i_val[N-1]),
            .o_val(o_val[i])
        );
    end
endgenerate

endmodule

