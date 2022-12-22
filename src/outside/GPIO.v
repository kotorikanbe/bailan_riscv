/* 1.先设计两个寄存器：gpio_ctrl（控制GPIO的输入和输出模式）
                       gpio_data（存放GPIO的输入或输出数据）
   2.给这两个寄存器规划地址
   3.通过寻址来写这两个寄存器。
   4.通过配置寄存器来实现GPIO的输入输出。
 */  
// GPIO模块 
module GPIO
   #(
        // // GPIO控制寄存器的地址
        // parameter            CTRL = 4'h0,
        // // GPIO数据寄存器的地址
        // parameter            DATA = 4'h4,
        //鼠标地址
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

        
        // input      [1:0]     io_pin_i,  //输入模式下，IO口的输入逻辑电平
        
        // output     [31:0]    reg_ctrl,  //IO口控制寄存器数据 0: 高阻，1：输出，2：输入
        // output     [31:0]    reg_data,  //IO口数据寄存器数据
        output reg [31:0]    dat_o       // 总线读IO口寄存器数据

    );
        //鼠标寄存器
        reg        [15:0]    Mouse[2:0];
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
                        if(addr[3:0] == i)
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
                    Mouse[0] <= Mouse_X;
                    Mouse[1] <= Mouse_Y;
                    Mouse[2] <= {8'b0000_0000,Mouse_Click}; 
                end
            end
        end

        //读取
        //只有一种情况：CPU读取鼠标坐标
        always @(*) begin
            case (addr[4:0])
                MOUSE_X:        dat_o = Mouse[0];
                MOUSE_Y:        dat_o = Mouse[1];
                MOUSE_CLICK:    dat_o = Mouse[2];
                default: dat_o = 32'b0;
            endcase
        end





        // // 每2位控制1个IO的模式，最多支持16个IO
        // // 0: 高阻，1：输出，2：输入
        // reg         [31:0]   gpio_ctrl;
        // // 输入输出数据
        // reg         [31:0]   gpio_data;


        // assign reg_ctrl = gpio_ctrl;
        // assign reg_data = gpio_data;


        // // 写寄存器
        // always @(posedge clk or negedge rst_n) begin
        //     if (rst_n == 1'b0) begin
        //         gpio_data <= 32'h0;
        //         gpio_ctrl <= 32'h0;
        //     end 
        //     else begin
        //         if (wr_en == 1'b1) begin
        //             case (addr[3:0]) //寄存器寻址
        //                 CTRL: begin
        //                     gpio_ctrl <= dat_i; //通过配置寄存器gpio_ctrl来实现GPIO的输入输出
        //                 end
        //                 DATA: begin
        //                     gpio_data <= dat_i;
        //                 end
        //             endcase
        //         end else begin //如果IO口是输入模式，则将输入的逻辑电平存放到gpio_data寄存器中
        //             if (gpio_ctrl[1:0] == 2'b10) begin
        //                 gpio_data[0] <= io_pin_i[0];
        //             end
        //             if (gpio_ctrl[3:2] == 2'b10) begin
        //                 gpio_data[1] <= io_pin_i[1];
        //             end
        //         end
        //     end
        // end

        // // 读寄存器
        // always @ (*) begin
        //     if (rst_n == 1'b0) begin
        //         dat_o = 32'h0;
        //     end else begin
        //         case (addr[3:0])
        //             CTRL: begin
        //                 dat_o = gpio_ctrl;
        //             end
        //             DATA: begin
        //                 dat_o = gpio_data;
        //             end
        //             default: begin
        //                 dat_o = 32'h0;
        //             end
        //         endcase
        //     end
        //end

endmodule
