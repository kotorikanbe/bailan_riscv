`timescale 1ns/1ns
module clk_wiz_alu_tb (
    
);
reg clk=1'b0;
wire clk_1;
wire clk_2;
wire clk_3;
wire l;
initial begin
    while (1) begin
        #5
        clk = ~clk;
    end
end
clk_wiz_alu instance_name
   (
    // Clock out ports
    .clk_out1(clk_1),     // output clk_out1
    .clk_out2(clk_2),     // output clk_out2
    .clk_out3(clk_3),     // output clk_out3
    // Status and control signals
    .reset(1'b1), // input reset
    .locked(l),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
endmodule //clk_wiz_alu_tb