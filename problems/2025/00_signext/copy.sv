module copy #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] i_val,
    output logic [WIDTH-1:0] o_val
);

assign o_val = i_val;

endmodule
