`timescale 1ns/1ns
module ALU_tb 
(
    
);
reg [31:0]     operator_1;
reg [31:0]     operator_2;
reg [4:0]      opcode = 0;
reg            clk = 0;
reg            clk_alu = 0;
reg            clk_mul = 0;
wire [31:0]    answer;
initial begin
    while (1) begin
        #5
        clk = ~clk;
    end
end
initial begin
    while (1) begin
        #500
        clk_alu = ~clk_alu;
    end
end
initial begin
    while (1) begin
        #100
        clk_mul = ~clk_mul;
    end
end
initial begin
    #1250;
    while (1) begin
        operator_1 = $random;
        if((opcode >= 5)&&(opcode< 9))begin
            operator_2 = $random & 32'h0000ffff;
        end
        else begin
            operator_2 = $random;
        end
        if(opcode < 5'b10010)begin
            opcode = opcode + 1;
        end
        else begin
            opcode = 0;
        end
            
        #1000 ;
    end
end
ALU u_alu
    (
        .operator_1    (operator_1),
        .operator_2    (operator_2),
        .opcode        (opcode),
        .clk           (clk),
        .clk_alu       (clk_alu),
        .answer        (answer)
    );
endmodule //ALU_tb