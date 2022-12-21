`timescale 1ns/1ns
module  Thirty_two_bit_adder 
    (
        input [31:0]     operator_1,
        input [31:0]     operator_2,
        input            operator_3,
        output [31:0]    answer,
        output           C
    );
        wire             C_o[3:0];
        wire             P[3:0];
        wire             G[3:0];
        assign           C = C_o[3];
        Eight_bit_adder u_eight_bit_adder0
            (
                .operator_1    (operator_1[7:0]),
                .operator_2    (operator_2[7:0]),
                .operator_3    (operator_3),
                .answer        (answer[7:0]),
                .P_m           (P[0]),
                .G_m           (G[0])
            );
        genvar           i;
        generate
            for (i = 1;i < 4;i = i + 1) begin
                Eight_bit_adder u_eight_bit_adder
                    (
                        .operator_1    (operator_1[8 * i + 7 : 8 * i]),
                        .operator_2    (operator_2[8 * i + 7 : 8 * i]),
                        .operator_3    (C_o[i - 1]),
                        .answer        (answer[8 * i + 7 : 8 * i]),
                        .P_m           (P[i]),
                        .G_m           (G[i])
                    );
            end
        endgenerate
        Four_bit_carry_look_ahead_adder u_four_bit_carry_look_ahead_adder
            (
                .C_i    (operator_3),
                .P_0    (P[0]),
                .P_1    (P[1]),
                .P_2    (P[2]),
                .P_3    (P[3]),
                .G_0    (G[0]),
                .G_1    (G[1]),
                .G_2    (G[2]),
                .G_3    (G[3]),
                .C_0    (C_o[0]),
                .C_1    (C_o[1]),
                .C_2    (C_o[2]),
                .C_3    (C_o[3])
            );
endmodule //Thirty_two_bit_adder
// //32位加法器，带进位端
// `timescale 1ns/1ns
// module  Thirty_two_bit_adder
//     (
//         input [31:0]     operator_1,
//         input [31:0]     operator_2,
//         input            operator_3,
//         output [31:0]    answer,
//         output           C
//     );
//         wire [31:0]      CP;
//         wire [31:0]      CG;
//         wire [31:0]      C_o;
//         assign           C = C_o[31];
//         One_bit_adder  u_adder0//这里例化了32个1位加法器
//             (
//                 .A_i    (operator_1[0]),
//                 .B_i    (operator_2[0]),
//                 .C_i    (operator_3),
//                 .P_o    (CP[0]),
//                 .G_o    (CG[0]),
//                 .S_o    (answer[0])
//             );
//         genvar           i;
//         generate
//             for (i = 1;i < 32;i = i+1 ) begin
//                 One_bit_adder  u_adder
//                     (
//                         .A_i    (operator_1[i]),
//                         .B_i    (operator_2[i]),
//                         .C_i    (C_o[i - 1]),
//                         .P_o    (CP[i]),
//                         .G_o    (CG[i]),
//                         .S_o    (answer[i])
//                     );
//             end
//         endgenerate
//         Eight_bit_carry_look_ahead_adder u_eight_bit_carry_look_ahead_adder//这里例化了4个8位超前进位器
//             (
//                 .C_i    (operator_3),
//                 .P_0    (CP[0]),
//                 .P_1    (CP[1]),
//                 .P_2    (CP[2]),
//                 .P_3    (CP[3]),
//                 .P_4    (CP[4]),
//                 .P_5    (CP[5]),
//                 .P_6    (CP[6]),
//                 .P_7    (CP[7]),
//                 .G_0    (CG[0]),
//                 .G_1    (CG[1]),
//                 .G_2    (CG[2]),
//                 .G_3    (CG[3]),
//                 .G_4    (CG[4]),
//                 .G_5    (CG[5]),
//                 .G_6    (CG[6]),
//                 .G_7    (CG[7]),
//                 .C_0    (C_o[0]),
//                 .C_1    (C_o[1]),
//                 .C_2    (C_o[2]),
//                 .C_3    (C_o[3]),
//                 .C_4    (C_o[4]),
//                 .C_5    (C_o[5]),
//                 .C_6    (C_o[6]),
//                 .C_7    (C_o[7])        
//             );
//         genvar           j;
//         generate
//             for (j = 1;j < 4;j = j + 1 ) begin
//                 Eight_bit_carry_look_ahead_adder u_eight_bit_carry_look_ahead_adder
//                     (
//                         .C_i    (C_o[j*8-1]),
//                         .P_0    (CP[j*8]),
//                         .P_1    (CP[j*8+1]),
//                         .P_2    (CP[j*8+2]),
//                         .P_3    (CP[j*8+3]),
//                         .P_4    (CP[j*8+4]),
//                         .P_5    (CP[j*8+5]),
//                         .P_6    (CP[j*8+6]),
//                         .P_7    (CP[j*8+7]),
//                         .G_0    (CG[j*8]),
//                         .G_1    (CG[j*8+1]),
//                         .G_2    (CG[j*8+2]),
//                         .G_3    (CG[j*8+3]),
//                         .G_4    (CG[j*8+4]),
//                         .G_5    (CG[j*8+5]),
//                         .G_6    (CG[j*8+6]),
//                         .G_7    (CG[j*8+7]),
//                         .C_0    (C_o[j*8]),
//                         .C_1    (C_o[j*8+1]),
//                         .C_2    (C_o[j*8+2]),
//                         .C_3    (C_o[j*8+3]),
//                         .C_4    (C_o[j*8+4]),
//                         .C_5    (C_o[j*8+5]),
//                         .C_6    (C_o[j*8+6]),
//                         .C_7    (C_o[j*8+7])
//                     );
//             end
//         endgenerate
// endmodule