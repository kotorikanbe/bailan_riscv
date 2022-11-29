module  Machine 
    #(
        parameter [6:0]     op_R        = 7'b0110011, //R型指令
        parameter [6:0]     op_I_load   = 7'b0000011, //I型指令的load类
        parameter [6:0]     op_I_jalr   = 7'b1100111, //I型指令的跳转指令
        parameter [6:0]     op_I_cal    = 7'b0010011, //I型指令的计算类指令
        parameter [6:0]     op_S        = 7'b0100011, //S型指令
        parameter [6:0]     op_B        = 7'b1100011, //B型指令
        parameter [6:0]     op_U_lui    = 7'b0110111, //U型指令的lui指令
        parameter [6:0]     op_U_auipc  = 7'b0010111, //U型指令的auipc指令
        parameter [6:0]     op_J        = 7'b1101111  //J型指令
     )
    (   input               clk,
        input [31:0]        ram_rd_dat, //从ram读来的数据
        input [31:0]        inst, //指令

        output [9:0]        ram_addr, //数据地址
        output [9:0]        inst_addr, //指令地址
        output reg [31:0]   ram_wr_dat, //写入ram的数据
        output              ram_wr_en //ram的写入信号

    );


    ///////////////////////////////////////////////////////////////////////////
	//// 先对指令进行分割，定位opcode、funct3等                               ////
	///////////////////////////////////////////////////////////////////////////
        
        wire [6:0]           opcode;
        wire [2:0]           funct3;
        wire [6:0]           funct7;
        wire [4:0]           r_src_1;
        wire [4:0]           r_src_2;
        wire [4:0]           r_des;
        reg signed [11:0]    imm;
    
    ///////////////////////////////////////////////////////////////////////////
	//// 先对opcode进行判断，看是哪一类型的指令                               ////
	///////////////////////////////////////////////////////////////////////////
        wire    is_R;
        wire    is_I_load;
        wire    is_I_jalr;
        wire    is_I_cal;
        wire    is_S;
        wire    is_B;
        wire    is_U_lui;
        wire    is_U_auipc;
        wire    is_J;

    
    ///////////////////////////////////////////////////////////////////////////
	////        再根据funct3和funct7具体判断是哪一条指令                     ////
	///////////////////////////////////////////////////////////////////////////
       
        //R型指令
            //整数指令集
        wire    is_R_add;
        wire    is_R_sub;
        wire    is_R_sll;
        wire    is_R_slt;
        wire    is_R_sltu;
        wire    is_R_xor;
        wire    is_R_srl;
        wire    is_R_sra;
        wire    is_R_or;
        wire    is_R_and;
            //乘法指令集
        wire    is_R_mul;
        wire    is_R_mulh;
        wire    is_R_mulsu;
        wire    is_R_mulu;
        wire    is_R_div;
        wire    is_R_divu;
        wire    is_R_rem;
        wire    is_R_remu;

        //I型指令
            //计算类
        wire    is_I_addi;
        wire    is_I_slli;
        wire    is_I_slti;
        wire    is_I_sltiu;
        wire    is_I_xori;
        wire    is_I_srli;
        wire    is_I_srai;
        wire    is_I_ori;
        wire    is_I_andi;
            //load类
        wire    is_I_lb;
        wire    is_I_lh;
        wire    is_I_lw;
        wire    is_I_lbu;
        wire    is_I_lhu;

            //jump类
        //wire    is_I_jalr; 独享opcode，所以前面已经定义

        //S型指令
        wire    is_S_sb;
        wire    is_S_sh;
        wire    is_S_sw;

        //B型指令
        wire    is_B_beq;
	    wire    is_B_bne;
	    wire    is_B_blt;
	    wire    is_B_bge;
	    wire    is_B_bltu;
	    wire    is_B_bgeu;

        //U型指令 （前面均已定义过）
        //wire    is_U_auipc;
        //wire    is_U_lui;

        //J型指令
        wire    is_J_jal;


    ///////////////////////////////////////////////////////////////////////////
	//// 对上述变量进行赋值                                                  ////
	///////////////////////////////////////////////////////////////////////////

        assign  opcode     = inst[6:0];
        assign  funct3     = inst[14:12];
        assign  funct7     = inst[31:25];
        assign  r_src_1    = inst[19:15];
        assign  r_src_2    = inst[24:20];
        assign  r_des      = inst[11:7]; 

    
    //指令大类判断
        assign    is_R_type     = (opcode == op_R);
        assign    is_I_load     = (opcode == op_I_load);
        assign    is_I_jalr     = (opcode == op_I_jalr);
        assign    is_I_cal      = (opcode == op_I_cal);
        assign    is_S          = (opcode == op_S);
        assign    is_B          = (opcode == op_B);
        assign    is_U_lui      = (opcode == op_U_lui);
        assign    is_U_auipc    = (opcode == op_U_auipc);
        assign    is_J          = (opcode == op_J);

    //具体指令判断
        //R型指令
            //整数指令集
        assign    is_R_add      = ((is_R_type) && (funct3 == 3'h0 && funct7 == 7'h00));
        assign    is_R_sub      = ((is_R_type) && (funct3 == 3'h0 && funct7 == 7'h20));
        assign    is_R_sll      = ((is_R_type) && (funct3 == 3'h1 && funct7 == 7'h00));
        assign    is_R_slt      = ((is_R_type) && (funct3 == 3'h2 && funct7 == 7'h00));
        assign    is_R_sltu     = ((is_R_type) && (funct3 == 3'h3 && funct7 == 7'h00));
        assign    is_R_xor      = ((is_R_type) && (funct3 == 3'h4 && funct7 == 7'h00));
        assign    is_R_srl      = ((is_R_type) && (funct3 == 3'h5 && funct7 == 7'h00));
        assign    is_R_sra      = ((is_R_type) && (funct3 == 3'h5 && funct7 == 7'h20));
        assign    is_R_or       = ((is_R_type) && (funct3 == 3'h6 && funct7 == 7'h00));
        assign    is_R_and      = ((is_R_type) && (funct3 == 3'h7 && funct7 == 7'h00));
            //乘法指令集
        assign    is_R_mul      = ((is_R_type) && (funct3 == 3'h0 && funct7 == 7'h01));
        assign    is_R_mulh     = ((is_R_type) && (funct3 == 3'h1 && funct7 == 7'h01));
        assign    is_R_mulsu    = ((is_R_type) && (funct3 == 3'h2 && funct7 == 7'h01));
        assign    is_R_mulu     = ((is_R_type) && (funct3 == 3'h3 && funct7 == 7'h01));
        assign    is_R_div      = ((is_R_type) && (funct3 == 3'h4 && funct7 == 7'h01));
        assign    is_R_divu     = ((is_R_type) && (funct3 == 3'h5 && funct7 == 7'h01));
        assign    is_R_rem      = ((is_R_type) && (funct3 == 3'h6 && funct7 == 7'h01));
        assign    is_R_remu     = ((is_R_type) && (funct3 == 3'h7 && funct7 == 7'h01));
    
        //I型指令
            //计算类
            //注：srli指令和srai指令的imm前7位固定，相当于funct7
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
        assign    is_I_lb 		= ((opcode == op_I_load) && (funct3 == 3'h0));
	    assign    is_I_lh 		= ((opcode == op_I_load) && (funct3 == 3'h1));
	    assign    is_I_lw 		= ((opcode == op_I_load) && (funct3 == 3'h2));
	    assign    is_I_lbu		= ((opcode == op_I_load) && (funct3 == 3'h4));
	    assign    is_I_lhu		= ((opcode == op_I_load) && (funct3 == 3'h5));

            //jalr 前面已赋值
        //assign    is_I_jalr     = (opcode == op_I_jalr);


        //B型指令
        assign    is_B_beq 		 = ((is_B) && (funct3 == 0));
	    assign    is_B_bne 		 = ((is_B) && (funct3 == 1));
	    assign    is_B_blt 		 = ((is_B) && (funct3 == 4));
	    assign    is_B_bge 		 = ((is_B) && (funct3 == 5));
	    assign    is_B_bltu 	 = ((is_B) && (funct3 == 6));
	    assign    is_B_bgeu 	 = ((is_B) && (funct3 == 7));

        //U型指令，前面已赋值

        //J型指令
        assign    is_J_jal       = is_J;


        //取得立即数imm

        always @(*) begin
            if(is_I_cal || is_I_load || is_I_jalr) 
                imm =   { {20{inst[31]}},inst[31:20] };
            else if(is_U_lui || is_U_auipc)
                imm =   { inst[31:12],12'b0000_0000_0000 };
            else if(is_B)
                imm =   { {19{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0 };
            else if(is_S)
                imm =   { {20{inst[31]}},inst[31:25],inst[11:7] };
            else if(is_J)
                imm =   { {11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0 };
        end




        
        



    
endmodule