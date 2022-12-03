//32位乘法器，采用状态机的形式，利用4个时钟周期，完成4次运算，从而使用1个16bit乘法器达到32位*32位的效果
`timescale 1ns/1ns
module  Thirty_two_bit_multiplier 
    (
        input [31:0]          operator_1,
        input [31:0]          operator_2,
        input                 clk,
        output reg [63:0]     answer
    );
        wire [31:0]       operated_operator_1;//此为16位乘法器结果
        wire [31:0]       operated_operator_2;//此为加法器结果
        wire              flag;//判断是否有新的输入
        wire              C_o;
        reg [31:0]        to_be_added_operator_1;//加法器的两个参数
        reg [31:0]        to_be_added_operator_2;
        reg [31:0]        operator_1_r;
        reg [31:0]        operator_2_r;
        reg [31:0]        low_answer = 32'b0;//低位结果
        reg [31:0]        high_answer = 32'b0;//高位结果
        reg [15:0]        targeted_operator_1 = 16'b0;//乘法器的两个参数
        reg [15:0]        targeted_operator_2 = 16'b0;
        reg [1:0]         curr_state = 2'b00;//状态变量
        reg [2:0]         count = 3'b0;//计数器
        assign            flag = (operator_1_r ^ operator_1) || (operator_2_r ^ operator_2);
        always @(posedge clk) begin//统一在上升沿改变输入
            operator_1_r <= operator_1;
            operator_2_r <= operator_2;
        end
        always @(posedge clk) begin//上升沿状态改变
            curr_state <= curr_state + 2'b01;
        end
        always @(posedge clk) begin//将加法器的结果按照状态的不同赋值到对应位置，该步骤有且仅有四次
            if(!flag) begin
                if(count < 3'b101)begin
                    case (curr_state)
                        2'b00: begin
                            low_answer <= operated_operator_2;
                            high_answer <= high_answer + C_o;
                        end
                        2'b01: begin
                            low_answer <= {operated_operator_2[15:0] , low_answer[15:0]};
                            high_answer <= {high_answer[31:16] + C_o , operated_operator_2[31:16]};
                        end
                        2'b10: begin
                            low_answer <= {operated_operator_2[15:0] , low_answer[15:0]};
                            high_answer <= {high_answer[31:16] + C_o , operated_operator_2[31:16]};
                        end
                        2'b11: begin
                            low_answer <= low_answer;
                            high_answer <= operated_operator_2;
                        end
                        default: begin
                            low_answer <= 32'b0;
                            high_answer <= 32'b0;
                        end
                endcase
                end
            end
            else begin
                low_answer <= 32'b0;
                high_answer <= 32'b0;
            end
        end
        always @(negedge clk) begin//下降沿输出
            if(!flag && (count == 3'b101))begin
                answer <= {high_answer , low_answer};
            end
        end
        always @(negedge clk) begin//下降沿将高电平时间计算的得到的乘法结果添加到加法器
            if(!flag) begin
                if(count < 3'b101) begin
                    case (curr_state)
                        2'b00: begin
                            to_be_added_operator_1 <= operated_operator_1;
                            to_be_added_operator_2 <= low_answer;
                        end 
                        2'b01: begin
                            to_be_added_operator_1 <= operated_operator_1;
                            to_be_added_operator_2 <= {high_answer[15:0],low_answer[31:16]};
                        end
                        2'b10: begin
                            to_be_added_operator_1 <= operated_operator_1;
                            to_be_added_operator_2 <= {high_answer[15:0],low_answer[31:16]};
                        end
                        2'b11: begin
                            to_be_added_operator_1 <= operated_operator_1;
                            to_be_added_operator_2 <= high_answer;
                        end
                        default: begin
                            to_be_added_operator_1 <= 32'b0;
                            to_be_added_operator_2 <= 32'b0;
                        end
                    endcase
                    count <= count + 3'b001;
                end
            end
            else begin
                to_be_added_operator_1 <= 32'b0;
                to_be_added_operator_2 <= 32'b0;
                count <= 3'b000;
            end
        end
        always @(*) begin//根据状态的不同改变乘法的参数
            if(!flag) begin
                case (curr_state)
                2'b00: begin
                    targeted_operator_1 = operator_1[15:0];
                    targeted_operator_2 = operator_2[15:0];
                end
                2'b01: begin
                    targeted_operator_1 = operator_1[15:0];
                    targeted_operator_2 = operator_2[31:16];
                end
                2'b10: begin
                    targeted_operator_1 = operator_1[31:16];
                    targeted_operator_2 = operator_2[15:0];
                end
                2'b11: begin
                    targeted_operator_1 = operator_1[31:16];
                    targeted_operator_2 = operator_2[31:16];
                end
                default: begin
                    targeted_operator_1 = 16'b0;
                    targeted_operator_2 = 16'b0;
                end
                endcase
            end
            else begin
                targeted_operator_1 = 16'b0;
                targeted_operator_2 = 16'b0;
            end
        end
        Thirty_two_bit_adder u_thirty_two_bit_adder//完成加法器和乘法器的例化
            (
                .operator_1    (to_be_added_operator_1),
                .operator_2    (to_be_added_operator_2),
                .operator_3    (1'b0),
                .C             (C_o),
                .answer        (operated_operator_2)
            );
        Sixteen_bit_multiplier u_sixteen_bit_multiplier
            (
                .operator_1    (targeted_operator_1),
                .operator_2    (targeted_operator_2),
                .answer        (operated_operator_1)
            );
endmodule //Sixty_four_bit_multiplier