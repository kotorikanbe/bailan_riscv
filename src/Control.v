module Control 
    (
        input [2:0]         funct3,
        input [6:0]         funct7,

        //R型指令
        input               is_R,
            //整数指令集
        input               is_R_add,
        input               is_R_sub,
        input               is_R_sll,
        input               is_R_slt,
        input               is_R_sltu,
        input               is_R_xor,
        input               is_R_srl,
        input               is_R_sra,
        input               is_R_or,
        input               is_R_and,
            //乘法指令集
        input               is_R_mul,
        input               is_R_mulh,
        input               is_R_mulsu,
        input               is_R_mulu,
        input               is_R_div,
        input               is_R_divu,
        input               is_R_rem,
        input               is_R_remu,
        
        //I型指令
        input               is_I,
            //load类
        input               is_I_load,
            //跳转类
        input               is_I_jalr,
            //计算类
        input               is_I_cal,
        input               is_I_addi,               
        input               is_I_slli,               
        input               is_I_slti,               
        input               is_I_sltiu,               
        input               is_I_xori,               
        input               is_I_srli,               
        input               is_I_srai,               
        input               is_I_ori,               
        input               is_I_andi,               

        //B型指令
        input               is_B,
        input               is_B_beq,
	    input               is_B_bne,
	    input               is_B_blt,
	    input               is_B_bge,
	    input               is_B_bltu,
	    input               is_B_bgeu,

        input               branch_judge, //比较结果

        //S型指令
        input               is_S,

        //U型指令
        input               is_U,
        input               is_U_lui,
        input               is_U_auipc,

        //J型指令
        input               is_J_jal,

        output              mem_rd, //RAM的读使能
        output              mem_wr, //数据存储器写使能

        output reg [1:0]    wb_sel, //写回寄存器的数据选择器控制信号
        output              reg_wr,  //寄存器的写使能控制信号
        output              pc_sel,
        
        output              alu_src1, //ALU操作数来源
        output              alu_src2, //ALU操作数来源
        output reg [4:0]    alu_ctl, //ALU控制信号

        output              jal,
        output              jalr,
        output              beq,
        output              bne,
        output              blt,
        output              bge,
        output              bltu,
        output              bgeu,
        output              lui,
        output              U_type,
        
        output [2:0]        rw_type //RAM的读写类型（lb sb lh sh lw sw lbu lhu）

    );  
        //各种使能信号
        assign  rw_type       = funct3;

        assign  mem_rd        = is_I_load;

        assign  mem_wr        = is_S;

        assign  reg_wr        = is_I | is_R | is_U | is_J_jal;

        //各个数据选择器信号
        assign  alu_src1      = is_B | is_U_auipc | is_J_jal; //如果为1，则操作数为PC，否则为rs1
        assign  alu_src2      = is_I | is_S; //如果为1，则操作数为立即数,否则为rs2
        assign  pc_sel        = is_I_jalr | is_J_jal | (is_B & branch_judge);  //PC寄存器数据选择，若为1，则跳转

            //写回寄存器数据选择
        always @(*) begin
            if (is_I_jalr | is_J_jal)
                wb_sel = 0;
            else if (is_R | is_I_cal | is_U_auipc)
                wb_sel = 1;
            else if (is_U_lui)
                wb_sel = 2;
            else if (is_I_load)
                wb_sel = 3;
        end    
            

        
        
        //比较器信号
        assign  beq           = is_B_beq;
        assign  bne           = is_B_bne;
        assign  blt           = is_B_blt;
        assign  bge           = is_B_bge;
        assign  bltu          = is_B_bltu;
        assign  bgeu          = is_B_bgeu;


        assign  lui           = is_U_lui;
        assign  U_type        = is_U;
        assign  jal           = is_J_jal;
        assign  jalr          = is_I_jalr;

        //ALU控制信号
        always @(*) begin
            if(is_R_add | is_I_addi)
                alu_ctl = 5'b00000;
            else if(is_R_sub)
                alu_ctl = 5'b00001;
            else if(is_R_mul)
                alu_ctl = 5'b00010;
            else if(is_R_mulh)
                alu_ctl = 5'b00011;
            else if(is_R_mulsu)
                alu_ctl = 5'b00100;
            else if(is_R_mulu)
                alu_ctl = 5'b00101;
            else if(is_R_div)
                alu_ctl = 5'b00110;
            else if(is_R_divu)
                alu_ctl = 5'b00111;
            else if(is_R_rem)
                alu_ctl = 5'b01000;
            else if(is_R_remu)
                alu_ctl = 5'b01001;
            else if(is_R_and | is_I_andi)
                alu_ctl = 5'b01010;
            else if(is_R_or | is_I_ori)
                alu_ctl = 5'b01011;
            else if(is_R_xor | is_I_xori)
                alu_ctl = 5'b01100;
            else if(is_R_sll | is_I_slli)
                alu_ctl = 5'b01110;
            else if(is_R_srl | is_I_srli)
                alu_ctl = 5'b01111;
            else if(is_R_sra | is_I_srai)
                alu_ctl = 5'b10000;
            else if(is_R_sltu | is_I_sltiu)
                alu_ctl = 5'b10001;
            else if(is_R_slt | is_I_slti)
                alu_ctl = 5'b10010;   
        end

    
endmodule