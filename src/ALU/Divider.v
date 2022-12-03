//此为32位除法器，采用移位法计算，需要32个时钟周期
`timescale 1ns/1ns
module  Divider 
    (
        input [31:0]          dividend,//被除数
        input [31:0]          divisor,//除数
        input                 clk,//时钟
        output reg [31:0]     quotient = 32'b0,//商
        output reg [31:0]     remainder = 32'b0//余数
    );  
        wire                  flag;//此信号用于判断是否输入新数字从而清零
        wire [63:0]           real_operator_3;
        reg [5:0]             count = 6'b000000;//此信号用于计算32次移位
        reg [63:0]            real_operator_1;//移位法原理为被除数扩展一倍高位置0，除数扩展一倍低位置0，此即为扩展后的数
        reg [63:0]            real_operator_2;
        reg [31:0]            dividend_r = 32'b0;//此寄存器用于统一在时钟上升沿接受数据，置0是防止初次输入数据时由于flag没有跳变导致不能输出的情况
        reg [31:0]            divisor_r = 32'b0;
        assign                flag = (dividend ^ dividend_r) || (divisor ^ divisor_r);//判断输入信号是否改变，如为1则将开始下一次除法运算
        assign                real_operator_3 = real_operator_1 - real_operator_2 + 1;
        always @(posedge clk) begin//在上升沿接受输入信号，且若flag有效进行拓展，count固定加一
            dividend_r <= dividend;
            divisor_r <= divisor;
            if(flag) begin
                real_operator_1 <= {32'b0 , dividend};
                real_operator_2 <= {divisor , 32'b0};
                count <= 6'b0;
            end
            else begin
                if(count < 6'b100001) begin
                    count <= count + 1'b1;
                    if(count == 6'b100000) begin
                        if(real_operator_1 > real_operator_2) begin
                        real_operator_1 <= real_operator_3;
                    end
                    else begin
                        real_operator_1 <= real_operator_1;
                    end
                    end
                    else begin
                        if(real_operator_1 > real_operator_2) begin
                            real_operator_1 <= {real_operator_3[62:0] , 1'b0};
                        end
                        else begin
                            real_operator_1 <= {real_operator_1 [62:0] , 1'b0};
                        end
                    end
                    
                end
                
            end
        end
        /*always @(negedge clk) begin//下降沿进行移位操作
            if(count < 6'b100000) begin
                real_operator_1 <= {real_operator_1 [62:0] , 1'b0};
            end
        end*/
        /*always @(posedge clk ) begin//同时上升沿时对比，逻辑为若r1>r2则r1=r1-r2+1
            if((!flag) && (real_operator_1 > real_operator_2)) begin
                real_operator_1 <= real_operator_1 - real_operator_2 + 1;
            end
        end*/
        always @(posedge clk) begin//32个跳变沿之后输出，高位为余数，低位为商
            if(count == 6'b100001) begin
                quotient <=  real_operator_1 [31:0];
                remainder <= real_operator_1 [63:32];
            end
        end
endmodule //Divider