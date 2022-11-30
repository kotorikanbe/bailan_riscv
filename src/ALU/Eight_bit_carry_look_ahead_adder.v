///////////////////
//八位超前进位电路//
//////////////////
module  Eight_bit_carry_look_ahead_adder
    (
        input     C_i ,
        input     P_0,
        input     P_1 ,
        input     P_2 ,
        input     P_3 ,
        input     P_4 ,
        input     P_5 ,
        input     P_6 ,
        input     P_7 ,
        input     G_0 ,
        input     G_1 ,
        input     G_2 ,
        input     G_3 ,
        input     G_4 ,
        input     G_5 ,
        input     G_6 ,
        input     G_7 ,
        output    C_0 ,
        output    C_1 ,
        output    C_2 ,
        output    C_3 ,
        output    C_4 ,
        output    C_5 ,
        output    C_6 ,
        output    C_7 
    );
        assign    C_0 = G_0 | (P_0 & C_i);
        assign    C_1 = G_1 | (P_1 & G_0) | (P_1 & P_0 & C_i);
        assign    C_2 = G_2 | (P_2 & G_1) | (P_2 & P_1 & G_0) | (P_2 & P_1 & P_0 & C_i);
        assign    C_3 = G_3 | (P_3 & G_2) | (P_3 & P_2 & G_1) | (P_3 & P_2 & P_1 & G_0) | (P_3 & P_2 & P_1 & P_0 & C_i);
        assign    C_4 = G_4 | (P_4 & G_3) | (P_4 & P_3 & G_2) | (P_4 & P_3 & P_2 & G_1) | (P_4 & P_3 & P_2 & P_1 & G_0) | (P_4 & P_3 & P_2 & P_1 & P_0 & C_i);
        assign    C_5 = G_5 | (P_5 & G_4) | (P_5 & P_4 & G_3) | (P_5 & P_4 & P_3 & G_2) | (P_5 & P_4 & P_3 & P_2 & G_1) | (P_5 & P_4 & P_3 & P_2 & P_1 & C_i) | (P_5 & P_4 & P_3 & P_2 & P_1 & P_0 & C_i);
        assign    C_6 = G_6 | (P_6 & G_5) | (P_6 & P_5 & G_4) | (P_6 & P_5 & P_4 & G_3) | (P_6 & P_5 & P_4 & P_3 & G_2) | (P_6 & P_5 & P_4 & P_3 & P_2 & G_1) | (P_6 & P_5 & P_4 & P_3 & P_2 & P_1 & G_0) | (P_6 & P_5 & P_4 & P_3 & P_2 & P_1 & P_0 & C_i);
        assign    C_7 = G_7 | (P_7 & G_6) | (P_7 & P_6 & G_5) | (P_7 & P_6 & P_5 & G_4) | (P_7 & P_6 & P_5 & P_4 & G_3) | (P_7 & P_6 & P_5 & P_4 & P_3 & G_2) | (P_7 & P_6 & P_5 & P_4 & P_3 & P_2 & G_1) | (P_7 & P_6 & P_5 & P_4 & P_3 & P_2 & P_1 & G_0) | (P_7 & P_6 & P_5 & P_4 & P_3 & P_2 & P_1 & P_0 & C_i);
endmodule