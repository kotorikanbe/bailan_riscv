`timescale 1ns/1ns
module Clkdiv
    #(
        parameter     div0 = 0,
        parameter     div1 = 1,
        parameter     div2 = 2,
        parameter     div3 = 3,
        parameter     div6 = 6,
        parameter     div7 = 7,
        parameter     div8 = 8,
        parameter     div9 = 9,
        parameter     div10 = 10
    )
   (
        input         clk_100M,
        input         rst_n,
        input         alu_complete,
        output reg    clk_alu,
        output reg    clk_fetch,
        output reg    clk_ram,
        output reg    clk_reg,
        output reg    clk_ctl_mul_div //通过控制乘除法器的时钟，使乘除法器在alu读取数据后一段时间再读取数据

    );  
        reg [10:0]    count;

        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                count <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    count <= count;
                end
                else if(count > div10)
                    count <= 0;
                else count <= count + 1;
            end
        end

        
        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                clk_fetch <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    clk_fetch <= clk_fetch;
                end
                else begin
                    if ((count == div0)||(count == div2)) begin
                        clk_fetch <= 1;
                    end 
                    else begin
                        clk_fetch <= 0;
                    end
                end
            end
        end
        

        always @(posedge clk_100M) begin
            if(alu_complete == 0) begin
                clk_alu <= clk_alu;
            end
            else begin
                if (count > div3 && count < div6) begin
                    clk_alu <= 1;
                end
                else begin
                    clk_alu <= 0;
                end
            end
        end


        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                clk_ctl_mul_div <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    clk_ctl_mul_div <= clk_ctl_mul_div;
                end
                else begin
                    if (count >= (div3 + 1) && count < div6) begin
                        clk_ctl_mul_div <= 1;
                    end
                    else begin
                        clk_ctl_mul_div <= 0;
                    end
                end
            end
        end
        


        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                clk_ram <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    clk_ram <= clk_ram;
                end
                else begin
                    if ((count == div7)||(count == div9) ) begin
                        clk_ram <= 1;
                    end 
                    else begin
                        clk_ram <= 0;
                    end
                end
            end
        end

        

        always @(posedge clk_100M or negedge rst_n) begin
            if (rst_n == 0) begin
                clk_reg <= 0;
            end
            else begin
                if(alu_complete == 0) begin
                    clk_reg <= clk_reg;
                end
                else begin
                    if (count == div10) begin
                        clk_reg <= 1;
                    end 
                    else begin
                        clk_reg <= 0;
                    end
                end
            end
        end


        

     

    
endmodule