`timescale 1ns/1ns
module  Converter_i 
    (
        input [4:0]          opcode,
        input [31:0]         operator_1,
        input [31:0]         operator_2,
        output reg [31:0]    operator_1_c,
        output reg [31:0]    operator_2_c
    );
        always @(*) begin
            case (opcode)
                5'b00001: begin
                    operator_1_c = operator_1;
                    operator_2_c = ~operator_2 + 1;
                end
                5'b00010: begin
                    if(operator_1[31]) begin
                        operator_1_c = ~operator_1 + 1;
                    end
                    else begin
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        operator_2_c = ~operator_2 + 1;
                    end
                    else begin
                        operator_2_c = operator_2;
                    end
                end
                5'b00011: begin
                    if(operator_1[31]) begin
                        operator_1_c = ~operator_1 + 1;
                    end
                    else begin
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        operator_2_c = ~operator_2 + 1;
                    end
                    else begin
                        operator_2_c = operator_2;
                    end
                end
                5'b00100: begin
                    if(operator_1[31]) begin
                        operator_1_c = ~operator_1 + 1;
                    end
                    else begin
                        operator_1_c = operator_1;
                    end
                    operator_2_c = operator_2;
                end
                5'b00110: begin
                    if(operator_1[31]) begin
                        operator_1_c = ~operator_1 + 1;
                    end
                    else begin
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        operator_2_c = ~operator_2 + 1;
                    end
                    else begin
                        operator_2_c = operator_2;
                    end
                end
                5'b01000: begin
                    if(operator_1[31]) begin
                        operator_1_c = ~operator_1 + 1;
                    end
                    else begin
                        operator_1_c = operator_1;
                    end
                    if(operator_2[31]) begin
                        operator_2_c = ~operator_2 + 1;
                    end
                    else begin
                        operator_2_c = operator_2;
                    end
                end
                5'b10001: begin
                    if(!(operator_1[31] || operator_2[31]))begin
                        operator_1_c = ~operator_1 + 1;
                        operator_2_c = operator_2;
                    end
                    else if(operator_1[31] && operator_2[31])begin
                        operator_1_c = ~{1'b0 , operator_1[30:0]} + 1;
                        operator_2_c = {1'b0 , operator_2[30:0]};
                    end
                    else begin
                        operator_1_c = operator_1;
                        operator_2_c = operator_2;
                    end
                end
                5'b10010: begin
                    operator_1_c = ~operator_1 + 1;
                    operator_2_c = operator_2;
                end
                default: begin
                    operator_1_c = operator_1;
                    operator_2_c = operator_2;
                end
            endcase
        end
endmodule //converter_i