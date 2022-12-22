module Top 
    (
        input                clk,
        input                rstn,
        inout                ps2_clk,
        inout                ps2_data,
        output               LBM, //左键
        output reg [3:0]     vga_o_red,
        output reg [3:0]     vga_o_green,
        output reg [3:0]     vga_o_blue,
        output               h_sync,
        output               v_sync
    );
    wire[15:0] x_position;
    wire[15:0] y_position;

    Ps2_top U1
    (
        .clk(clk),
        .rstn(rstn),
        .x_position(x_position),
        .y_position(y_position),
        .LBM(LBM),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data)
    );

    Mouse_vga U2
    (
        .clk(clk),
        .vga_o_red(vga_o_red),
        .vga_o_blue(vga_o_blue),
        .vga_o_green(vga_o_blue),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .mouse_position_x(x_position),
        .mouse_position_y(y_position)
    );
endmodule