module VGATOP 
(
    input clk,
    input rst,
    inout ps2_clk,
    inout ps2_data,
    output [3:0] vga_o_red,
    output [3:0] vga_o_blue,
    output [3:0] vga_o_green,
    output h_sync,
    output v_sync,
    output [2:0] key_down

);
    wire [15:0] mouse_position_x;
    wire [15:0] mouse_position_y;
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
        .number12('d0),
        .number11('d0),
        .number10('d0),
        .number9('d0),
        .number8('d0),
        .number7('d0),
        .number6('d0),
        .number5('d0),
        .number4('d0),
        .number3('d0),
        .number2('d0),
        .number1('d0),
        .point('d2),
        .symbol('d0),
        .mouse_position_x(mouse_position_x),
        .mouse_position_y(mouse_position_y),
        .vga_o_red(vga_o_red),
        .vga_o_green(vga_o_green),
        .vga_o_blue(vga_o_blue),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );
endmodule