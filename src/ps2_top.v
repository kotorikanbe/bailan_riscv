



module Ps2_top 
    (
        input                clk,
        input                rstn,
        inout                ps2_clk,
        inout                ps2_data,
        output reg [15:0]    x_position,
        output reg [15:0]    y_position,
        output               LBM
    );
    
    wire done;

    Ps2_Init u_Ps2_Init
        (
            .clk(clk),
            .rstn(rstn),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .done(done)
        );
    Ps2_read_data u_Ps2_read_data
        (
            .clk(clk),
            .rstn(rstn),
            .done(done),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .x_position(x_position),
            .y_position(y_position),
            .LBM(LBM)
        );
endmodule   