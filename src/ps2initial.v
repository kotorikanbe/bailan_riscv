


module Ps2_Init
    (
        input        clk,
        input        rstn,
        inout        ps2_clk,
        inout        ps2_data,
        output reg   done
    );
        reg          ps2_clkf;
        reg          ps2_clkb;
        parameter    t100us = 'd5000;
        reg [3:0]    state;
        reg [12:0]   t100us_delay;
        reg [8:0]    initial_data;
        reg [3:0]    count;
        reg          ps2_clk_en;
        reg          ps2_data_en;
        reg          ps2_clk_out;
        reg          ps2_data_out;
        //检测ps2_clk的下降沿
        always @(posedge clk) begin
            ps2_clkf <= ps2_clk;
            ps2_clkb <= ps2_clkf;
        end 
        wire ps2_clk_negfetch = ! ps2_clkf && ps2_clkb;

        //状态机
        always @(posedge clk or negedge rstn) begin
            if(!rstn) begin
                done <= 1'b0;
                state <= 'd0;
                t100us_delay <= 'd0;
                initial_data <= 'd0;
                count <= 'd0;
                ps2_clk_en <= 1'b0;
                ps2_data_en <= 1'b0;
                ps2_clk_out <= 1'b1;
                ps2_data_out <= 1'b1;
            end 
            else begin
                ps2_clk_en <= 1'b0;
                ps2_data_en <= 1'b0;
                ps2_clk_out <= 1'b1;
                ps2_data_out <= 1'b1;

                case (state)
                    4'd0: begin
                        initial_data <= 8'hF4;
                        count <= 4'd8;
                        state <= 4'd1;
                    end                             
                    //拉低ps_clk 100us;
                    4'd1: begin
                        ps2_clk_en <= 1'b1;
                        ps2_clk_out <= 1'b0;
                        if(t100us_delay == t100us) begin
                            state <= 4'd2;
                        end
                        else begin
                            t100us_delay <= t100us_delay + 1'b1;
                        end
                    end
                    //产生start信号，拉低data位
                    4'd2: begin
                        ps2_clk_en <= 1'b0;
                        ps2_data_en <= 1'b1;
                        ps2_data_out <= 1'b0;
                        if (ps2_clk_negfetch) begin
                            state <= 4'd3;
                        end
                    end
                    //发送F4命令初始化
                    4'd3: begin
                        ps2_clk_out <= initial_data[0];
                        ps2_clk_en <= 1'b1;
                        if(ps2_clk_negfetch) begin
                            initial_data <= initial_data >> 1'b1;
                            count <= count - 1'b1;
                            if (count == 1'b0) begin
                                state <= 4'd4;
                            end
                            else begin
                                state <= state;
                            end
                        end
                    end
                    //校验位和停止位
                    4'd4: begin
                        if(ps2_clk_negfetch) begin
                            state <= state + 1'b1;
                        end
                        else begin
                            state <= state;
                        end
                    end
                    4'd5: begin
                        if(ps2_clk_negfetch) begin
                            state <= state + 1'b1;
                        end
                        else begin
                            state <= state;
                        end
                    end
                    //初始化完成，开始读取数据
                    4'd6: begin
                        done <= 1'b1;
                        ps2_data_en <= 1'b0;
                    end
                    default: state <= 4'd6;
                endcase
            end
        end
        //inout使能
        assign ps2_clk = ps2_clk_en ? ps2_clk_out : 1'bz;
        assign ps2_data = ps2_data_en ? ps2_data_out : 1'bz;
        
endmodule