`timescale 1ns/1ns
module  Sixteen_bit_multiplier 
    (
        input [15:0]      operator_1,
        input [15:0]      operator_2,
        output [31:0]     answer
    );
        wire [31:0]       real_operator;
        wire [31:0]       stored_operator [15:0];
        wire [31:0]       identified_stored_operator [15:0];
        wire [31:0]       operated_operator [14:0];
        wire [14:0]       C;
        assign            real_operator = {16'h0000 , operator_1};
        assign            answer = operated_operator[14];
        genvar            i;
        generate
            for (i = 0;i < 16;i = i + 1) begin
                Left_logic_shifter u_left_logic_shifter
                    (
                        .operator_1    (real_operator),
                        .operator_2    (i),
                        .answer        (stored_operator[i][31:0])
                    );
            end
        endgenerate
        Thirty_two_bit_adder u_thirty_two_bit_adder0
            (
                .operator_1    (identified_stored_operator[0][31:0]),
                .operator_2    (identified_stored_operator[1][31:0]),
                .operator_3    (1'b0),
                .C             (C[0]),
                .answer        (operated_operator[0][31:0])
            );
        genvar            j;
        generate
            for (j = 2;j < 16;j = j + 1) begin
                Thirty_two_bit_adder u_thirty_two_bit_adder
                    (
                        .operator_1    (identified_stored_operator[j][31:0]),
                        .operator_2    (operated_operator[j-2][31:0]),
                        .operator_3    (1'b0),
                        .C             (C[j-1]),
                        .answer        (operated_operator[j-1][31:0])
                    );
            end
        endgenerate
        genvar            k;
        generate
            for (k = 0;k < 16;k = k + 1) begin
                Identifier u_identifier
                    (
                        .operator    (stored_operator[k][31:0]),
                        .flag        (operator_2[k]),
                        .answer      (identified_stored_operator[k][31:0])
                    );
            end
        endgenerate
endmodule //Sixteen_bit_multiplier