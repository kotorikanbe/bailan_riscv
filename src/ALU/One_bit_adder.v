/////////////////////////////////////////
//简单的适配超前进位的一位加法器，例化32个//
////////////////////////////////////////
`timescale 1ns/1ns
module  One_bit_adder
    (
        input     A_i,
        input     B_i,
        input     C_i,
        output    P_o,
        output    G_o,
        output    S_o
    );
        assign    S_o = A_i ^ B_i ^ C_i;
        assign    G_o = A_i & B_i;
        assign    P_o = A_i | B_i;
endmodule