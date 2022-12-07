`timescale 1ns/1ns
module ROM
    (
	    input  [7:0]    addr,
	    output [31:0]   inst
    );
	
	    reg [31:0]      rom[255:0];
	
    //对rom进行初始�?
    initial begin
        $readmemb("D:/vivado/bailan_riscv/src/instruction_binary.txt", rom);
    end
	
    assign inst = rom[addr];

endmodule