`timescale 1ns/1ns
module Clkdiv
    #(
        parameter     div10 = 10,
        parameter     div7 = 7,
        parameter     div2 = 2,
        parameter     div9 = 9,
        parameter     div1 = 1,
        parameter     div3 = 3,
        parameter     div4 = 4
    )
   (
        input         clk_100M,
        input         rst_n,
        input         alu_complete,
        output reg    clk_alu,
        output reg    clk_fetch,
        output        clk_ram,
        output reg    clk_reg,
        output reg    clk_ctl_mul_div

    );  
        reg [10:0]    count1, count2, count3, count4;

        assign        clk_ram = clk_100M;
        

        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                count1 <= 0;
                clk_alu <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count1 <= count1;
                    clk_alu <= clk_alu;
                end
                else begin
                    if (count1 > div4 && count1 < div7) begin
                        count1 <= count1 + 1;
                        clk_alu <= 1;
                    end
                    else if ((count1 >= div7 && count1 <= div10) ||
                            (count1 >= 0 && count1 <= div4)) begin
                        clk_alu <= 0;
                        count1 <= count1 + 1; 
                    end 
                    else begin
                        clk_alu <= 0;
                        count1 <= 0;
                    end
                end
            end
        end

         always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                count2 <= 0;
                clk_fetch <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count2 <= count2;
                    clk_fetch <= clk_fetch;
                end
                else begin
                    if (count2 < div1) begin
                        count2 <= count2 + 1;
                        clk_fetch <= clk_fetch;
                    end
                    else if ((count2 >= div1 && count2 < div2)||
                             (count2 >= div3 && count2 < div4) ) begin
                        clk_fetch <= 1;
                        count2 <= count2 + 1; 
                    end 
                    else if ((count2 >= div2 && count2 < div3)||
                             (count2 >= div4 && count2 <= div10) ) begin
                        clk_fetch <= 0;
                        count2 <= count2 + 1; 
                    end 
                    else begin
                        clk_fetch <= 0;
                        count2 <= 0;
                    end
                end
            end
        end


        

        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                count4 <= 0;
                clk_reg <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count4 <= count4;
                    clk_reg <= clk_reg;
                end
                else begin
                    if (count4 <= div9) begin
                        count4 <= count4 + 1;
                    end
                    else if (count4 > div9 && count4 <= div10 ) begin
                        clk_reg <= 1;
                        count4 <= count4 + 1; 
                    end 
                    else begin
                        clk_reg <= 0;
                        count4 <= 0;
                    end
                end
            end
        end

        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                count3 <= 0;
                clk_ctl_mul_div <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count3 <= count3;
                    clk_ctl_mul_div <= clk_ctl_mul_div;
                end
                else begin
                    if (count3 >= (div4 + 1) && count3 < div7) begin
                        count3 <= count3 + 1;
                        clk_ctl_mul_div <= 1;
                    end
                    else if ((count3 >= div7 && count3 <= div10) ||
                            (count3 >= 0 && count3 < (div4+1))) begin
                        clk_ctl_mul_div <= 0;
                        count3 <= count3 + 1; 
                    end 
                    else begin
                        clk_ctl_mul_div <= 0;
                        count3 <= 0;
                    end
                end
            end
        end

     

    
endmodule