module Mouse_vga 
    (
        input               clk,
        output reg [3:0]    vga_o_red,
        output reg [3:0]    vga_o_green,
        output reg [3:0]    vga_o_blue,
        output              h_sync,
        output              v_sync,
        input [15:0]        mouse_position_x,
        input [15:0]        mouse_position_y
    );
    wire          pixel_end;
    wire          line_end;
    wire          mouse_en;
    reg           vga_clk;//vga时钟，25MHz
    reg           count=1'b0;
    reg [10:0]    h_count; //vga_clk跳变时跳变
    reg [10:0]    v_count; //h_count跳变时跳变

    parameter     hsync_end   = 10'd95;//一些在640*480 60fps状态下的常量
    parameter     hdat_begin  = 10'd143;
    parameter     hdat_end    = 10'd783;
    parameter     hpixel_end  = 10'd799;
    parameter     vsync_end   = 10'd1;
    parameter     vdat_begin  = 10'd34;
    parameter     vdat_end    = 10'd514;
    parameter     vline_end   = 10'd524;
    assign line_end = (v_count == vline_end);
    assign h_sync = (h_count > hsync_end);
    assign v_sync = (v_count > vsync_end);
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
                v_count <= v_count + 1'b1;
            end
            else begin
                v_count <= v_count;
            end
        end
    end
    
    always @(posedge vga_clk) begin
        if (mouse_en) begin
            vga_o_red <= 4'b0;
            vga_o_green <= 4'b0;
            vga_o_blue <= 4'b0;
        end
        else begin
            vga_o_red <= 4'hf;
            vga_o_green <= 4'hf;
            vga_o_blue <= 4'hf;
        end
    end


endmodule