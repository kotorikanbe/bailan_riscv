module Riscv_top
    (
        input                   clk,
        input                   rst_n,
        inout                   ps2_clk,
        inout                   ps2_data,

        output  [3:0]           vga_o_red,
        output  [3:0]           vga_o_blue,
        output  [3:0]           vga_o_green,
        output                  h_sync,
        output                  v_sync,
        output [31:0]           inst
        //output  [31:0]          data
    );
    
       // wire    [31:0]          inst;
        wire    [13:0]          rom_addr;
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
        wire    [31:0]          addr;

        wire    [2:0]           rw_type;
        wire    [31:0]          wr_ram_or_io_dat;
        wire    [31:0]          rd_ram_or_io_dat;
        wire    [31:0]          rd_ram_dat;
        wire    [31:0]          rd_io_dat;

        wire    [15:0]          Mouse_X;
        wire    [15:0]          Mouse_Y;
        wire    [7:0]           Mouse_Click;
        wire    [7:0]           VGA_num_0;
        wire    [7:0]           VGA_num_1;
        wire    [7:0]           VGA_num_2;
        wire    [7:0]           VGA_num_3;
        wire    [7:0]           VGA_num_4;
        wire    [7:0]           VGA_num_5;
        wire    [7:0]           VGA_num_6;
        wire    [7:0]           VGA_num_7;
        wire    [7:0]           VGA_num_8;
        wire    [7:0]           VGA_num_9;
        wire    [7:0]           VGA_num_10;
        wire    [7:0]           VGA_num_11;
        wire    [7:0]           VGA_point;
        wire    [7:0]           VGA_sign;


        // wire    [31:0]          gpio_ctrl;
        // wire    [31:0]          gpio_data;
        // wire    [1:0]           io_in;

        // //io0
        // assign                  io_in[0] = (gpio_ctrl[1:0] == 2'b01)? gpio_data[0]: 1'bz;
        // // io1
        // assign                  io_in[1] = (gpio_ctrl[3:2] == 2'b01)? gpio_data[1]: 1'bz;

        assign                  addr = {8'b00000000,ram_or_io_addr[23:0]};


        

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
    
            .addr(addr),
            .rw_type(rw_type), //读写的类型，有：字节，半字，字，双字等等
                            //000：lb sb; 001: lh sh; 010: lw sw; 100: lbu; 101:lhu

            .dat_i(wr_ram_or_io_dat),
            .dat_o(rd_ram_dat)
        );
        
        GPIO gpio
        (
            .clk(clk_ram),  
            .rst_n(rst_n),  
            
            .wr_en(io_wr),  //总线写使�?
            .addr(addr),   //总线 配置IO口寄存器地址
            .dat_i(wr_ram_or_io_dat),   //总线 写数据（用来配置IO口相关寄存器�?
            .Mouse_X(Mouse_X),
            .Mouse_Y(Mouse_Y),
            .Mouse_Click(Mouse_Click),
            .VGA_num_0(VGA_num_0),
            .VGA_num_1(VGA_num_1),
            .VGA_num_2(VGA_num_2),
            .VGA_num_3(VGA_num_3),
            .VGA_num_4(VGA_num_4),
            .VGA_num_5(VGA_num_5),
            .VGA_num_6(VGA_num_6),
            .VGA_num_7(VGA_num_7),
            .VGA_num_8(VGA_num_8),
            .VGA_num_9(VGA_num_9),
            .VGA_num_10(VGA_num_10),
            .VGA_num_11(VGA_num_11),
            .VGA_point(VGA_point),
            .VGA_sign(VGA_sign),
            //.io_pin_i(io_in),  //输入模式下，IO口的输入逻辑电平
            
            //.reg_ctrl(gpio_ctrl),  //IO口控制寄存器数据 0: 高阻�?1：输出，2：输�?
            //.reg_data(gpio_data),  //IO口数据寄存器数据
            .dat_o(rd_io_dat)       // 总线读IO口寄存器数据
        );

        RAM_IO_Mux ram_io_mux
        (
             .addr(ram_or_io_addr[31:28]),
             .rd_ram_dat(rd_ram_dat),
             .rd_io_dat(rd_io_dat),
             .ram_or_io_wr(ram_or_io_wr),
             
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
            .clk_reg(clk_reg),
            .clk_ctl_mul_div(clk_ctl_mul_div),

            .inst(inst),
            .rom_addr(rom_addr),
            //.data(data),
            .alu_complete(alu_complete),

            .ram_or_io_wr(ram_or_io_wr),

            .ram_or_io_addr(ram_or_io_addr),
            .rw_type(rw_type),

            .wr_ram_or_io_dat(wr_ram_or_io_dat),
            .rd_ram_or_io_dat(rd_ram_or_io_dat)
        );

        VGA_ps2_top VGA_ps2_top
        (
            .clk(clk),
            .rst(rst_n),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .vga_o_red(vga_o_red),
            .vga_o_blue(vga_o_blue),
            .vga_o_green(vga_o_green),
            .h_sync(h_sync),
            .v_sync(v_sync),
            .key_down(Mouse_Click),
            .mouse_position_x(Mouse_X),
            .mouse_position_y(Mouse_Y),
            .number12(VGA_num_11),
            .number11(VGA_num_10),
            .number10(VGA_num_9),
            .number9(VGA_num_8),
            .number8(VGA_num_7),
            .number7(VGA_num_6),
            .number6(VGA_num_5),
            .number5(VGA_num_4),
            .number4(VGA_num_3),
            .number3(VGA_num_2),
            .number2(VGA_num_1),
            .number1(VGA_num_0),
            .point(VGA_point),
            .symbol(VGA_sign)
        );

endmodule