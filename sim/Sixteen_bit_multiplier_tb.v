`timescale 1ns/1ns
module Sixteen_bit_multiplier_tb 
(
    
);
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] c;
    initial begin
        while(1)begin
            #100
            a=$random;
            b=$random;
        end
    end
    Sixteen_bit_multiplier u_sixteen_bit_multiplier
        (
            .operator_1    (a),
            .operator_2    (b),
            .answer        (c)
        );
endmodule //Sixteen_bit_multiplier_tb
