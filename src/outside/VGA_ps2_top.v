module VGA_ps2_top 
(
    input                clk,
    input                rst,

    inout                ps2_clk,
    inout                ps2_data,

    output [3:0]         vga_o_red,
    output [3:0]         vga_o_blue,
    output [3:0]         vga_o_green,
    output               h_sync,
    output               v_sync,
    output [15:0]         mouse_position_x,
    output [15:0]         mouse_position_y,
    output [7:0]         key_down,

    input  [7:0]         number12,
    input  [7:0]         number11,
    input  [7:0]         number10,
    input  [7:0]         number9,
    input  [7:0]         number8,
    input  [7:0]         number7,
    input  [7:0]         number6,
    input  [7:0]         number5,
    input  [7:0]         number4,
    input  [7:0]         number3,
    input  [7:0]         number2,
    input  [7:0]         number1,   
    input  [7:0]         point,
    input  [7:0]         symbol
);
    wire oTrig;
    ps2mouse_basemod u0
    (
        .CLOCK(clk),
        .RESET(rst),
        .PS2_CLK(ps2_clk),
        .PS2_DAT(ps2_data),
        .oTrig(oTrig),
        .Xpos(mouse_position_x),
        .Ypos(mouse_position_y),
        .key_down(key_down)
    );

    VGA_display u1
    (
        .clk(clk),
        .number12(number12),
        .number11(number11),
        .number10(number10),
        .number9(number9),
        .number8(number8),
        .number7(number7),
        .number6(number6),
        .number5(number5),
        .number4(number4),
        .number3(number3),
        .number2(number2),
        .number1(number1),
        .point(point),
        .symbol(symbol),
        .mouse_position_x(mouse_position_x),
        .mouse_position_y(mouse_position_y),
        .vga_o_red(vga_o_red),
        .vga_o_green(vga_o_green),
        .vga_o_blue(vga_o_blue),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );
endmodule