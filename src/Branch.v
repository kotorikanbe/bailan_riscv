`timescale 1ns/1ns
//(* DONT_TOUCH= "1" *)
module Branch 
    (   
        input           beq,
        input           bne,
        input           blt,
        input           bge,
        input           bltu,
        input           bgeu,
        
        input [31:0]    reg_src_dat_1,
        input [31:0]    reg_src_dat_2,

        output          branch_judge
    );
	
        wire [31:0]     compare_result;
        wire            C;
        wire            equal;
        wire            unequal;
        wire            less;
        wire            bigger_equal;
    // assign branch_judge = (beq && (reg_src_dat_1 == reg_src_dat_2)) |
    //                       (bne && (reg_src_dat_1 != reg_src_dat_2)) |
    //                       (blt && (reg_src_dat_1 <  reg_src_dat_2)) |
    //                       (bge && (reg_src_dat_1 >= reg_src_dat_2)) |
    //                       (bltu && (reg_src_dat_1 < reg_src_dat_2)) |
    //                       (bgeu && (reg_src_dat_1 >= reg_src_dat_2));
        Thirty_two_bit_adder compare(
                                    .operator_1(reg_src_dat_1),
                                    .operator_2(~reg_src_dat_2),
                                    .operator_3(1'b1),
                                    .answer(compare_result),
                                    .C(C)
                                    );

        assign equal            = (compare_result == 0);
        assign unequal          = ~equal;
        assign less             = (compare_result[31] == 1);
        assign bigger_equal     = ~less;
        
        assign branch_judge = (beq & equal) |
                              (bne & unequal) |
                              (blt & less) |
                              (bge & bigger_equal) |
                              (bltu & less) |
                              (bgeu & bigger_equal);
        

   
endmodule