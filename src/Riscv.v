module Riscv
    (
        input   clk,
        input [31:0] inst
    );
        wire                       branch_judge;
        
        wire [4:0]                reg_src_1;
        wire [4:0]                reg_src_2;
        wire [4:0]                reg_des;
        wire signed [11:0]    imm;
        
        wire              mem_rd; //RAM的读使能
        wire              mem_wr; //RAM写使能

        wire [1:0]    wb_sel; //写回寄存器的数据选择器控制信号
        wire              reg_wr;  //寄存器的写使能控制信号
        wire              pc_sel;
        
        wire              alu_src1; //ALU操作数来源
        wire              alu_src2; //ALU操作数来源
        wire [4:0]    alu_ctl; //ALU控制信号

        wire              jal;
        wire              jalr;
        wire              beq;
        wire              bne;
        wire              blt;
        wire              bge;
        wire              bltu;
        wire              bgeu;
        wire              lui;
        wire              U_type;
        
        wire [2:0]        rw_typel; //RAM的读写类型（lb sb lh sh lw sw lbu lhu）


       Decoder_control decoder_control( .clk(clk),
                                        .inst(inst), //指令
                                        .branch_judge(branch_judge),
                                        .reg_src_1(reg_src_1),
                                        .reg_src_2(reg_src_2),
                                        .reg_des(reg_des),
                                        .imm(imm),

                                        .mem_rd(mem_rd), //RAM的读使能
                                        .mem_wr(mem_wr), //RAM写使能

                                        .wb_sel(wb_sel), //写回寄存器的数据选择器控制信号
                                        .reg_wr(reg_wr),  //寄存器的写使能控制信号
                                        .pc_sel(pc_sel),
                                                    
                                        .alu_src1(alu_src1), //ALU操作数来源
                                        .alu_src2(alu_src2), //ALU操作数来源
                                        .alu_ctl(alu_ctl), //ALU控制信号

                                        .jal(jal),
                                        .jalr(jalr),
                                        .beq(beq),
                                        .bne(bne),
                                        .blt(blt),
                                        .bge(bge),
                                        .bltu(bltu),
                                        .bgeu(bgeu),
                                        .lui(lui),
                                        .U_type(U_type),
                                        .rw_type(rw_type) //RAM的读写类型（lb sb lh sh lw sw lbu lhu）
    );

        
    
endmodule