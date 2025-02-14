`timescale 1ns/1ps

module mux4_tb;

localparam WIDTH = 8;

reg  [1:0]       sel;

reg  [WIDTH-1:0] val0,
                 val1,
                 val2,
                 val3;

wire [WIDTH-1:0] val;

initial begin
    val0 = 0;
    val1 = 1;
    val2 = 2;
    val3 = 3;
end

initial sel = 0;
always begin
    #2 sel = sel + 1;
    if (sel == 0) begin
      $display("[%0t] All Tests Passed", $realtime);
      $finish;
    end
end

reg test;
always @(*) begin
    case (sel)
        2'b00: test = (val == val0);
        2'b01: test = (val == val1);
        2'b10: test = (val == val2);
        2'b11: test = (val == val3);
    endcase
end

always begin
    #1;

    if (test) begin
        $display("[%0t] sel=%b OK", $realtime, sel);
    end else begin
        $display("[%0t] sel=%b FAIL", $realtime, sel);
        $finish;
    end

    #1;
end

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
end

mux4 #(
    .WIDTH(WIDTH)
) mux4_inst (
    .i_val0 (val0),
    .i_val1 (val1),
    .i_val2 (val2),
    .i_val3 (val3),
    .i_sel  (sel),
    .o_val  (val)
);

endmodule

