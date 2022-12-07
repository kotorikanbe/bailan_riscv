`timescale 1ns/1ns
module Clkdiv_tb ();
    reg clk;
    wire clk_alu;

    always #5 clk = ~clk;

    Clkdiv clkdiv(.clk_100M(clk),.clk_alu(clk_alu));

    initial begin
        clk = 0;
    end

    
endmodule