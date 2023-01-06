`timescale 1ns / 1ps
module ps2mouse_basemod(
    input CLOCK, RESET,      //时钟复位端口
    inout PS2_CLK, PS2_DAT,  //鼠标PS2双向接口（时钟线，数据线）
    output oTrig,
//    output [31:0]oData,
    output [15:0] Xpos, //最高位为符号位 X坐标
    output [15:0] Ypos, //最高位为符号位 Y坐标
    output [7:0] key_down //右中左哪一个键被按对应位置1
    );
    reg [15:0] Xpos_reg;
    reg [15:0] Ypos_reg;
    wire [15:0] Xpos_add;
    wire [15:0] Ypos_add;
    wire EnU1;
    wire [23:0] oData;
  
    ps2_init_funcmod U1
    (
    .CLOCK( CLOCK ),
    .RESET( RESET ),
    .PS2_CLK( PS2_CLK ), // < top
    .PS2_DAT( PS2_DAT ), // < top
    .oEn( EnU1 ) // > U2
    );
  
    ps2_read_funcmod U2
    (
    .CLOCK( CLOCK ),
    .RESET( RESET ),
    .PS2_CLK( PS2_CLK ), // < top
    .PS2_DAT( PS2_DAT ), // < top
    .iEn( EnU1 ),       // < U1
    .oTrig( oTrig ),    // > Top
    .oData( oData )   // > Top
    );

    always @(posedge CLOCK) begin
        if(oTrig)
        begin
        Xpos_reg <= Xpos_reg + Xpos_add;
        Ypos_reg <= Ypos_reg + Ypos_add;
        end
        else begin
            Xpos_reg <= Xpos_reg;
            Ypos_reg <= Ypos_reg;
        end
    end
    assign Xpos_add = {{8{oData[4]}},oData[15:8]};  //最高位为符号位（鼠标运动方向）
    assign Ypos_add = ~{{8{(oData[5])}},oData[23:16]}; //最高位为符号位（鼠标运动方向）
    assign key_down =  {7'b0000000,oData[0]};
    assign Xpos = Xpos_reg;
    assign Ypos = Ypos_reg;
endmodule
