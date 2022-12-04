`timescale 1ns/1ns
module PC
    (
        input               clk,
        input               rst_n,
        input      [31:0]   pc_new,
        output reg [31:0]   pc_out
    );
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			pc_out <= 0;
		else
			pc_out <= pc_new;
	end	

endmodule

