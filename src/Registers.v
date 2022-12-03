module  Registers 
    (
        input [4:0]     reg_src_1_i, //寄存器序号1
        input [4:0]     reg_src_2_i, //寄存器序号2
        input [4:0]     reg_des_i, //数据写入的目标寄存器
        input [31:0]    reg_des_dat_i, //用于写入的数据
        input           rst_n_i,
        input           wr_en, //使能信号，0为读，1为写

        output [31:0]   reg_src_1_dat_o, //输出的数据1
        output [31:0]   reg_src_2_dat_o //输出的数据2
    );

        reg [31:0] registers[31:0]; //32个寄存器
        integer i;

        assign     reg_src_1_dat_o = registers[reg_src_1_i];
        assign     reg_src_2_dat_o = registers[reg_src_2_i];

        always @(*) begin
            if(rst_n_i == 0) //清零，寄存器中默认都是0
                for(i=0;i<=32;i=i+1)     
                    registers[i]<=0;
            else if(wr_en == 1)   //将数据写入寄存器
                registers[reg_des_i] = reg_des_dat_i;

        end
    
endmodule