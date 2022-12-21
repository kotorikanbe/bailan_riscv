/* 1.先设计两个寄存器：gpio_ctrl（控制GPIO的输入和输出模式）
                       gpio_data（存放GPIO的输入或输出数据）
   2.给这两个寄存器规划地址
   3.通过寻址来写这两个寄存器。
   4.通过配置寄存器来实现GPIO的输入输出。
 */  
// GPIO模块 
module GPIO
   #(
        // GPIO控制寄存器的地址
        parameter            CTRL = 4'h0,
        // GPIO数据寄存器的地址
        parameter            DATA = 4'h4
    )
    (
	
        input                clk,  
        input                rst_n,  
        
        input                wr_en,  //总线写使能
        input      [31:0]    addr_i,   //总线 配置IO口寄存器地址
        input      [31:0]    dat_i,   //总线 写数据（用来配置IO口相关寄存器）
        input      [1:0]     io_pin_i,  //输入模式下，IO口的输入逻辑电平
        
        output     [31:0]    reg_ctrl,  //IO口控制寄存器数据 0: 高阻，1：输出，2：输入
        output     [31:0]    reg_data,  //IO口数据寄存器数据
        output reg [31:0]    dat_o       // 总线读IO口寄存器数据

    );

        // 每2位控制1个IO的模式，最多支持16个IO
        // 0: 高阻，1：输出，2：输入
        reg         [31:0]   gpio_ctrl;
        // 输入输出数据
        reg         [31:0]   gpio_data;


        assign reg_ctrl = gpio_ctrl;
        assign reg_data = gpio_data;


        // 写寄存器
        always @(posedge clk) begin
            if (rst_n == 1'b0) begin
                gpio_data <= 32'h0;
                gpio_ctrl <= 32'h0;
            end 
            else begin
                if (wr_en == 1'b1) begin
                    case (addr_i[3:0]) //寄存器寻址
                        CTRL: begin
                            gpio_ctrl <= dat_i; //通过配置寄存器gpio_ctrl来实现GPIO的输入输出
                        end
                        DATA: begin
                            gpio_data <= dat_i;
                        end
                    endcase
                end else begin //如果IO口是输入模式，则将输入的逻辑电平存放到gpio_data寄存器中
                    if (gpio_ctrl[1:0] == 2'b10) begin
                        gpio_data[0] <= io_pin_i[0];
                    end
                    if (gpio_ctrl[3:2] == 2'b10) begin
                        gpio_data[1] <= io_pin_i[1];
                    end
                end
            end
        end

        // 读寄存器
        always @ (*) begin
            if (rst_n == 1'b0) begin
                dat_o = 32'h0;
            end else begin
                case (addr_i[3:0])
                    CTRL: begin
                        dat_o = gpio_ctrl;
                    end
                    DATA: begin
                        dat_o = gpio_data;
                    end
                    default: begin
                        dat_o = 32'h0;
                    end
                endcase
            end
        end

endmodule
