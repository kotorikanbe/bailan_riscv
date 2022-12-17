`timescale 1ns/1ns
module Clkdiv
    #(
        parameter     div_100 = 20,
        parameter     div_70 = 11,
        parameter     div_95 = 19,
        parameter     div_5  = 1,
        parameter     div_10 = 2,
        parameter     div_20 = 4,
        parameter     div_30 = 6
    )
    (
        input         clk_100M,
        input         rst_n,
        input         alu_complete,
        output reg    clk_alu, //1MHz
        output reg    clk_fetch,
        output        clk_ram,
        output reg    clk_reg,
        output reg    clk_ctl_mul_div

    );  
        reg [5:0]    count1, count2, count3, count4, count5;
        

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
                    if (count1 > div_30 && count1 < div_70) begin
                        count1 <= count1 + 1;
                        clk_alu <= 1;
                    end
                    else if ((count1 >= div_70 && count1 <= div_100) ||
                            (count1 >= 0 && count1 <= div_30)) begin
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
                    if (count2 < div_5) begin
                        count2 <= count2 + 1;
                        clk_fetch <= clk_fetch;
                    end
                    else if ((count2 >= div_5 && count2 < div_10)||
                             (count2 >= div_20 && count2 < div_30) ) begin
                        clk_fetch <= 1;
                        count2 <= count2 + 1; 
                    end 
                    else if ((count2 >= div_10 && count2 < div_20)||
                             (count2 >= div_30 && count2 <= div_100) ) begin
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
                count5 <= 0;
            end
            else count5 <= count5 + 1;
        end

        assign clk_ram = count5[1];
        //assign clk_mul = count5[4];

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
                    if (count4 <= div_95) begin
                        count4 <= count4 + 1;
                    end
                    else if (count4 > div_95 && count4 <= div_100 ) begin
                        clk_reg <= 1;
                        count4 <= count4 + 1; 
                    end 
                    // else if (count4 > div_85 && count4 <= div_100) begin
                    //     clk_reg <= 0;
                    //     count4 <= count4 + 1; 
                    // end
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
                    if (count3 > (div_30 + 2) && count3 < div_70) begin
                        count3 <= count3 + 1;
                        clk_ctl_mul_div <= 1;
                    end
                    else if ((count3 >= div_70 && count3 <= div_100) ||
                            (count3 >= 0 && count3 <= (div_30+2))) begin
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