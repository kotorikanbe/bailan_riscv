module Riscv
    (
        input                   clk,
        input                   rst_n,
        output  [10:0]          rom_addr
    );
        wire    [31:0]          inst;
        wire                    clk_alu;
        wire                    clk_fetch;
        wire                    clk_ram;
        wire                    clk_reg;
        
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
        
        //wire                    mem_rd; //RAM的读使能
        wire                    mem_wr; //RAM写使能

        wire    [31:0]          mem_dat_i;
        wire    [31:0]          mem_dat_o;

        wire    [1:0]           wb_sel; //写回寄存器的数据选择器控制信号
        wire                    reg_wr;  //寄存器的写使能控制信号
        wire                    pc_sel;
        
        wire                    alu_src1_sel; //ALU操作数来源
        wire                    alu_src2_sel; //ALU操作数来源
        wire    [31:0]          alu_src1_dat;
        wire    [31:0]          alu_src2_dat;
        wire    [4:0]           alu_ctl; //ALU控制信号
        wire                    complete_signal;
        wire    [31:0]          alu_result;

        wire                    beq;
        wire                    bne;
        wire                    blt;
        wire                    bge;
        wire                    bltu;
        wire                    bgeu;
        
        wire [31:0]             mem_addr;
        wire [2:0]              rw_type; //RAM的读写类型（lb sb lh sh lw sw lbu lhu）

        assign                  pc_plus_4 = pc_out+4;
        assign                  rom_addr = pc_out[12:2];
        assign                  mem_dat_i = reg_src_dat_2;
        assign                  mem_addr = {3'b000,alu_result[28:0]};
        

        ROM rom (.clk(clk_fetch),
                 .addr(rom_addr),
                 .inst(inst)
                );

        RAM ram (.clk(clk_ram),
                 .rst(~rst_n),
                
                 //.rd_en(mem_rd),
                 .wr_en(mem_wr),
        
                 .addr(mem_addr),
                 .rw_type(rw_type), //读写的类型，有：字节，半字，字，双字等等
                                //000：lb sb; 001: lh sh; 010: lw sw; 100: lbu; 101:lhu

                 .dat_i(mem_dat_i),
                 .dat_o(mem_dat_o)
                );

        Clkdiv clkdiv(.clk_100M(clk),
                      .rst_n(rst_n),
                      .alu_complete(complete_signal),
                      .clk_alu(clk_alu),
                      .clk_fetch(clk_fetch),
                      .clk_ram(clk_ram),
                      .clk_reg(clk_reg));

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

                                        //.mem_rd(mem_rd), //RAM读使能
                                        .mem_wr(mem_wr), //RAM写使能

                                        .wb_sel(wb_sel), //写回寄存器的数据选择器控制信号
                                        .reg_wr(reg_wr),  //寄存器的写使能控制信号
                                        .pc_sel(pc_sel),
                                                    
                                        .alu_src1(alu_src1_sel), //ALU操作数来源
                                        .alu_src2(alu_src2_sel), //ALU操作数来源
                                        .alu_ctl(alu_ctl), //ALU控制信号

                                        .beq(beq),
                                        .bne(bne),
                                        .blt(blt),
                                        .bge(bge),
                                        .bltu(bltu),
                                        .bgeu(bgeu),
                                        .rw_type(rw_type) //RAM的读写类型（lb sb lh sh lw sw lbu lhu）
                                    );

        Registers registers (.clk(clk_reg),
                             .reg_src_1_i(reg_src_1), //寄存器序号1
                             .reg_src_2_i(reg_src_2), //寄存器序号2
                             .reg_des_i(reg_des), //数据写入的目标寄存器
                             .reg_des_dat_i(reg_des_dat), //用于写入的数据
                             .rst_n_i(rst_n),
                             .wr_en(reg_wr), //使能信号，0为读，1为写

                             .reg_src_1_dat_o(reg_src_dat_1), //输出的数据1
                             .reg_src_2_dat_o(reg_src_dat_2) //输出的数据2
                            );

        Branch branch(
                      .beq(beq),
                      .bne(bne),
                      .blt(blt),
                      .bge(bge),
                      .bltu(bltu),
                      .bgeu(bgeu),
                      .reg_src_dat_1(reg_src_dat_1),
                      .reg_src_dat_2(reg_src_dat_2),
                      .branch_judge(branch_judge)
                     );

        ALU alu( .operator_1(alu_src1_dat),
                 .operator_2(alu_src2_dat),
                 .opcode(alu_ctl),
                 .clk(clk),
                 .clk_alu(clk_alu),
                 .answer(alu_result),
                 .complete_signal(complete_signal)
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
                      .mem_i(mem_dat_o),
                      .sel_i(wb_sel),
                      .wb_dat_o(reg_des_dat)   
                    );


        
    
endmodule