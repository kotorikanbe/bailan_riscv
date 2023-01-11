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

reg CLOCK;
reg PS2_CLK_reg;
reg PS2_DAT_reg;
reg RESET;
wire PS2_CLK;
wire PS2_DAT;

always #5 CLOCK = ~CLOCK;
always #20 PS2_CLK_reg = ~PS2_CLK_reg;

wire oTrig;
wire [15:0] Xpos;
wire [15:0] Ypos;
wire [7:0] key_down;

ps2mouse_basemod ps2mouse_basemod_tb(
    .CLOCK(CLOCK),
    .RESET(RESET),      //时钟复位端口
    .PS2_CLK(PS2_CLK),
    .PS2_DAT(PS2_DAT),  //鼠标PS2双向接口（时钟线，数据线）
    .oTrig(oTrig),
    .Xpos(Xpos), //最高位为符号位 X坐标
    .Ypos(Ypos), //最高位为符号位 Y坐标
    .key_down(key_down) //右中左哪一个键被按对应位置1
    );

assign PS2_CLK = PS2_CLK_reg;
assign PS2_DAT = PS2_DAT_reg;
initial begin
    CLOCK = 0;
    PS2_CLK_reg = 0;
    RESET = 0;
    #10
    RESET = 1;

    @(posedge ps2mouse_basemod_tb.EnU1)
    //第一帧
    @(negedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //起始位
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //保留
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //X符号
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //Y符号
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //X溢出
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //Y溢出
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //奇偶校验
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //停止

    #50
    //第二帧
    @(negedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //起始位
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //奇偶校验
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //停止
    
    #50
    //第三帧
    @(negedge PS2_CLK_reg)
        PS2_DAT_reg = 0; //起始位
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0;
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 0; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; 
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //奇偶校验
    @(posedge PS2_CLK_reg)
        PS2_DAT_reg = 1; //停止

    @(posedge oTrig)
    #100
    $stop;
end

endmodule
