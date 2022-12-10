`timescale 1ns/1ns
module ROM
    (
        input               clk,
	    input      [19:0]    addr,
	    output [31:0]   inst
    );
	
	    reg [31:0]      rom[2048:0];
	
    //?ROM?????
    initial begin
        $readmemh("C:/Users/Winter/Desktop/vivado/cpu/bailan_riscv/src/instruction_binary.txt", rom);
    end
	
    //always @(posedge clk) begin
        assign inst = rom[addr];
    //end
   

endmodule