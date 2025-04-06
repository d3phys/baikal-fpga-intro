module priority_msb16_encoder
(
    input wire   [15:0] i_data,

    output reg    [3:0] o_enc,
    output wire         o_vld
);

always @(*) begin
    casez (i_data)
        16'b1???????????????: o_enc = 4'd15;
        16'b01??????????????: o_enc = 4'd14;
        16'b001?????????????: o_enc = 4'd13;
        16'b0001????????????: o_enc = 4'd12;
        16'b00001???????????: o_enc = 4'd11;
        16'b000001??????????: o_enc = 4'd10;
        16'b0000001?????????: o_enc = 4'd09;
        16'b00000001????????: o_enc = 4'd08;
        16'b000000001???????: o_enc = 4'd07;
        16'b0000000001??????: o_enc = 4'd06;
        16'b00000000001?????: o_enc = 4'd05;
        16'b000000000001????: o_enc = 4'd04;
        16'b0000000000001???: o_enc = 4'd03;
        16'b00000000000001??: o_enc = 4'd02;
        16'b000000000000001?: o_enc = 4'd01;
        16'b0000000000000001: o_enc = 4'd00;
        default:              o_enc = 4'bxxxx;
    endcase
end

assign o_vld = |i_data;

endmodule
