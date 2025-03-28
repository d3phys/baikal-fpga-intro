//
// Load/Store unit
//
module lsu(
    // Core interface:
    input  wire [31:0] i_addr,
    input  wire [31:0] i_data,
    input  wire        i_we,
    input  wire  [1:0] i_size,
    input  wire        i_sign_ext,
    output reg  [31:0] o_data,

    // Memory interface:
    output wire [29:0] o_mem_addr,
    output wire [31:0] o_mem_data,
    output wire        o_mem_we,
    output reg   [3:0] o_mem_mask,
    input  wire [31:0] i_mem_data
);

assign o_mem_addr = i_addr[31:2];
assign o_mem_data = i_data;
assign o_mem_we   = i_we;

always @(*) begin
    case (i_size)
        2'b00:   o_data = i_sign_ext ? {{24{i_mem_data[07]}}, i_mem_data[07:0]}
                                     : {{24{          1'b0}}, i_mem_data[07:0]};

        2'b01:   o_data = i_sign_ext ? {{16{i_mem_data[15]}}, i_mem_data[15:0]}
                                     : {{16{          1'b0}}, i_mem_data[15:0]};

        2'b10:   o_data = i_sign_ext ? {{08{i_mem_data[23]}}, i_mem_data[23:0]}
                                     : {{08{          1'b0}}, i_mem_data[23:0]};

        default: o_data = {32{1'bx}};
    endcase
end

always @(*) begin
    case (i_size)
        2'b00:   o_mem_mask = 4'b0001;
        2'b01:   o_mem_mask = 4'b0011;
        2'b10:   o_mem_mask = 4'b1111;
        default: o_mem_mask = 4'bxxxx;
    endcase
end

endmodule

