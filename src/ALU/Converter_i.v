`timescale 1ns/1ns
module  Converter_i 
    (
        input [4:0]          opcode,
        input [31:0]         operator_1,
        input [31:0]         operator_2,
        output reg [31:0]    operator_1_c,
        output reg [31:0]    operator_2_c
    );
        reg [31:0]           signed_operator;
        wire [31:0]          operated_operator;
        wire                 C;
        always @(*) begin
            case (opcode)
                5'b00001: begin
                    operator_1_c = operator_1;
                    signed_operator = ~operator_2;
                    operator_2_c = operated_operator;
                end
                5'b00010: begin
                    if(operator_1[31]) begin
                        signed_operator = ~operator_1;
                        operator_1_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        signed_operator = ~operator_2;
                        operator_2_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_2_c = operator_1;
                    end
                end
                5'b00011: begin
                    if(operator_1[31]) begin
                        signed_operator = ~operator_1;
                        operator_1_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        signed_operator = ~operator_2;
                        operator_2_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_2_c = operator_1;
                    end
                end
                5'b00100: begin
                    if(operator_1[31]) begin
                        signed_operator = ~operator_1;
                        operator_1_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_1_c = operator_1;
                    end
                    operator_2_c = operator_2;
                end
                5'b00110: begin
                    if(operator_1[31]) begin
                        signed_operator = ~operator_1;
                        operator_1_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        signed_operator = ~operator_2;
                        operator_2_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_2_c = operator_1;
                    end
                end
                5'b01000: begin
                    if(operator_1[31]) begin
                        signed_operator = ~operator_1;
                        operator_1_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        signed_operator = ~operator_2;
                        operator_2_c = operated_operator;
                    end
                    else begin
                        signed_operator = 32'b0;
                        operator_2_c = operator_1;
                    end
                end
                5'b10001: begin
                    if(!(operator_1[31] || operator_2[31]))begin
                        signed_operator = ~operator_1;
                        operator_1_c = operated_operator;
                        operator_2_c = operator_2;
                    end
                    else if(operator_1[31] && operator_2[31])begin
                        signed_operator = ~{1'b0 , operator_1[30:0]};
                        operator_1_c = operated_operator;
                        operator_2_c = operator_2;
                    end
                    else begin
                        operator_1_c = operator_1;
                        operator_2_c = operator_2;
                        signed_operator = 32'b0;
                    end
                end
                5'b10010: begin
                    signed_operator = ~operator_1;
                    operator_1_c = operated_operator;
                    operator_2_c = operator_2;
                end
                default: begin
                    operator_1_c = operator_1;
                    operator_2_c = operator_2;
                    signed_operator = 32'b0;
                end
            endcase
        end
        Thirty_two_bit_adder u_thirty_two_bit_adder1
            (
                .operator_1    (32'b0),
                .operator_2    (signed_operator),
                .operator_3    (1'b1),
                .answer        (operated_operator),
                .C             (C)
            );
endmodule //converter_i