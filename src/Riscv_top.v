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

        wire                    mem_wr;
        wire    [31:0]          mem_addr;
        wire    [2:0]           rw_type;
        wire    [31:0]          mem_dat_i;
        wire    [31:0]          mem_dat_o;

        

        Clkdiv clkdiv(
                      .clk_100M(clk),
                      .rst_n(rst_n),
                      .alu_complete(alu_complete),
                      .clk_alu(clk_alu),
                      .clk_fetch(clk_fetch),
                      .clk_ram(clk_ram),
                      .clk_reg(clk_reg),
                      .clk_ctl_mul_div(clk_ctl_mul_div)
                     );

        ROM rom (
                 .clk(clk_fetch),
                 .addr(rom_addr),
                 .inst(inst)
                );

        RAM ram (
                 .clk(clk_ram),
                 .rst(~rst_n),
                
                 .wr_en(mem_wr),
        
                 .addr(mem_addr),
                 .rw_type(rw_type), //读写的类型，有：字节，半字，字，双字等等
                                //000：lb sb; 001: lh sh; 010: lw sw; 100: lbu; 101:lhu

                 .dat_i(mem_dat_i),
                 .dat_o(mem_dat_o)
                );

        

        Riscv riscv(  
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

                      .mem_wr(mem_wr),
        
                      .mem_addr(mem_addr),
                      .rw_type(rw_type),

                      .mem_dat_i(mem_dat_i),
                      .mem_dat_o(mem_dat_o)
                    );

endmodule