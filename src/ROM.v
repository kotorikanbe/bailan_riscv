`timescale 1ns/1ns
module ROM
    (
        input               clk,
	    input      [7:0]    addr,
	    output reg [31:0]   inst
    );
	
	    reg [31:0]      rom[255:0];
	
    //?ROM?????
    initial begin
        $readmemb("D:/vivado/bailan_riscv/src/instruction_binary.txt", rom);
    end
	
    always @(posedge clk) begin
        inst = rom[addr];
    end
   

endmodule