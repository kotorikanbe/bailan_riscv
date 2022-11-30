`timescale 1ns/1ns
module  Thirty_two_bit_adder_tb
    (

    );
        wire [31:0]    answer;
        reg [31:0]     operator_1;
        reg [31:0]     operator_2;
        reg            operator_3;
    initial begin
        operator_1 = 32'b00110100111110110101111000111000;
        operator_2 = 32'b01000010001110100011010111000111;
        operator_3 = 1'b0;
    end
Thirty_two_bit_adder u_thirty_two_bit_adder
    (
        .operator_1    (operator_1),
        .operator_2    (operator_2),
        .operator_3    (operator_3),
        .answer        (answer)
    );
endmodule        