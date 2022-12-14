


/////////////////////////////////////////////////////////////////////
//这是vga驱动模块，主要的作用是显示计算器的背景和可以发生变化的动态显示框//
//数字的格式是20*60，小数点的格式是5*60//
////////////////////////////////////////////////////////////////////
module VGA_display 
    (
        input clk, //100MHz
        input [7:0]         number12,
        input [7:0]         number11,
        input [7:0]         number10,
        input [7:0]         number9,
        input [7:0]         number8,
        input [7:0]         number7,
        input [7:0]         number6,
        input [7:0]         number5,
        input [7:0]         number4,
        input [7:0]         number3,
        input [7:0]         number2,
        input [7:0]         number1,   
        input [7:0]         point,
        output reg [3:0]    vga_o_red,
        output reg [3:0]    vga_o_green,
        output reg [3:0]    vga_o_blue,
        output              h_sync,
        output              v_sync,
        input [15:0]        mouse_position_x,
        input [15:0]        mouse_position_y,
        input [7:0]         symbol
    );

    wire          pixel_end;
    wire          line_end;
    wire          data_en; 
    wire          mouse_en; //表示此处是否是鼠标

    wire [11:0]   data_o_0;
    wire [11:0]   data_o_1;
    wire [11:0]   data_o_2;
    wire [11:0]   data_o_3;
    wire [11:0]   data_o_4;
    wire [11:0]   data_o_5;
    wire [11:0]   data_o_6;
    wire [11:0]   data_o_7;
    wire [11:0]   data_o_8;
    wire [11:0]   data_o_9;
    wire [11:0]   data_o_point;
    wire [11:0]   data_o_static;
    wire [11:0]   data_o_minus;

    reg           vga_clk = 'd0;//vga时钟，25MHz
    reg           count=1'b0;
    reg [10:0]    h_count = 'd0; //vga_clk跳变时跳变
    reg [10:0]    v_count = 'd0; //h_count跳变时跳变

    reg [3:0]     data_red_reg = 'd0;
    reg [3:0]     data_green_reg = 'd0;
    reg [3:0]     data_blue_reg = 'd0;

    reg [13:0]    data_addr;
    reg [5:0]     part = 'd0; //表示图像的分区
    
    reg           calculator_static_en; //表示此处是否是计算器静态背景

    //图片储存
    reg [50:0] ram_addr;
    reg [2:0] picture_0 [1499:0];
    reg [2:0] picture_1 [1499:0];
    reg [2:0] picture_2 [1499:0];
    reg [2:0] picture_3 [1499:0];
    reg [2:0] picture_4 [1499:0];
    reg [2:0] picture_5 [1499:0];
    reg [2:0] picture_6 [1499:0];
    reg [2:0] picture_7 [1499:0];
    reg [2:0] picture_8 [1499:0];
    reg [2:0] picture_9 [1499:0];
    reg [2:0] picture_p [299:0];
    reg [2:0] picture_m [1199:0];
    reg [2:0] picture_s [176399:0];

    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/0.coe",picture_0);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/1.coe",picture_1);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/2.coe",picture_2);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/3.coe",picture_3);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/4.coe",picture_4);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/5.coe",picture_5);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/6.coe",picture_6);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/7.coe",picture_7);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/8.coe",picture_8);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/9.coe",picture_9);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/p.coe",picture_p);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/m.coe",picture_m);
    initial $readmemh ("C:/Users/Yuchen/Desktop/vgapicture/s.coe",picture_s);
    assign data_o_0 = {{4{picture_0[ram_addr][0]}} , {4{picture_0[ram_addr][1]}} , {4{picture_0[ram_addr][2]}}};
    assign data_o_1 = {{4{picture_1[ram_addr][0]}} , {4{picture_1[ram_addr][1]}} , {4{picture_1[ram_addr][2]}}};
    assign data_o_2 = {{4{picture_2[ram_addr][0]}} , {4{picture_2[ram_addr][1]}} , {4{picture_2[ram_addr][2]}}};
    assign data_o_3 = {{4{picture_3[ram_addr][0]}} , {4{picture_3[ram_addr][1]}} , {4{picture_3[ram_addr][2]}}};
    assign data_o_4 = {{4{picture_4[ram_addr][0]}} , {4{picture_4[ram_addr][1]}} , {4{picture_4[ram_addr][2]}}};
    assign data_o_5 = {{4{picture_5[ram_addr][0]}} , {4{picture_5[ram_addr][1]}} , {4{picture_5[ram_addr][2]}}};
    assign data_o_6 = {{4{picture_6[ram_addr][0]}} , {4{picture_6[ram_addr][1]}} , {4{picture_6[ram_addr][2]}}};
    assign data_o_7 = {{4{picture_7[ram_addr][0]}} , {4{picture_7[ram_addr][1]}} , {4{picture_7[ram_addr][2]}}};
    assign data_o_8 = {{4{picture_8[ram_addr][0]}} , {4{picture_8[ram_addr][1]}} , {4{picture_8[ram_addr][2]}}};
    assign data_o_9 = {{4{picture_9[ram_addr][0]}} , {4{picture_9[ram_addr][1]}} , {4{picture_9[ram_addr][2]}}};
    assign data_o_point = {{4{picture_p[ram_addr][0]}} , {4{picture_p[ram_addr][1]}} , {4{picture_p[ram_addr][2]}}};
    assign data_o_minus = {{4{picture_m[ram_addr][0]}} , {4{picture_m[ram_addr][1]}} , {4{picture_m[ram_addr][2]}}};
    assign data_o_static = {{4{picture_s[ram_addr][0]}} , {4{picture_s[ram_addr][1]}} , {4{picture_s[ram_addr][2]}}};

    /////////////////////////////////////////
    parameter     hsync_end   = 10'd95;//一些在640*480 60fps状态下的常量
    parameter     hdat_begin  = 10'd143;
    parameter     hdat_end    = 10'd783;
    parameter     hpixel_end  = 10'd799;
    parameter     vsync_end   = 10'd1;
    parameter     vdat_begin  = 10'd34;
    parameter     vdat_end    = 10'd514;
    parameter     vline_end   = 10'd524;
    //parameter     v_ram_begin = 10'd199 ;
    //parameter     v_ram_end   = 10'd349;
    assign line_end = (v_count == vline_end);
    assign h_sync = (h_count > hsync_end);
    assign v_sync = (v_count > vsync_end);
    assign data_en = (v_count > vdat_begin) && (v_count <= vdat_end) && (h_count > hdat_begin) && (h_count < hdat_end);
    assign mouse_en = ((h_count > hdat_begin + mouse_position_x - 'd4) && (h_count < hdat_begin + mouse_position_x + 'd4) && (v_count > vdat_begin + mouse_position_y - 'd4) && (v_count < vdat_begin + mouse_position_y + 'd4));
//25MHz的分频
    always @(posedge clk) begin
        if(count == 1'b1) begin
            vga_clk <= ~vga_clk;
            count <= 1'b0;
        end
        else begin
            count <= count + 1'b1;
        end
    end

//行计数
    always @(posedge vga_clk) begin
        if(pixel_end) begin
            h_count <= 10'd0;
        end
        else begin
            h_count <= h_count + 1'b1;
        end
    end
    assign pixel_end = (h_count == hpixel_end);

//场计数
    always @(posedge vga_clk) begin
        if (pixel_end) begin
            if (line_end) begin
                v_count <= 'd0;
            end
            else begin
                v_count <= v_count + 1'b1;
            end
        end
    end
    
    always @(*) begin //将vga屏幕分成若干块，每一块分别进行显示
       if (!data_en) begin
            data_addr <= 'd0;
            ram_addr <= 'd0;
       end 
       else begin
        //背景部分
            if ((h_count > hdat_begin) && (h_count < hdat_end) && (v_count > vdat_begin) && (v_count < vdat_begin + 'd30)) begin
                    part <= 6'b000000;
                    ram_addr <= 'd0;
            end
            else if ((h_count > hdat_begin) && (h_count < hdat_begin + 'd110) && (v_count > vdat_begin + 'd30) && (v_count < vdat_end - 'd30)) begin
                    part <= 6'b000000;
                    ram_addr <= 'd0;
            end
            else if ((h_count > hdat_end - 'd110) && (h_count < hdat_end) && (v_count > vdat_begin + 'd30) && (v_count < vdat_end - 'd30)) begin
                    part <= 6'b000000;
                    ram_addr <= 'd0;
            end
            else if ((h_count > hdat_begin) && (h_count < hdat_end) && (v_count > vdat_end - 'd30) && (v_count < vdat_end)) begin
                    part <= 6'b000000;
                    ram_addr <= 'd0;
            end
        //计算器静态图像和动态输出部分
            //大的420*420的范围
            else if ((h_count > hdat_begin + 'd110) && (h_count < hdat_end - 'd110) && (v_count > vdat_begin + 'd30) && (v_count < vdat_end - 'd30)) begin
                    //小的动态输出部分
                    if ((h_count > hdat_begin + 'd130) && (h_count < hdat_end - 'd130) && (v_count > vdat_begin + 'd55) && (v_count < vdat_begin + 'd115)) begin
                        calculator_static_en <= 1'b0;
                        //细化到每一位数字和小数点
                            if((h_count > hdat_begin + 'd130) && (h_count < hdat_begin + 'd150)) begin      //+-symbol 
                                part <= 6'b010000;
                                ram_addr <= (h_count - hdat_begin - 'd130) + (v_count - vdat_begin - 'd55) * 'd20;
                            end
                            else if ((h_count > hdat_begin + 'd150) && (h_count < hdat_begin + 'd175)) begin//num12
                                part <= 6'b010001;
                                ram_addr <= (h_count - hdat_begin - 'd150) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd175) && (h_count < hdat_begin + 'd180)) begin//dot12
                                part <= 6'b100001;
                                ram_addr <= (h_count - hdat_begin - 'd175) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd180) && (h_count < hdat_begin + 'd205)) begin//num11
                                part <= 6'b010010;
                                ram_addr <= (h_count - hdat_begin - 'd180) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd205) && (h_count < hdat_begin + 'd210)) begin//dot11
                                part <= 6'b100010;
                                ram_addr <= (h_count - hdat_begin - 'd205) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd210) && (h_count < hdat_begin + 'd235)) begin//num10
                                part <= 6'b010011;
                                ram_addr <= (h_count - hdat_begin - 'd210) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd235) && (h_count < hdat_begin + 'd240)) begin//dot10
                                part <= 6'b100011;
                                ram_addr <= (h_count - hdat_begin - 'd235) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd240) && (h_count < hdat_begin + 'd265)) begin//num9
                                part <= 6'b010100;
                                ram_addr <= (h_count - hdat_begin - 'd240) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd265) && (h_count < hdat_begin + 'd270)) begin//dot9
                                part <= 6'b100100;
                                ram_addr <= (h_count - hdat_begin - 'd265) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd270) && (h_count < hdat_begin + 'd295)) begin//num8
                                part <= 6'b010101;
                                ram_addr <= (h_count - hdat_begin - 'd270) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd295) && (h_count < hdat_begin + 'd300)) begin//dot8
                                part <= 6'b100101;
                                ram_addr <= (h_count - hdat_begin - 'd295) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd300) && (h_count < hdat_begin + 'd325)) begin//num7
                                part <= 6'b010110;
                                ram_addr <= (h_count - hdat_begin - 'd300) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd325) && (h_count < hdat_begin + 'd330)) begin//dot7
                                part <= 6'b100110;
                                ram_addr <= (h_count - hdat_begin - 'd325) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd330) && (h_count < hdat_begin + 'd355)) begin//num6
                                part <= 6'b010111;
                                ram_addr <= (h_count - hdat_begin - 'd330) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd355) && (h_count < hdat_begin + 'd360)) begin//dot6
                                part <= 6'b100111;
                                ram_addr <= (h_count - hdat_begin - 'd355) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd360) && (h_count < hdat_begin + 'd385)) begin//num5
                                part <= 6'b011000;
                                ram_addr <= (h_count - hdat_begin - 'd360) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd385) && (h_count < hdat_begin + 'd390)) begin//dot5
                                part <= 6'b101000;
                                ram_addr <= (h_count - hdat_begin - 'd385) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd390) && (h_count < hdat_begin + 'd415)) begin//num4
                                part <= 6'b011001;
                                ram_addr <= (h_count - hdat_begin - 'd390) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd415) && (h_count < hdat_begin + 'd420)) begin//dot4
                                part <= 6'b101001;
                                ram_addr <= (h_count - hdat_begin - 'd415) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd420) && (h_count < hdat_begin + 'd445)) begin//num3
                                part <= 6'b011010;
                                ram_addr <= (h_count - hdat_begin - 'd420) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd445) && (h_count < hdat_begin + 'd450)) begin//dot3
                                part <= 6'b101010;
                                ram_addr <= (h_count - hdat_begin - 'd445) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd450) && (h_count < hdat_begin + 'd475)) begin//num2
                                part <= 6'b011011; 
                                ram_addr <= (h_count - hdat_begin - 'd450) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd475) && (h_count < hdat_begin + 'd480)) begin//dot2
                                part <= 6'b101011;
                                ram_addr <= (h_count - hdat_begin - 'd475) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else if ((h_count > hdat_begin + 'd480) && (h_count < hdat_begin + 'd505)) begin//num1
                                part <= 6'b011100;
                                ram_addr <= (h_count - hdat_begin - 'd480) + (v_count - vdat_begin - 'd55) * 'd25;
                            end
                            else if ((h_count > hdat_begin + 'd505) && (h_count < hdat_begin + 'd510)) begin//dot1
                                part <= 6'b101100;
                                ram_addr <= (h_count - hdat_begin - 'd505) + (v_count - vdat_begin - 'd55) * 'd5;
                            end
                            else begin
                                part <= 6'b000000;
                                ram_addr <= 'd0;
                                
                            end
                    end
                    else begin
                        part <= 6'b000001;
                        calculator_static_en <= 1'b1;
                        ram_addr <= (h_count - hdat_begin - 'd110) + (v_count - vdat_begin - 'd30) * 'd420;
                    end
            end
            else begin
                part <= 6'b000000;
                ram_addr <= 'd0;
            end
       end
    end

    // 分区的判断和输出
    always @(*) begin
        case (part)
            6'b000000: begin
                data_red_reg <= 4'hE;
                data_green_reg <= 4'hE;
                data_blue_reg <= 4'hE;
            end 
            6'b000001: begin
                data_red_reg <= data_o_static[11:8];
                data_blue_reg <= data_o_static[7:4];
                data_green_reg <= data_o_static[3:0];
            end
            6'b010000: begin
                if (symbol == 'd1) begin
                    data_red_reg <= data_o_minus[11:8];
                    data_green_reg <= data_o_minus[7:4];
                    data_blue_reg <= data_o_minus[3:0];
                end
                else begin
                    data_red_reg <= 4'hE;
                    data_green_reg <= 4'hE;
                    data_blue_reg <= 4'hE;
                end
            end
            6'b010001: begin
                case (number12)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b010010: begin
                case (number11)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end 
            6'b010011: begin
                case (number10)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b010100: begin
                case (number9)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b010101: begin
                case (number8)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b010110: begin
                case (number7)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b010111: begin
                case (number6)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b011000: begin
                case (number5)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b011001: begin
                case (number4)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b011010: begin
                case (number3)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b011011: begin
                case (number2)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b011100: begin
                case (number1)
                    'd0: begin
                        data_red_reg <= data_o_0[11:8];
                        data_green_reg <= data_o_0[7:4];
                        data_blue_reg <= data_o_0[3:0];
                    end 
                    'd1: begin
                        data_red_reg <= data_o_1[11:8];
                        data_green_reg <= data_o_1[7:4];
                        data_blue_reg <= data_o_1[3:0];
                    end
                    'd2: begin
                        data_red_reg <= data_o_2[11:8];
                        data_green_reg <= data_o_2[7:4];
                        data_blue_reg <= data_o_2[3:0];
                    end
                    'd3: begin
                        data_red_reg <= data_o_3[11:8];
                        data_green_reg <= data_o_3[7:4];
                        data_blue_reg <= data_o_3[3:0];
                    end
                    'd4: begin
                        data_red_reg <= data_o_4[11:8];
                        data_green_reg <= data_o_4[7:4];
                        data_blue_reg <= data_o_4[3:0];
                    end
                    'd5: begin
                        data_red_reg <= data_o_5[11:8];
                        data_green_reg <= data_o_5[7:4];
                        data_blue_reg <= data_o_5[3:0];
                    end
                    'd6: begin
                        data_red_reg <= data_o_6[11:8];
                        data_green_reg <= data_o_6[7:4];
                        data_blue_reg <= data_o_6[3:0];
                    end
                    'd7: begin
                        data_red_reg <= data_o_7[11:8];
                        data_green_reg <= data_o_7[7:4];
                        data_blue_reg <= data_o_7[3:0];
                    end
                    'd8: begin
                        data_red_reg <= data_o_8[11:8];
                        data_green_reg <= data_o_8[7:4];
                        data_blue_reg <= data_o_8[3:0];
                    end
                    'd9: begin
                        data_red_reg <= data_o_9[11:8];
                        data_green_reg <= data_o_9[7:4];
                        data_blue_reg <= data_o_9[3:0];
                    end
                    default: begin
                        data_red_reg <= 4'hE;
                        data_green_reg <= 4'hE;
                        data_blue_reg <= 4'hE;
                    end
                endcase
            end
            6'b100001: begin
                if (point == 'd11) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b100010: begin
                if (point == 'd10) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b100011: begin
                if (point == 'd9) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b100100: begin
                if (point == 'd8) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b100101: begin
                if (point == 'd7) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b100110: begin
                if (point == 'd6) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b100111: begin
                if (point == 'd5) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b101000: begin
                if (point == 'd4) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b101001: begin
                if (point == 'd3) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b101010: begin
                if (point == 'd2) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b101011: begin
                if (point == 'd1) begin
                    data_red_reg <= data_o_point[11:8];
                    data_green_reg <= data_o_point[7:4];
                    data_blue_reg <= data_o_point[3:0];
                end
                else begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            end
            6'b101100: begin
                    data_red_reg <= 'hE;
                    data_green_reg <= 'hE;
                    data_blue_reg <= 'hE;
                end
            default: begin
                data_red_reg <= 'hE;
                data_green_reg <= 'hE;
                data_blue_reg <= 'hE;
            end
        endcase
    end
        
    //输出判断逻辑，分离接口，并判断鼠标
    always @(posedge vga_clk) begin
        if(mouse_en)begin
            vga_o_red <= 4'b0;
            vga_o_green <= 4'b0;
            vga_o_blue <= 4'b0;
        end
        else if (data_en) begin
            vga_o_red <= data_red_reg;
            vga_o_green <= data_green_reg;
            vga_o_blue <= data_blue_reg;
        end
        else begin
            vga_o_red <= 4'b0;
            vga_o_green <= 4'b0;
            vga_o_blue <= 4'b0;
        end
    end
endmodule