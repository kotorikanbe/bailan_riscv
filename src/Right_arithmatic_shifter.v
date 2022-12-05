//算术右移器，高位补符号位
`timescale 1ns/1ns
module  Right_arithmatic_shifter 
    (
        input [31:0]         operator_1,
        input [4:0]          operator_2,
        output reg [31:0]    answer
    );
        always @(*) begin
            if(operator_1[31])begin
                case (operator_2)
                    5'b00000: answer = {operator_1};
                    5'b00001: answer = {1'b1 , operator_1[31:1]};
                    5'b00010: answer = {2'b11 , operator_1[31:2]};
                    5'b00011: answer = {3'b111 , operator_1[31:3]};
                    5'b00100: answer = {4'b1111 , operator_1[31:4]};
                    5'b00101: answer = {5'b11111 , operator_1[31:5]};
                    5'b00110: answer = {6'b111111 , operator_1[31:6]};
                    5'b00111: answer = {7'b1111111 , operator_1[31:7]};
                    5'b01000: answer = {8'hff , operator_1[31:8]};
                    5'b01001: answer = {9'o777 , operator_1[31:9]};
                    5'b01010: answer = {10'b1111111111 , operator_1[31:10]};
                    5'b01011: answer = {11'b11111111111 , operator_1[31:11]};
                    5'b01100: answer = {12'hfff , operator_1[31:12]};
                    5'b01101: answer = {12'hfff , 1'b1 , operator_1[31:13]};
                    5'b01110: answer = {12'hfff , 2'b11 , operator_1[31:14]};
                    5'b01111: answer = {15'o77777 , operator_1[31:15]};
                    5'b10000: answer = {16'hffff , operator_1[31:16]};
                    5'b10001: answer = {16'hffff , 1'b1 , operator_1[31:17]};
                    5'b10010: answer = {16'hffff , 2'b11 , operator_1[31:18]};
                    5'b10011: answer = {16'hffff , 3'o7 , operator_1[31:19]};
                    5'b10100: answer = {20'hfffff , operator_1[31:20]};
                    5'b10101: answer = {20'hfffff , 1'b1 , operator_1[31:21]};
                    5'b10110: answer = {20'hfffff , 2'b11 , operator_1[31:22]};
                    5'b10111: answer = {20'hfffff , 3'o7 , operator_1[31:23]};
                    5'b11000: answer = {24'hffffff , operator_1[31:24]};
                    5'b11001: answer = {24'hffffff , 1'b1 , operator_1[31:25]};
                    5'b11010: answer = {24'hffffff , 2'b11 , operator_1[31:26]};
                    5'b11011: answer = {27'o777777777 , operator_1[31:27]};
                    5'b11100: answer = {28'hfffffff , operator_1[31:28]};
                    5'b11101: answer = {28'hfffffff , 1'b1 , operator_1[31:29]};
                    5'b11110: answer = {28'hfffffff , 2'b11 , operator_1[31:30]};
                    5'b11111: answer = {28'hfffffff , 3'o7 , operator_1[31]};
                    default:  answer = {operator_1};
                endcase
            end
            else begin
                case (operator_2)
                    5'b00000: answer = {operator_1};
                    5'b00001: answer = {1'b0 , operator_1[31:1]};
                    5'b00010: answer = {2'b0 , operator_1[31:2]};
                    5'b00011: answer = {3'b0 , operator_1[31:3]};
                    5'b00100: answer = {4'b0 , operator_1[31:4]};
                    5'b00101: answer = {5'b0 , operator_1[31:5]};
                    5'b00110: answer = {6'b0 , operator_1[31:6]};
                    5'b00111: answer = {7'b0 , operator_1[31:7]};
                    5'b01000: answer = {8'b0 , operator_1[31:8]};
                    5'b01001: answer = {9'b0 , operator_1[31:9]};
                    5'b01010: answer = {10'b0 , operator_1[31:10]};
                    5'b01011: answer = {11'b0 , operator_1[31:11]};
                    5'b01100: answer = {12'b0 , operator_1[31:12]};
                    5'b01101: answer = {13'b0 , operator_1[31:13]};
                    5'b01110: answer = {14'b0 , operator_1[31:14]};
                    5'b01111: answer = {15'b0 , operator_1[31:15]};
                    5'b10000: answer = {16'b0 , operator_1[31:16]};
                    5'b10001: answer = {17'b0 , operator_1[31:17]};
                    5'b10010: answer = {18'b0 , operator_1[31:18]};
                    5'b10011: answer = {19'b0 , operator_1[31:19]};
                    5'b10100: answer = {20'b0 , operator_1[31:20]};
                    5'b10101: answer = {21'b0 , operator_1[31:21]};
                    5'b10110: answer = {22'b0 , operator_1[31:22]};
                    5'b10111: answer = {23'b0 , operator_1[31:23]};
                    5'b11000: answer = {24'b0 , operator_1[31:24]};
                    5'b11001: answer = {25'b0 , operator_1[31:25]};
                    5'b11010: answer = {26'b0 , operator_1[31:26]};
                    5'b11011: answer = {27'b0 , operator_1[31:27]};
                    5'b11100: answer = {28'b0 , operator_1[31:28]};
                    5'b11101: answer = {29'b0 , operator_1[31:29]};
                    5'b11110: answer = {30'b0 , operator_1[31:30]};
                    5'b11111: answer = {31'b0 , operator_1[31]};
                    default:  answer = {operator_1};
                endcase
            end
        end

endmodule //Right_arithmatic_shifter