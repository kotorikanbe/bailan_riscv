`timescale 1ns/1ns
module Decoder_control 
    #(
        parameter [6:0]             op_R        = 7'b0110011, //R型指令
        parameter [6:0]             op_I_load   = 7'b0000011, //I型指令的load类
        parameter [6:0]             op_I_jalr   = 7'b1100111, //I型指令的跳转指令
        parameter [6:0]             op_I_cal    = 7'b0010011, //I型指令的计算类指令
        parameter [6:0]             op_S        = 7'b0100011, //S型指令
        parameter [6:0]             op_B        = 7'b1100011, //B型指令
        parameter [6:0]             op_U_lui    = 7'b0110111, //U型指令的lui指令
        parameter [6:0]             op_U_auipc  = 7'b0010111, //U型指令的auipc指令
        parameter [6:0]             op_J_jal    = 7'b1101111  //J型指令
    )
    (
        input                       clk,
        input [31:0]                inst, //指令

        input                       branch_judge,
        
        output [4:0]                reg_src_1,
        output [4:0]                reg_src_2,
        output [4:0]                reg_des,
        output reg signed [31:0]    imm,
        
        output              mem_rd, //RAM的读使能
        output              mem_wr, //RAM写使能

        output reg [1:0]    wb_sel, //写回寄存器的数据选择器控制信号
        output              reg_wr,  //寄存器的写使能控制信号
        output              pc_sel,
        
        output              alu_src1, //ALU操作数来源
        output              alu_src2, //ALU操作数来源
        output reg [4:0]    alu_ctl, //ALU控制信号

        output              beq,
        output              bne,
        output              blt,
        output              bge,
        output              bltu,
        output              bgeu,
        
        output [2:0]        rw_type //RAM的读写类型（lb sb lh sh lw sw lbu lhu）
    );

        wire [6:0]                opcode;
        wire [2:0]                funct3;
        wire [6:0]                funct7;

        wire                      is_R;
            //整数指令集
        wire                      is_R_add;
        wire                      is_R_sub;
        wire                      is_R_sll;
        wire                      is_R_slt;
        wire                      is_R_sltu;
        wire                      is_R_xor;
        wire                      is_R_srl;
        wire                      is_R_sra;
        wire                      is_R_or;
        wire                      is_R_and;
            //乘法指令集
        wire                      is_R_mul;
        wire                      is_R_mulh;
        wire                      is_R_mulsu;
        wire                      is_R_mulu;
        wire                      is_R_div;
        wire                      is_R_divu;
        wire                      is_R_rem;
        wire                      is_R_remu;
        
        //I型指令
        wire                      is_I;
            //load类
        wire                      is_I_load;
            //跳转类
        wire                      is_I_jalr;
            //计算类
        wire                      is_I_cal;
        wire                      is_I_addi;               
        wire                      is_I_slli;               
        wire                      is_I_slti;               
        wire                      is_I_sltiu;               
        wire                      is_I_xori;               
        wire                      is_I_srli;               
        wire                      is_I_srai;               
        wire                      is_I_ori;               
        wire                      is_I_andi;               

        //B型指令
        wire                      is_B;
        wire                      is_B_beq;
	    wire                      is_B_bne;
	    wire                      is_B_blt;
	    wire                      is_B_bge;
	    wire                      is_B_bltu;
	    wire                      is_B_bgeu;

        //S型指令
        wire                      is_S;

        //U型指令
        wire                      is_U;
        wire                      is_U_lui;
        wire                      is_U_auipc;

        //J型指令
        wire                      is_J_jal;


         ///////////////////////////////////////////////////////////////////////////
        //// 先对指令进行分割，定位opcode、funct3等                               ////
        ///////////////////////////////////////////////////////////////////////////

        assign    opcode          = inst[6:0];
        assign    funct3          = inst[14:12];
        assign    funct7          = inst[31:25];
        assign    reg_src_1       = inst[19:15];
        assign    reg_src_2       = inst[24:20];
        assign    reg_des         = inst[11:7]; 


        //指令大类判断
        assign    is_R          = (opcode == op_R);
        assign    is_I          = is_I_load | is_I_cal | is_I_jalr;
        assign    is_S          = (opcode == op_S);
        assign    is_B          = (opcode == op_B);
        assign    is_U          = is_U_lui | is_U_auipc;
        assign    is_J          = is_J_jal;
        

        //具体指令判断
        //R型指令
            //整数指令集
        assign    is_R_add      = ((is_R) && (funct3 == 3'h0 && funct7 == 7'h00));
        assign    is_R_sub      = ((is_R) && (funct3 == 3'h0 && funct7 == 7'h20));
        assign    is_R_sll      = ((is_R) && (funct3 == 3'h1 && funct7 == 7'h00));
        assign    is_R_slt      = ((is_R) && (funct3 == 3'h2 && funct7 == 7'h00));
        assign    is_R_sltu     = ((is_R) && (funct3 == 3'h3 && funct7 == 7'h00));
        assign    is_R_xor      = ((is_R) && (funct3 == 3'h4 && funct7 == 7'h00));
        assign    is_R_srl      = ((is_R) && (funct3 == 3'h5 && funct7 == 7'h00));
        assign    is_R_sra      = ((is_R) && (funct3 == 3'h5 && funct7 == 7'h20));
        assign    is_R_or       = ((is_R) && (funct3 == 3'h6 && funct7 == 7'h00));
        assign    is_R_and      = ((is_R) && (funct3 == 3'h7 && funct7 == 7'h00));
            //乘法指令集
        assign    is_R_mul      = ((is_R) && (funct3 == 3'h0 && funct7 == 7'h01));
        assign    is_R_mulh     = ((is_R) && (funct3 == 3'h1 && funct7 == 7'h01));
        assign    is_R_mulsu    = ((is_R) && (funct3 == 3'h2 && funct7 == 7'h01));
        assign    is_R_mulu     = ((is_R) && (funct3 == 3'h3 && funct7 == 7'h01));
        assign    is_R_div      = ((is_R) && (funct3 == 3'h4 && funct7 == 7'h01));
        assign    is_R_divu     = ((is_R) && (funct3 == 3'h5 && funct7 == 7'h01));
        assign    is_R_rem      = ((is_R) && (funct3 == 3'h6 && funct7 == 7'h01));
        assign    is_R_remu     = ((is_R) && (funct3 == 3'h7 && funct7 == 7'h01));
    
        //I型指令
            //计算类
            //注：srli指令和srai指令的imm前7位固定，相当于funct7
        assign    is_I_cal      = (opcode == op_I_cal);
        assign    is_I_addi 	= ((is_I_cal) && (funct3 == 3'h0));
	    assign    is_I_slli 	= ((is_I_cal) && (funct3 == 3'h1 && funct7 == 7'h00));
	    assign    is_I_slti 	= ((is_I_cal) && (funct3 == 3'h2));
	    assign    is_I_sltiu    = ((is_I_cal) && (funct3 == 3'h3));
	    assign    is_I_xori 	= ((is_I_cal) && (funct3 == 3'h4));
	    assign    is_I_srli 	= ((is_I_cal) && (funct3 == 3'h5 && funct7 == 7'h00));
	    assign    is_I_srai 	= ((is_I_cal) && (funct3 == 3'h5 && funct7 == 7'h10));
	    assign    is_I_ori      = ((is_I_cal) && (funct3 == 3'h6));
	    assign    is_I_andi 	= ((is_I_cal) && (funct3 == 3'h7));

            //load类
            //注：可能有问题，不知道需要执行load操作的是不是当前指令
            //具体指令无需在此处判断，直接输出funct3，让RAM判断即可
        assign    is_I_load     = (opcode == op_I_load);
        // assign    is_I_lb 		= ((opcode == op_I_load) && (funct3 == 3'h0));
	    // assign    is_I_lh 		= ((opcode == op_I_load) && (funct3 == 3'h1));
	    // assign    is_I_lw 		= ((opcode == op_I_load) && (funct3 == 3'h2));
	    // assign    is_I_lbu		= ((opcode == op_I_load) && (funct3 == 3'h4));
	    // assign    is_I_lhu		= ((opcode == op_I_load) && (funct3 == 3'h5));

            //跳转类 前面已赋值
        assign    is_I_jalr     = (opcode == op_I_jalr);


        //B型指令
        assign    is_B_beq 		 = ((is_B) && (funct3 == 0));
	    assign    is_B_bne 		 = ((is_B) && (funct3 == 1));
	    assign    is_B_blt 		 = ((is_B) && (funct3 == 4));
	    assign    is_B_bge 		 = ((is_B) && (funct3 == 5));
	    assign    is_B_bltu 	 = ((is_B) && (funct3 == 6));
	    assign    is_B_bgeu 	 = ((is_B) && (funct3 == 7));

        //U型指令
        assign    is_U_lui      = (opcode == op_U_lui);
        assign    is_U_auipc    = (opcode == op_U_auipc);


        //J型指令
        assign    is_J_jal      = (opcode == op_J_jal);

        //取得立即数imm

        always @(*) begin
            if(is_I_cal || is_I_load || is_I_jalr) 
                imm = { {20{inst[31]}},inst[31:20] };
            else if(is_U_lui || is_U_auipc)
                imm = { inst[31:12],12'b0000_0000_0000 };
            else if(is_B)
                imm = { {20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0 };
            else if(is_S)
                imm = { {20{inst[31]}},inst[31:25],inst[11:7] };
            else if(is_J)
                imm = { {11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0 };
        end



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
            else 
                alu_ctl = 5'b00000;  
        end


    
endmodule