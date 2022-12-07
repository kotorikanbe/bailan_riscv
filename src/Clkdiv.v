`timescale 1ns/1ns
module Clkdiv
    #(
        parameter     N = 9999_9999,
        parameter     div1 = 100,
        parameter     div2 = 95,
        parameter     div3 = 100,
        parameter     div4 = 50
    )
    (
        input         clk_100M,
        output reg    clk_alu, //1MHz
        output reg    clk_1M
    );  
        reg [31:0]    count1 ,count2;
        
        initial begin
            count1 = 0;
            clk_alu = 1;
            clk_1M = 1;
        end

        always @(posedge clk_100M) begin
            if (count1 < div2) begin
                count1 <= count1 + 1;
            end
            else if (count1 >= div2 && count1 <= div1 ) begin
                clk_alu <= 0;
                count1 <= count1 + 1; 
            end 
            else begin
                clk_alu <= 1;
                count1 <= 0;
            end
        end

        always @(posedge clk_100M) begin
            if (count2 < div4) begin
                count2 <= count2 + 1;
            end
            else if (count2 >= div4 && count2 <= div3 ) begin
                clk_1M <= 0;
                count2 <= count2 + 1; 
            end 
            else begin
                clk_1M <= 1;
                count2 <= 0;
            end
        end
        

    
endmodule