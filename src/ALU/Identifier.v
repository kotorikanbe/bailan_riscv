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