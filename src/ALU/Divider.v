module  Divider 
    (
        input [31:0]          dividend,
        input [31:0]          divisor,
        input                 clk,
        output reg [31:0]     quotient = 32'b0,
        output reg [31:0]     remainder = 32'b0
    );  
        wire                  flag;
        reg [5:0]             count = 6'b000000;
        reg [63:0]            real_operator_1;
        reg [63:0]            real_operator_2;
        reg [31:0]            dividend_r = 32'b0;
        reg [31:0]            divisor_r = 32'b0;
        assign                flag = (dividend ^ dividend_r) || (divisor ^ divisor_r);
        always @(posedge clk) begin
            dividend_r <= dividend;
            divisor_r <= divisor;
            if(flag) begin
                real_operator_1 <= {32'b0 , dividend};
                real_operator_2 <= {divisor , 32'b0};
                count <= 6'b0;
            end
            else if(count < 6'b100000) begin
                count <= count + 1'b1;
            end
        end
        always @(negedge clk) begin
            if(count < 6'b100000) begin
                real_operator_1 <= {real_operator_1 [62:0] , 1'b0};
            end
        end
        always @(posedge clk ) begin
            if((!flag) && (real_operator_1 > real_operator_2)) begin
                real_operator_1 <= real_operator_1 - real_operator_2 + 1;
            end
        end
        always @(posedge clk) begin
            if(count == 6'b100000) begin
                quotient <=  real_operator_1 [31:0];
                remainder <= real_operator_1 [63:32];
            end
        end

endmodule //Divider