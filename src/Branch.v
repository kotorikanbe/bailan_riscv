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
	
    assign branch_judge = (beq && (reg_src_dat_1 == reg_src_dat_2)) |
                          (bne && (reg_src_dat_1 != reg_src_dat_2)) |
                          (blt && (reg_src_dat_1 <  reg_src_dat_2)) |
                          (bge && (reg_src_dat_1 >= reg_src_dat_2)) |
                          (bltu && (reg_src_dat_1 < reg_src_dat_2)) |
                          (bgeu && (reg_src_dat_1 >= reg_src_dat_2));

   
endmodule