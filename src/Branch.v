`timescale 1ns/1ns
//(* DONT_TOUCH= "1" *)
module Branch 
    (   
        input [2:0]     b_type,
        
        input [31:0]    reg_src_dat_1,
        input [31:0]    reg_src_dat_2,

        output          branch_judge
    );
        wire            beq;
        wire            bne;
        wire            blt;
        wire            bge;
        wire            bltu;
        wire            bgeu;
	
        wire [31:0]     compare_result;
        wire            C;
        wire            equal; //两个数相等
        wire            unequal; //两个数不相等
        wire            less; //rs1<rs2
        wire            bigger_equal; //rs1>=rs2


        //判断具体指令
        assign          beq =  (b_type == 3'h0);
        assign          bne =  (b_type == 3'h1);
        assign          blt =  (b_type == 3'h4);
        assign          bge =  (b_type == 3'h5);
        assign          bltu = (b_type == 3'h6);
        assign          bgeu = (b_type == 3'h7);


        //利用32位全加器让rs1和rs2相减，根据差的正负进行比较
        Thirty_two_bit_adder compare(
                                    .operator_1(reg_src_dat_1),
                                    .operator_2(~reg_src_dat_2),
                                    .operator_3(1'b1),
                                    .answer(compare_result),
                                    .C(C)
                                    );
        //对差进行分析
        assign equal            = (compare_result == 0);//差为0
        assign unequal          = ~equal;               //差不为0
        assign less             = (compare_result[31] == 1); //差为负数
        assign bigger_equal     = ~less; //差为非负数
        
        assign branch_judge = (beq & equal) |
                              (bne & unequal) |
                              (blt & less) |
                              (bge & bigger_equal) |
                              (bltu & less) |
                              (bgeu & bigger_equal);
        

   
endmodule