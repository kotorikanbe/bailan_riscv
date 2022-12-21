module Riscv_top
    (
        input                   clk,
        input                   rst_n,
        output  [31:0]          data
    );

        wire    [31:0]          inst;
        wire    [10:0]          rom_addr;
        wire                    clk_alu;
        wire                    clk_fetch;
        wire                    clk_ram;
        wire                    clk_reg;
        wire                    clk_ctl_mul_div;

        wire                    alu_complete;

        wire                    ram_or_io_wr;
        wire                    ram_wr;
        wire                    io_wr;
        wire    [31:0]          ram_or_io_addr;
        wire    [2:0]           rw_type;
        wire    [31:0]          wr_ram_or_io_dat;
        wire    [31:0]          rd_ram_or_io_dat;
        wire    [31:0]          rd_ram_dat;
        wire    [31:0]          rd_io_dat;

        wire    [31:0]          gpio_ctrl;
        wire    [31:0]          gpio_data;
        wire    [1:0]           io_in;

        //io0
        assign io_in[0] = (gpio_ctrl[1:0] == 2'b01)? gpio_data[0]: 1'bz;
        // io1
        assign io_in[1] = (gpio_ctrl[3:2] == 2'b01)? gpio_data[1]: 1'bz;


        

        Clkdiv clkdiv
        (
            .clk_100M(clk),
            .rst_n(rst_n),
            .alu_complete(alu_complete),
            .clk_alu(clk_alu),
            .clk_fetch(clk_fetch),
            .clk_ram(clk_ram),
            .clk_reg(clk_reg),
            .clk_ctl_mul_div(clk_ctl_mul_div)
        );

        ROM rom 
        (
            .clk(clk_fetch),
            .addr(rom_addr),
            .inst(inst)
        );

        RAM ram 
        (
            .clk(clk_ram),
            .rst(~rst_n),
            
            .wr_en(ram_wr),
    
            .addr(ram_or_io_addr),
            .rw_type(rw_type), //读写的类型，有：字节，半字，字，双字等等
                            //000：lb sb; 001: lh sh; 010: lw sw; 100: lbu; 101:lhu

            .dat_i(wr_ram_or_io_dat),
            .dat_o(rd_ram_dat)
        );
        
        GPIO gpio
        (
            .clk(clk_ram),  
            .rst_n(rst_n),  
            
            .wr_en(io_wr),  //总线写使能
            .addr_i(ram_or_io_addr),   //总线 配置IO口寄存器地址
            .dat_i(wr_ram_or_io_dat),   //总线 写数据（用来配置IO口相关寄存器）
            .io_pin_i(io_in),  //输入模式下，IO口的输入逻辑电平
            
            .reg_ctrl(gpio_ctrl),  //IO口控制寄存器数据 0: 高阻，1：输出，2：输入
            .reg_data(gpio_data),  //IO口数据寄存器数据
            .dat_o(rd_io_dat)       // 总线读IO口寄存器数据
        );

        RAM_IO_Mux ram_io_mux
        (
             .addr(ram_or_io_addr[31:28]),
             .rd_ram_dat(rd_ram_dat),
             .rd_io_dat(rd_io_dat),
             .wr_en(wr_en),

             .rd_ram_or_io_dat(rd_ram_or_io_dat),
             .ram_wr(ram_wr),
             .io_wr(io_wr)
        );
        

        Riscv riscv
        (  
            .rst_n(rst_n),
            
            .clk(clk),
            .clk_alu(clk_alu),
            .clk_fetch(clk_fetch),
            .clk_ram(clk_ram),
            .clk_reg(clk_reg),
            .clk_ctl_mul_div(clk_ctl_mul_div),

            .inst(inst),
            .rom_addr(rom_addr),
            .data(data),
            .alu_complete(alu_complete),

            .ram_or_io_wr(ram_or_io_wr),

            .ram_or_io_addr(ram_or_io_addr),
            .rw_type(rw_type),

            .wr_ram_or_io_dat(wr_ram_or_io_dat),
            .rd_ram_or_io_dat(rd_ram_or_io_dat)
        );

endmodule