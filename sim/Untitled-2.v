`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/24 15:59:39
// Design Name: 
// Module Name: mouse_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mouse_tb();


reg ps2_clk_reg;
reg ps2_data_reg;
wire ps2_clk;
wire ps2_data;
always #20 ps2_clk_reg = ~ps2_clk_reg;
assign ps2_clk = ps2_clk_reg;
assign ps2_data = ps2_data_reg;
initial begin
    ps2_clk_reg = 0;
    #10
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

endmodule
