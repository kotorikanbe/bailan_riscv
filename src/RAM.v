module RAM(
	input           clk,
	input           rst_n,
	
	input           wr_en,
	input           rd_en,
	
	input [31:0]    addr,
	input [2:0]     rw_type, //读写的类型，有：字节，半字，字，双字等等
                             //000：lb sb; 001: lh sh; 010: lw sw; 100: lbu; 101:lhu

	input [31:0]    dat_i,
	output reg [31:0]   dat_o
    );
	
	reg [31:0]      ram[255:0];
	
	wire [31:0]     rd_dat;
	reg [31:0]      wr_dat;
	
	reg [31:0]      wr_dat_B;    //字节拼接
	reg [31:0]      wr_dat_H;   //半字拼接
	

    //写入
	
	assign rd_dat=ram[addr[31:2]]; //原来的数据

    // sb指令的写入数据，根据地址判断写入到哪一字段
    always @(*) begin
		case(addr[1:0])
			2'b00:wr_dat_B = {rd_dat[31:8],dat_i[7:0]};
			2'b01:wr_dat_B = {rd_dat[31:16],dat_i[7:0],rd_dat[7:0]};
			2'b10:wr_dat_B = {rd_dat[31:24],dat_i[7:0],rd_dat[15:0]};
			2'b11:wr_dat_B = {dat_i[7:0],rd_dat[23:0]};
		endcase
	end

    //sh指令的写入数据，根据地址判断写入到哪一字段
    always @(*) begin
        if(addr[1]==1) //写入到高16位
            wr_dat_H = {dat_i[15:0],rd_dat[15:0]};
        else  //写入到低16位
            wr_dat_H = {rd_dat[31:16],dat_i[15:0]} ;
    end

	//sw指令的写入数据就是dat_i

    //根据写类型，选择写入的数据
    always @(*) begin
        case (rw_type[1:0])
            2'b00: wr_dat = wr_dat_B;
            2'b01: wr_dat = wr_dat_H;
            2'b10: wr_dat = dat_i; 
            default: wr_dat = dat_i;
        endcase
    end

    //上升沿写入数据

    always @(posedge clk) begin
        if(wr_en)
            ram[addr[9:2]] <= wr_dat;
    end

 
    //读取

    reg [7:0] rd_dat_B;
    reg [15:0] rd_dat_H;

    reg [31:0] rd_dat_B_ext;
    reg [31:0] rd_dat_H_ext;

    //lb指令，根据写地址判断要读取哪一段
    always @(*) begin
        case(addr[1:0])
            2'b00:rd_dat_B=rd_dat[7:0];
            2'b01:rd_dat_B=rd_dat[15:8];
            2'b10:rd_dat_B=rd_dat[23:16];
            2'b11:rd_dat_B=rd_dat[31:24];
        endcase
    end

    //lh指令，根据写地址判断要读取哪一段
    always @(*) begin
        if(addr[1]==1)
            rd_dat_H = rd_dat[31:16];
        else 
            rd_dat_H = rd_dat[15:0];
    end
            

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
            2'b00: dat_o = rd_dat_B_ext;
            2'b01: dat_o = rd_dat_H_ext;
            default: dat_o = rd_dat;
        endcase
    end
   


endmodule