`timescale 1ns/1ns
module  Thirty_two_bit_adder_tb
    (

    );
        wire [31:0]    answer;
        wire           C;
        reg [31:0]     operator_1;
        reg [31:0]     operator_2;
        reg            operator_3;
    initial begin
        while (1) begin
            #10
            operator_1 = $random;
            operator_2 = $random;
            operator_3 = $random;
        end
    end
Thirty_two_bit_adder u_thirty_two_bit_adder
    (
        .operator_1    (operator_1),
        .operator_2    (operator_2),
        .operator_3    (operator_3),
        .C             (C),
        .answer        (answer)
    );
endmodule        