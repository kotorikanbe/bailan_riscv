
module mem_wb_regs(
	input clk,
	input rst,
	
	input [31:0]ALU_result_mem_wb_i,   
	input [31:0]pc_jump_mem_wb_i,
	input [31:0]loaddata_mem_wb_i,     //DM
	input [31:0]imme_mem_wb_i,
	input [31:0]pc_order_mem_wb_i,
	input [4:0]Rd_mem_wb_i,
	output reg [31:0]ALU_result_mem_wb_o,   
	output reg [31:0]pc_jump_mem_wb_o,
	output reg [31:0]loaddata_mem_wb_o,     //DM
	output reg [31:0]imme_mem_wb_o,
	output reg [31:0]pc_order_mem_wb_o,
	output reg [4:0]Rd_mem_wb_o,
	//control signals
	input jal_mem_wb_i,
	input jalr_mem_wb_i,
	input lui_mem_wb_i,
	input U_type_mem_wb_i,
	input MemtoReg_mem_wb_i,
	input RegWrite_mem_wb_i,
	
	output reg jal_mem_wb_o,
	output reg jalr_mem_wb_o,
	output reg lui_mem_wb_o,
	output reg U_type_mem_wb_o,
	output reg MemtoReg_mem_wb_o,
	output reg RegWrite_mem_wb_o

    );
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			ALU_result_mem_wb_o<='d0;
		else
			ALU_result_mem_wb_o<=ALU_result_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			pc_jump_mem_wb_o<='d0;
		else
			pc_jump_mem_wb_o<=pc_jump_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			loaddata_mem_wb_o<='d0;
		else
			loaddata_mem_wb_o<=loaddata_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			imme_mem_wb_o<='d0;
		else
			imme_mem_wb_o<=imme_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			pc_order_mem_wb_o<='d0;
		else
			pc_order_mem_wb_o<=pc_order_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			Rd_mem_wb_o<=5'd0;
		else
			Rd_mem_wb_o<=Rd_mem_wb_i;
	end
	
	
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			jal_mem_wb_o<='d0;
		else
			jal_mem_wb_o<=jal_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			jalr_mem_wb_o<='d0;
		else
			jalr_mem_wb_o<=jalr_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			lui_mem_wb_o<='d0;
		else
			lui_mem_wb_o<=lui_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			U_type_mem_wb_o<='d0;
		else
			U_type_mem_wb_o<=U_type_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			MemtoReg_mem_wb_o<='d0;
		else
			MemtoReg_mem_wb_o<=MemtoReg_mem_wb_i;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			RegWrite_mem_wb_o<='d0;
		else
			RegWrite_mem_wb_o<=RegWrite_mem_wb_i;
	end
	
	

endmodule

