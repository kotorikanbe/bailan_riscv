`timescale 1ns/1ns
module Clkdiv_origin
    #(
        parameter     div10 = 10,
        parameter     div6 = 6,
        parameter     div7 = 7,
        parameter     div8 = 8,
        parameter     div1 = 1,
        parameter     div9 = 9,
        parameter     div0 = 0,
        parameter     div2 = 2,
        parameter     div3 = 3
    )
   (
        input         clk_100M,
        input         rst_n,
        input         alu_complete,
        output reg    clk_alu,
        output reg    clk_fetch,
        output reg    clk_ram,
        output reg    clk_reg,
        output reg    clk_ctl_mul_div

    );  
        reg [10:0]    count1, count2, count3, count4, count5;

        

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
                    if (count1 > div3 && count1 < div6) begin
                        count1 <= count1 + 1;
                        clk_alu <= 1;
                    end
                    else if ((count1 >= div6 && count1 <= div10) ||
                            (count1 >= 0 && count1 <= div3)) begin
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
                    if (count2 < div0) begin
                        count2 <= count2 + 1;
                        clk_fetch <= clk_fetch;
                    end
                    else if ((count2 >= div0 && count2 < div1)||
                             (count2 >= div2 && count2 < div3) ) begin
                        clk_fetch <= 1;
                        count2 <= count2 + 1; 
                    end 
                    else if ((count2 >= div1 && count2 < div2)||
                             (count2 >= div3 && count2 <= div10) ) begin
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
                clk_ram <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count5 <= count5;
                    clk_ram <= clk_ram;
                end
                else begin
                    if (count5 <= div6) begin
                        count5 <= count5 + 1;
                        clk_ram <= clk_ram;
                    end
                    else if ((count5 > div6 && count5 <= div7)||
                             (count5 > div8 && count5 <= div9) ) begin
                        clk_ram <= 1;
                        count5 <= count5 + 1; 
                    end 
                    else if ((count5 > div7 && count5 <= div8)||
                             (count5 > div9 && count5 <= div10) ) begin
                        clk_ram <= 0;
                        count5 <= count5 + 1; 
                    end 
                    else begin
                        clk_ram <= 0;
                        count5 <= 0;
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
                    if (count3 > (div3 + 1) && count3 < div6) begin
                        count3 <= count3 + 1;
                        clk_ctl_mul_div <= 1;
                    end
                    else if ((count3 >= div6 && count3 <= div10) ||
                            (count3 >= 0 && count3 <= (div3+1))) begin
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