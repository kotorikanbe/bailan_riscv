



module Ps2_top 
    (
        input         clk,
        input         rstn,
        inout         ps2_clk,
        inout         ps2_data,
        output        x_addr,
        output        y_addr,
        output reg    x_symbol,
        output reg    y_symbol,
        output reg    x_overflow,
        output reg    y_overflow,
        output        LBM
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
            .x_addr(x_addr),
            .y_addr(y_addr),
            .x_symbol(x_symbol),
            .y_symbol(y_symbol),
            .x_overflow(x_overflow),
            .y_overflow(y_overflow),
            .LBM(LBM)
        );
endmodule   