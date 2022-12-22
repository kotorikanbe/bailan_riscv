module Riscv
    (
        input                   clk,
        input                   clk_alu,
        input                   clk_fetch,
        input                   clk_ram,
        input                   clk_reg,
        input                   clk_ctl_mul_div,
        input                   rst_n,
        input   [31:0]          inst,

        input   [31:0]          rd_ram_or_io_dat, //从ram或IO读出来的数据
        output  [31:0]          wr_ram_or_io_dat, //要写入ram或IO的数据
        output                  ram_or_io_wr, //RAM或IO的写使能
        output  [31:0]          ram_or_io_addr,//RAM或IO的地址 
        output  [2:0]           rw_type, //RAM的读写类型（lb sb lh sh lw sw lbu lhu）
        
        output  [13:0]          rom_addr,
        output  [31:0]          data,
        output                  alu_complete

        
        

    );
        
        wire    [31:0]          pc_new;
        wire    [31:0]          pc_out;
        wire    [31:0]          pc_plus_4;
        
        wire                    branch_judge; //比较判断信号
        
        wire    [4:0]           reg_src_1;
        wire    [4:0]           reg_src_2;

        wire    [31:0]          reg_src_dat_1;
        wire    [31:0]          reg_src_dat_2;

        wire    [31:0]          reg_des_dat;

        wire    [4:0]           reg_des;
        wire signed [31:0]      imm;
        

        wire    [1:0]           wb_sel; //写回寄存器的数据选择器控制信号
        wire                    reg_wr;  //寄存器的写使能控制信号
        wire                    pc_sel;
        
        wire                    alu_src1_sel; //ALU操作数来源
        wire                    alu_src2_sel; //ALU操作数来源
        wire    [31:0]          alu_src1_dat;
        wire    [31:0]          alu_src2_dat;
        wire    [4:0]           alu_ctl; //ALU控制信号
       
        wire    [31:0]          alu_result;

        wire    [2:0]           b_type;
        

        assign                  pc_plus_4 = pc_out+4;
        assign                  rom_addr = pc_out[15:2];
        assign                  wr_ram_or_io_dat = reg_src_dat_2;
        assign                  ram_or_io_addr = alu_result;
        assign                  data = wr_ram_or_io_dat;
        

        PC pc(.clk(clk_reg),
              .rst_n(rst_n),
              .pc_new(pc_new),
              .pc_out(pc_out)
             );


        Decoder_control decoder_control(.clk(clk_fetch),
                                        .clk_alu(clk_alu),
                                        .inst(inst), //指令

                                        .branch_judge(branch_judge),
                                        .reg_src_1(reg_src_1),
                                        .reg_src_2(reg_src_2),
                                        .reg_des(reg_des),
                                        .imm(imm),

                                        //.ram_or_io_rd(ram_or_io_rd), //RAM读使能
                                        .ram_or_io_wr(ram_or_io_wr), //RAM或IO的写使能

                                        .wb_sel(wb_sel), //写回寄存器的数据选择器控制信号
                                        .reg_wr(reg_wr),  //寄存器的写使能控制信号
                                        .pc_sel(pc_sel),
                                                    
                                        .alu_src1(alu_src1_sel), //ALU操作数来源
                                        .alu_src2(alu_src2_sel), //ALU操作数来源
                                        .alu_ctl(alu_ctl), //ALU控制信号

                                        .b_type(b_type),
                                        .rw_type(rw_type) //RAM的读写类型（lb sb lh sh lw sw lbu lhu）
                                    );

        Registers registers (.clk(clk_reg),
                             .rst_n(rst_n),
                             .reg_src_1_i(reg_src_1), //寄存器序号1
                             .reg_src_2_i(reg_src_2), //寄存器序号2
                             .reg_des_i(reg_des), //数据写入的目标寄存器
                             .reg_des_dat_i(reg_des_dat), //用于写入的数据
                             
                             .wr_en(reg_wr), //使能信号，0为读，1为写

                             .reg_src_1_dat_o(reg_src_dat_1), //输出的数据1
                             .reg_src_2_dat_o(reg_src_dat_2) //输出的数据2
                            );

        Branch branch(
                      .b_type(b_type),
                      .reg_src_dat_1(reg_src_dat_1),
                      .reg_src_dat_2(reg_src_dat_2),
                      .branch_judge(branch_judge)
                     );

        ALU alu( .operator_1(alu_src1_dat),
                 .operator_2(alu_src2_dat),
                 .opcode(alu_ctl),
                 .clk(clk),
                 .clk_alu(clk_alu),
                 .clk_ctl_mul_div(clk_ctl_mul_div),
                 //.clk_mul_origin(clk_mul_origin),
                 .answer(alu_result),
                 .complete_signal(alu_complete)
                );

        
        

        Mux pc_mux( .data1_i(alu_result),
                    .data2_i(pc_plus_4),
                    .sel_i(pc_sel),
                    .dat_o(pc_new)
                  );

        Mux rs1_mux(
                    .data1_i(pc_out),
                    .data2_i(reg_src_dat_1),
                    .sel_i(alu_src1_sel),
                    .dat_o(alu_src1_dat)
                    );

        Mux rs2_mux(
                    .data1_i(imm),
                    .data2_i(reg_src_dat_2),
                    .sel_i(alu_src2_sel),
                    .dat_o(alu_src2_dat)
                    );

        WB_mux wb_mux(
                      .pc_plus4_i(pc_plus_4),
                      .alu_result_i(alu_result),
                      .imm_i(imm),
                      .ram_or_io_i(rd_ram_or_io_dat),
                      .sel_i(wb_sel),
                      .wb_dat_o(reg_des_dat)   
                    );


        
    
endmodule