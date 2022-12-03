module Control 
    (
        input [6:0]     opcode,
        input [2:0]     funct3,
        input [6:0]     funct7,

        input           is_R,
        input           is_I_cal,
        input           is_I_load,
        input           is_I_jalr,
        input           is_B_beq,
        input           is_B_bne,
        input           is_B_blt,
        input           is_B_bge,
        input           is_B_bltu,
        input           is_B_bgeu,
        input           is_S,
        input           is_U,
        input           is_U_lui,
        input           is_J_jal,

        output          mem_rd, //RAM的读使能
        output          mem_wr, //数据存储器写使能

        output          mem_to_reg, //写回寄存器的数据选择器控制信号
        output          reg_wr,  //寄存器的写使能控制信号
        
        output          alu_src1, //ALU操作数来源
        output          alu_src2, //ALU操作数来源
        output          alu_ctl, //ALU控制信号
        
        output [2:0]    rw_type //RAM的读写类型（lb sb lh sh lw sw lbu lhu）

    );  
        //各种使能信号
        assign rw_type = funct3;

        assign mem_rd = is_I_load;

        assign mem_wr = is_S;

        //各个数据选择器信号
        assign alu_src2 = is_I_load | is_I_cal | is_I_jalr | is_S; //如果为1，则操作数为立即数

        assign mem_to_reg = is_I_load; //如果为1，则写回寄存器的是从存储器中读取的数据

        



    
endmodule