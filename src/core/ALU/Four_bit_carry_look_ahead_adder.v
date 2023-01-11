module  Four_bit_carry_look_ahead_adder 
    (
        input     C_i ,
        input     P_0 ,
        input     P_1 ,
        input     P_2 ,
        input     P_3 ,
        input     G_0 ,
        input     G_1 ,
        input     G_2 ,
        input     G_3 ,
        output    C_0 ,
        output    C_1 ,
        output    C_2 ,
        output    C_3 
    );
        assign    C_0 = G_0 | (P_0 & C_i);
        assign    C_1 = G_1 | (P_1 & G_0) | (P_1 & P_0 & C_i);
        assign    C_2 = G_2 | (P_2 & G_1) | (P_2 & P_1 & G_0) | (P_2 & P_1 & P_0 & C_i);
        assign    C_3 = G_3 | (P_3 & G_2) | (P_3 & P_2 & G_1) | (P_3 & P_2 & P_1 & G_0) | (P_3 & P_2 & P_1 & P_0 & C_i);
endmodule //Four_bit_carry_look_ahead_adder