module Top_tb ();
        reg                   clk;
        reg                   rst_n;
        wire                   ps2_clk;
        wire                   ps2_data;

        wire  [3:0]           vga_o_red;
        wire  [3:0]           vga_o_blue;
        wire  [3:0]           vga_o_green;
        wire                  h_sync;
        wire                  v_sync;
        reg ps2_clk_reg;
    reg ps2_data_reg;
    
    assign ps2_clk = ps2_clk_reg;
    assign ps2_data = ps2_data_reg;

    Riscv_top riscv_top(clk,rst_n,ps2_clk,ps2_data,vga_o_red,vga_o_blue,vga_o_green,h_sync,v_sync);

    always #5 clk=~clk;
    always #20 ps2_clk_reg = ~ps2_clk_reg;
    initial begin
        rst_n = 0; clk = 0; ps2_clk_reg = 0;
        #3 rst_n =1;
        #100000
        //第一帧
        @(negedge ps2_clk_reg)
            ps2_data_reg = 0; //起始位
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; //保留
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; //X符号
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //Y符号
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; //X溢出
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; //Y溢出
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //奇偶校验
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //停止

        #50
        //第二帧
        @(negedge ps2_clk_reg)
            ps2_data_reg = 0; //起始位
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //奇偶校验
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //停止
        
        #50
        //第三帧
        @(negedge ps2_clk_reg)
            ps2_data_reg = 0; //起始位
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0;
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 0; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; 
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //奇偶校验
        @(posedge ps2_clk_reg)
            ps2_data_reg = 1; //停止

    end
    
    initial begin
        
    end


    

endmodule