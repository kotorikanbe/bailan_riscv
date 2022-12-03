`timescale 1ns/1ns
module  Left_logic_shifter 
    (
        input [31:0]         operator_1,
        input [4:0]          operator_2,//unsigned
        output reg [31:0]    answer
    );
        always @(*) begin
            case (operator_2)
                5'b00000: answer = {operator_1};
                5'b00001: answer = {operator_1[30:0] , 1'b0};
                5'b00010: answer = {operator_1[29:0] , 2'b0};
                5'b00011: answer = {operator_1[28:0] , 3'b0};
                5'b00100: answer = {operator_1[27:0] , 4'b0};
                5'b00101: answer = {operator_1[26:0] , 5'b0};
                5'b00110: answer = {operator_1[25:0] , 6'b0};
                5'b00111: answer = {operator_1[24:0] , 7'b0};
                5'b01000: answer = {operator_1[23:0] , 8'b0};
                5'b01001: answer = {operator_1[22:0] , 9'b0};
                5'b01010: answer = {operator_1[21:0] , 10'b0};
                5'b01011: answer = {operator_1[20:0] , 11'b0};
                5'b01100: answer = {operator_1[19:0] , 12'b0};
                5'b01101: answer = {operator_1[18:0] , 13'b0};
                5'b01110: answer = {operator_1[17:0] , 14'b0};
                5'b01111: answer = {operator_1[16:0] , 15'b0};
                5'b10000: answer = {operator_1[15:0] , 16'b0};
                5'b10001: answer = {operator_1[14:0] , 17'b0};
                5'b10010: answer = {operator_1[13:0] , 18'b0};
                5'b10011: answer = {operator_1[12:0] , 19'b0};
                5'b10100: answer = {operator_1[11:0] , 20'b0};
                5'b10101: answer = {operator_1[10:0] , 21'b0};
                5'b10110: answer = {operator_1[9:0] , 22'b0};
                5'b10111: answer = {operator_1[8:0] , 23'b0};
                5'b11000: answer = {operator_1[7:0] , 24'b0};
                5'b11001: answer = {operator_1[6:0] , 25'b0};
                5'b11010: answer = {operator_1[5:0] , 26'b0};
                5'b11011: answer = {operator_1[4:0] , 27'b0};
                5'b11100: answer = {operator_1[3:0] , 28'b0};
                5'b11101: answer = {operator_1[2:0] , 29'b0};
                5'b11110: answer = {operator_1[1:0] , 30'b0};
                5'b11111: answer = {operator_1[0] , 31'b0};
                default:  answer = {operator_1};
            endcase
        end
endmodule //Left_shifter