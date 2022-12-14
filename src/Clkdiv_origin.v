`timescale 1ns/1ns
module Clkdiv_origin
    #(
        parameter     div1 = 100,
        parameter     div2 = 70,
        parameter     div3 = 50,
        parameter     div4 = 5,
        parameter     div5 = 80,
        parameter     div6 = 90
    )
    (
        input         clk_100M,
        input         rst_n,
        input         alu_complete,
        output reg    clk_alu, //1MHz
        output reg    clk_1M,
        output        clk_ram,
        output reg    clk_reg

    );  
        reg [31:0]    count1, count2, count3, count4;
        

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
                    if (count1 > div4 && count1 < div2) begin
                        count1 <= count1 + 1;
                        clk_alu <= 1;
                    end
                    else if ((count1 >= div2 && count1 <= div1) ||
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
                clk_1M <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count2 <= count2;
                    clk_1M <= clk_1M;
                end
                else begin
                    if (count2 < div3) begin
                        count2 <= count2 + 1;
                        clk_1M <= clk_1M;
                    end
                    else if (count2 >= div3 && count2 <= div1 ) begin
                        clk_1M <= 0;
                        count2 <= count2 + 1; 
                    end 
                    else begin
                        clk_1M <= 1;
                        count2 <= 0;
                    end
                end
            end
        end

        // always @(posedge clk_100M or negedge rst_n) begin
        //     if (rst_n == 0) begin
        //         count3 <= 0;
        //         clk_ram <= 0;
        //     end
        //     else begin
        //         if(alu_complete == 0) begin
        //             count3 <= count3;
        //             clk_ram <= clk_ram;
        //         end
        //         else begin
        //             if (count3 < div5) begin
        //                 count3 <= count3 + 1;
        //             end
        //             else if (count3 >= div5 && count3 <= div1 ) begin
        //                 clk_ram <= 1;
        //                 count3 <= count3 + 1; 
        //             end 
        //             else begin
        //                 clk_ram <= 0;
        //                 count3 <= 0;
        //             end
        //         end
        //     end
        // end

        always @(posedge clk_100M or negedge rst_n) begin
            if(rst_n == 0)
                count3 <= 0;
            else if(alu_complete == 0)
                count3 <= count3;
            else count3 <= count3 + 1;
        end

        assign clk_ram = count3[1];

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
                    if (count4 < div6) begin
                        count4 <= count4 + 1;
                    end
                    else if (count4 >= div6 && count4 <= div1 ) begin
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
        

    
endmodule