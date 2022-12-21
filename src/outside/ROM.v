`timescale 1ns/1ns
module ROM
    (
        input               clk,
	    input      [10:0]   addr,
	    output     [31:0]   inst
    );
	
        ROM_core rom_core(
                        .clka(clk),
                        .addra(addr),
                        .douta(inst)
                        );


endmodule