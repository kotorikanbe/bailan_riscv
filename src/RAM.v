`timescale 1ns/1ns
module RAM
    (
        input               clk,
        input               rst_n,
        
        input               rd_en,
        input               wr_en,
        
        input [31:0]        addr,
        input [2:0]         rw_type, //读写的类型，有：字节，半字，字，双字等等
                                //000：lb sb; 001: lh sh; 010: lw sw; 100: lbu; 101:lhu

        input [31:0]        dat_i,
        output reg [31:0]   dat_o
    );  
        
	
        
        wire [31:0]      rd_dat;
        reg  [31:0]      wr_dat;
        
        wire [31:0]      wr_dat_B;    //字节拼接
        wire [31:0]      wr_dat_H;    //半字拼接

        wire [7:0]       rd_dat_B;
        wire [15:0]      rd_dat_H;

        reg  [31:0]      rd_dat_B_ext;
        reg  [31:0]      rd_dat_H_ext;
        

        RAM_core ram_core (
                            .clka(clk),            // input wire clka
                            .rsta(rst_n),            // input wire rsta
                            .ena(rd_en),              // input wire ena
                            .wea(wr_en),              // input wire [0 : 0] wea
                            .addra(addr[14:0]),          // input wire [14 : 0] addra
                            .dina(wr_dat),            // input wire [31 : 0] dina
                            .douta(rd_dat)         // output wire [31 : 0] douta
                            //.rsta_busy(rsta_busy)  // output wire rsta_busy
                          );


        //读取
        
        assign rd_dat_B = rd_dat[7:0];
        assign rd_dat_H = rd_dat[15:0];
                
        //扩展到32位，根据rw_type判断是有符号数扩展还是无符号数扩展
        always @(*) begin
            if(rw_type[2]==1)
                rd_dat_B_ext = {24'd0,rd_dat_B};
            else 
                rd_dat_B_ext = {{24{rd_dat_B[7]}},rd_dat_B};
        end

        always @(*) begin
            if(rw_type[2]==1)
                rd_dat_H_ext = {16'd0,rd_dat_H};
            else 
                rd_dat_H_ext = {{16{rd_dat_H[15]}},rd_dat_H};
        end

        //输出数据
        always @(*) begin
            case (rw_type[1:0])
                2'b00:   dat_o = rd_dat_B_ext;
                2'b01:   dat_o = rd_dat_H_ext;
                default: dat_o = rd_dat;
            endcase
        end





        
        //写入

        assign wr_dat_B = {rd_dat[31:8],dat_i[7:0]};
        assign wr_dat_H = {dat_i[15:0],rd_dat[15:0]};

        //根据写类型，选择写入的数据
        always @(*) begin
            case (rw_type[1:0])
                2'b00:   wr_dat = wr_dat_B;
                2'b01:   wr_dat = wr_dat_H;
                2'b10:   wr_dat = dat_i; 
                default: wr_dat = dat_i;
            endcase
        end
    
    
   


endmodule