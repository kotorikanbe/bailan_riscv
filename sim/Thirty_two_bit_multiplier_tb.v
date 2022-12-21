`timescale 1ns/1ns
module Thirty_two_bit_multiplier_tb (
);
reg [31:0]     a = 0;
reg [31:0]     b = 0;
wire [63:0]    c;
reg            clk = 0;
initial begin
    while (1) begin
        #5
        clk = ~clk;
    end
end
initial begin
    while (1) begin
        #80
        a = $random;
        b = $random;
    end
end
Thirty_two_bit_multiplier u_thirty_two_bit_multiplier
    (
        .operator_1    (a),
        .operator_2    (b),
        .clk           (clk),
        .answer        (c)
    );
endmodule //Thirty_two_bit_multiplier_tb