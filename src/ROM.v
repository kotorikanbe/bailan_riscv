`timescale 1ns/1ns
module ROM
    (
	    input  [7:0]    addr,
	    output [31:0]   inst
    );
	
	    reg [31:0]      rom[255:0];
	
    //对rom进行初始化
    initial begin
        $readmemb("./instruction_binary.txt", rom);
    end
	
    assign instr = rom[addr];

endmodule