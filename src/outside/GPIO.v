

module GPIO
   #(
        parameter            Origin         = 0,
        parameter            MOUSE_X        = Origin,
        parameter            MOUSE_Y        = Origin + 2,
        parameter            MOUSE_CLICK    = Origin + 4
    )
    (
	
        input                clk,  
        input                rst_n,  
        
        input                wr_en,  //总线写使能
        input      [31:0]    addr,   //总线 配置IO口寄存器地址
        input      [31:0]    dat_i,   //总线 写数据（用来配置IO口相关寄存器）
        input      [15:0]    Mouse_X, //鼠标行坐标
        input      [15:0]    Mouse_Y, //鼠标场坐标
        input      [7:0]     Mouse_Click, //鼠标左键点击信号
        //VGA信号
        output     [7:0]     VGA_num_0,
        output     [7:0]     VGA_num_1,
        output     [7:0]     VGA_num_2,
        output     [7:0]     VGA_num_3,
        output     [7:0]     VGA_num_4,
        output     [7:0]     VGA_num_5,
        output     [7:0]     VGA_num_6,
        output     [7:0]     VGA_num_7,
        output     [7:0]     VGA_num_8,
        output     [7:0]     VGA_num_9,
        output     [7:0]     VGA_num_10,
        output     [7:0]     VGA_num_11,
        output     [7:0]     VGA_point,
        output     [7:0]     VGA_sign,


        output reg [31:0]    dat_o       // 总线读IO口寄存器数据

    );
        //鼠标寄存器
        reg        [31:0]    Mouse[2:0];
        //VGA寄存器
        reg        [7:0]     VGA[13:0];

        integer              i;

        assign               VGA_num_0      = VGA[0];
        assign               VGA_num_1      = VGA[1];
        assign               VGA_num_2      = VGA[2];
        assign               VGA_num_3      = VGA[3];
        assign               VGA_num_4      = VGA[4];
        assign               VGA_num_5      = VGA[5];
        assign               VGA_num_6      = VGA[6];
        assign               VGA_num_7      = VGA[7];
        assign               VGA_num_8      = VGA[8];
        assign               VGA_num_9      = VGA[9];
        assign               VGA_num_10     = VGA[10];
        assign               VGA_num_11     = VGA[11];
        assign               VGA_point      = VGA[12];
        assign               VGA_sign       = VGA[13];

        //写入
        //分两种情况：1.鼠标输入 2.CPU要输出到VGA
        always @(posedge clk or negedge rst_n) begin
            if(rst_n == 0) begin
                for(i=0;i<=13;i=i+1)
                    VGA[i] <= 0;
                for(i=0;i<=2;i=i+1)
                    Mouse[i] <= 0;
            end
            else begin
                if(wr_en == 1) begin //CPU要输出到VGA
                    for(i=0;i<=13;i=i+1) begin
                        if(addr[3:0] == i) //对应的VGA寄存器写入cpu传输过来的数据
                            VGA[i] <= dat_i[7:0];
                        else VGA[i] <= VGA[i];
                    end 
                    for(i=0;i<=2;i=i+1)
                        Mouse[i] <= Mouse[i];
                end
                else begin //鼠标输入
                    for(i=0;i<=13;i=i+1) begin
                        VGA[i] <= VGA[i];
                    end
                    Mouse[0] <= {16'b0000_0000_0000_0000,Mouse_X};
                    Mouse[1] <= {16'b0000_0000_0000_0000,Mouse_Y};
                    Mouse[2] <= {24'b0000_0000_0000_0000_0000_0000,Mouse_Click}; 
                end
            end
        end

        //读取
        //只有一种情况：CPU读取鼠标坐标
        always @(*) begin
            case (addr[3:0])
                MOUSE_X:        dat_o = Mouse[0];
                MOUSE_Y:        dat_o = Mouse[1];
                MOUSE_CLICK:    dat_o = Mouse[2];
                default: dat_o = 32'b0;
            endcase
        end

endmodule
