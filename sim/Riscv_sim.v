`timescale 1ns / 1ns 
module Riscv_sim ();
    reg         clk = 1'b0;
    reg         rst_n;
    wire [31:0] data;

initial
begin
rst_n =1'b0;
#5
rst_n =1'b1;
end
initial
while(1)
begin
clk=~clk;
#5;
end

Riscv_top Riscv_top_sim
(
    .clk(clk),
    .rst_n(rst_n),
    .data(data)
);
endmodule