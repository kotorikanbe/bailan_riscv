`timescale 1ns/1ns
module Clkdiv
    #(
        parameter     N = 9999_9999,
        parameter     div1 = 100,
        parameter     div2 = 95
    )
    (
        input         clk_100M,
        output reg    clk_alu //1MHz
    );  
        reg [31:0]    count;
        
        initial begin
            count = 0;
            clk_alu = 0;
        end

        always @(posedge clk_100M) begin
            if (count < div2) begin
                count <= count + 1;
            end
            else if (count >= div2 && count <= div1 ) begin
                clk_alu <= 0;
                count <= count + 1; 
            end 
            else begin
                clk_alu <= 1;
                count <= 0;
            end

            
        end
        

    
endmodule