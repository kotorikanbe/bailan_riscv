//此为16进制乘法器，为32位乘法器的子单元，输入16bit，输出32bit
`timescale 1ns/1ns
module  Sixteen_bit_multiplier 
    (
        input [15:0]      operator_1,
        input [15:0]      operator_2,
        output [31:0]     answer
    );
        wire [31:0]       real_operator;//采用移位并行思路，故先拓宽到32位，左侧补0
        wire [31:0]       stored_operator [15:0];//位移后的数据，从0位到位移15位
        wire [31:0]       identified_stored_operator [15:0];//选择出来的位移数据，在operator2对应的0位清零，1位保留
        wire [31:0]       operated_operator [14:0];//加法暂存单元，其需要15次加法运算得到结果
        wire [14:0]       C;//因为加法器的进位端，但这个模块不需要，但去掉会报warning所以加上
        assign            real_operator = {16'h0000 , operator_1};//扩展操作
        assign            answer = operated_operator[14];//15次加法的结果
        genvar            i;
        generate//产生16个逻辑左移模块
            for (i = 0;i < 16;i = i + 1) begin
                Left_logic_shifter u_left_logic_shifter
                    (
                        .operator_1    (real_operator),
                        .operator_2    (i),
                        .answer        (stored_operator[i][31:0])
                    );
            end
        endgenerate
        Thirty_two_bit_adder u_thirty_two_bit_adder0//加法模块，16个数只需加15次
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
        generate//16个判断模块，判断0和1
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