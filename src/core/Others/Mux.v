`timescale 1ns/1ns
module Mux
    (
        input [31:0]        data1_i,
        input [31:0]        data2_i,
        input               sel_i,
        output reg [31:0]   dat_o
    );

        always @(*) begin
            case (sel_i)
                0: dat_o = data2_i;
                1: dat_o = data1_i;
                default: dat_o = data2_i;
            endcase
        end

endmodule
