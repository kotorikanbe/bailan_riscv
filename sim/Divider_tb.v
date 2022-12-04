`timescale 1ns/1ns
module Divider_tb (

);
reg [31:0]    a;
reg [31:0]    b;
reg           clk=0;
wire [31:0]   q;
wire [31:0]   r;
initial begin
    while (1) begin
        #1
        clk=~clk;
    end
end
initial begin
    while (1) begin
        a=$random;
        b=$random & 32'h0000ffff;
        #100;
    end
end
Divider u_divider
    (
        .dividend     (a),
        .divisor      (b),
        .quotient     (q),
        .remainder    (r),
        .clk          (clk)
    );
endmodule //Divider_tb