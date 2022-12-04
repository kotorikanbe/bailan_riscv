`timescale 1ns/1ns
module ALU_tb 
(
    
);
reg [31:0]     operator_1;
reg [31:0]     operator_2;
reg [5:0]      opcode = 0;
reg            clk = 0;
wire [31:0]    answer;
initial begin
    while (1) begin
        #5
        clk = ~clk;
    end
end
initial begin
    while (1) begin
        operator_1 = $random;
        operator_2 = $random;
        if(opcode < 5'b10001)begin
            opcode = opcode + 1;
        end
        else begin
            opcode = 0;
        end
            
        #200 ;
    end
end
ALU u_alu
    (
        .operator_1    (operator_1),
        .operator_2    (operator_2),
        .opcode        (opcode),
        .clk           (clk),
        .answer        (answer)
    );
endmodule //ALU_tb