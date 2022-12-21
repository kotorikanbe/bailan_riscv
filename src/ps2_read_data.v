module Ps2_read_data 
    (
        input                done,
        input                clk,
        input                rstn,
        input                ps2_clk,
        input                ps2_data,
        output reg           clk_ps2,
        output reg [15:0]    x_position,
        output reg [15:0]    y_position,
        output reg [7:0]     LBM
    );
        reg          ps2_clkf;
        reg          ps2_clkb;
        reg [15:0]   x_addr;
        reg [15:0]   y_addr;
        reg [23:0]   data;
        reg [3:0]    count0;
        reg [1:0]    count1;
        reg [2:0]    state;

        //检测ps2_clk的下降沿
        always @(posedge clk) begin
            ps2_clkf <= ps2_clk;
            ps2_clkb <= ps2_clkf;
        end 
        wire ps2_clk_negfetch = ! ps2_clkf && ps2_clkb;

        //状态机
        always @(posedge clk or negedge rstn) begin
            if (!rstn) begin
                x_addr <= 'd0;
                y_addr <= 'd0;
                state  <= 'd0;
                data   <= 'd0;
                count0 <= 'd0;
            end
            else begin
                case (state)
                    'd0: begin
                        if (done) begin
                            state <=3'd1;
                        end
                        else begin
                            count1 <= 2'd0;
                            state <= state;
                        end
                    end 
                    //start信号：在ps2_data=0时产生一个ps2_clk的下降沿
                    'd1: begin
                        if (!ps2_data && ps2_clk_negfetch) begin
                            state <= 'd2;
                        end
                        else begin
                            state <= state;
                        end
                    end
                    //读24位数据
                    'd2: begin
                        if (ps2_clk_negfetch) begin
                            data <= {ps2_data,data[23:1]};
                            if (count0 == 'd7) begin
                                state <= 'd3;
                                count0 <= 'd0;
                            end
                            else begin
                                count0 <= count0 + 1'b1;
                            end
                        end
                    end
                    //奇偶校验位，忽略
                    'd3: begin
                        if(ps2_clk_negfetch) begin
                            state <= state + 1'b1;
                        end
                        else begin
                            state <= state;
                        end
                    end
                    //字节停止信号，忽略，但需要判断ps2_data的值
                    'd4: begin
                        if(ps2_clk_negfetch && ps2_data) begin
                            state <= state + 1'b1; 
                        end
                        else begin
                            state <= state + 1'b1;
                        end
                    end
                    //需要读3字节的数据，因此要使得count1变成3
                    'd5: begin
                        if (count1 == 'd2) begin
                            count1 <= 'd0;
                            state <= 'd0;
                            clk_ps2 <= ~clk_ps2;
                            x_addr <= { {8{data[4]}} , data[15:8] };
                            y_addr <= { {8{data[5]}} , data[23:16] };
                            LBM <= {{7'b0},{data[0]}};
                        end
                        else begin
                        if(count1 == 'd1) begin
                            clk_ps2 <= ~clk_ps2;
                        end
                            state <= 3'd0;
                            count1 <= count1 + 'd1;
                        end 
                    end
                    default: state <= state;
                endcase
            end
        end

        //x，y在vga屏幕上的坐标位置。
        always @(posedge ps2_clk or negedge rstn) begin
            if (!rstn) begin
                x_position <= 'd0;
                y_position <= 'd0;
            end
            else     
        end
endmodule 