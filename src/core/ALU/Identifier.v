//此模块用于选择模块，为16进制乘法器所需的单元
`timescale 1ns/1ns
module  Identifier 
    (
        input [31:0]         operator,
        input                flag,
        output reg [31:0]    answer
    );
        always @(*) begin
            if(flag) begin
                answer = operator;
            end
            else begin
                answer = 32'b0;
            end
        end
endmodule //identifier