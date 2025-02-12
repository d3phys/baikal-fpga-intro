`timescale 1ns/1ps

`define SILENT

`ifndef N
`define N 2
`endif

`ifndef M
`define M 4
`endif

module signext_tb;

localparam N = `N;
localparam M = `M;

logic [N-1:0] val;
logic [M-1:0] ext;

signext #(
    .N(N),
    .M(M)
) signext_inst (
    .i_val(val),
    .o_val(ext)
);

always begin
    #1;

    if (ext == {{M-N{val[N-1]}}, val}) begin
`ifndef SILENT
        $display("[%0t] val=%b ext=%b OK", $realtime, val, ext);
`endif
    end else begin
        $display("[%0t] val=%b ext=%b FAIL", $realtime, val, ext);
        $finish;
    end
end

initial val = 0;
always begin
    #1 val = val + 1;
    if (val == 0) begin
      $display("[%0t] All Tests Passed", $realtime);
      $finish;
    end
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

endmodule
