`timescale 1ns/1ns
module Converter_o  
    (
        input                operator_1,
        input                operator_2,
        input [4:0]          opcode,
        input [31:0]         adder_o,
        input [63:0]         multiplier_o,
        input [31:0]         divider_q_o,//商
        input [31:0]         divider_r_o,//余数
        input [31:0]         and_o,
        input [31:0]         or_o,
        input [31:0]         xor_o,
        input [31:0]         nor_o,
        input [31:0]         l_shifter_o,
        input [31:0]         r_shifter_o,
        input [31:0]         r_a_shifter_o,
        output reg [31:0]    ALU_o
    );
        reg [31:0]           signed_operator;
        wire [31:0]          operated_operator;
        wire                 C;
        always @(*) begin
            case (opcode)
                5'b00000: begin
                    ALU_o = adder_o;
                    signed_operator = 32'b0;
                end
                5'b00001: begin
                    ALU_o = adder_o;
                    signed_operator = 32'b0;
                end
                5'b00010: begin
                    if(operator_1 ^ operator_2)begin
                        signed_operator = ~multiplier_o[31:0];
                        ALU_o = operated_operator;
                    end
                    else begin
                        ALU_o = multiplier_o[31:0];
                        signed_operator = 32'b0;
                    end
                end
                5'b00011: begin
                    if(operator_1 ^ operator_2)begin
                        signed_operator = ~multiplier_o[31:0];
                        ALU_o = C + ~multiplier_o[63:32];
                    end
                    else begin
                        ALU_o = multiplier_o[63:32];
                        signed_operator = 32'b0;
                    end
                end
                5'b00100: begin
                    if(operator_1)begin
                        signed_operator = ~multiplier_o[31:0];
                        ALU_o = C + ~multiplier_o[63:32];
                    end
                    else begin
                        ALU_o = multiplier_o[63:32];
                        signed_operator = 32'b0;
                    end
                end
                5'b00101: begin
                    ALU_o = multiplier_o[63:32];
                    signed_operator = 32'b0;
                end
                5'b00110: begin
                    if(operator_1 ^ operator_2)begin
                        signed_operator = ~divider_q_o[31:0];
                        ALU_o = operated_operator;
                    end
                    else begin
                        ALU_o = divider_q_o;
                        signed_operator = 32'b0;
                    end
                end
                5'b00111: begin
                    ALU_o = divider_q_o;
                    signed_operator = 32'b0;
                end
                5'b01000: begin
                    ALU_o = divider_r_o;
                    signed_operator = 32'b0;
                end
                5'b01001: begin
                    ALU_o = divider_r_o;
                    signed_operator = 32'b0;
                end
                5'b01010: begin
                    ALU_o = and_o;
                    signed_operator = 32'b0;
                end
                5'b01011: begin
                    ALU_o = or_o;
                    signed_operator = 32'b0;
                end
                5'b01100: begin
                    ALU_o = xor_o;
                    signed_operator = 32'b0;
                end
                5'b01101: begin
                    ALU_o = nor_o;
                    signed_operator = 32'b0;
                end
                5'b01110: begin
                    ALU_o = l_shifter_o;
                    signed_operator = 32'b0;
                end
                5'b01111: begin
                    ALU_o = r_shifter_o;
                    signed_operator = 32'b0;
                end
                5'b10000: begin
                    ALU_o = r_a_shifter_o;
                    signed_operator = 32'b0;
                end
                5'b10001: begin
                    case ({operator_1,operator_2})
                        2'b00: begin
                            if(adder_o[31]) begin
                                ALU_o = 32'b0;
                            end
                            else begin
                                ALU_o = 32'hffffffff;
                            end
                            signed_operator = 32'b0;
                        end
                        2'b10: begin
                            ALU_o = 32'hffffffff;
                            signed_operator = 32'b0;
                        end
                        2'b01: begin
                            ALU_o = 32'b0;
                            signed_operator = 32'b0;
                        end
                        2'b11: begin
                            if(adder_o[31]) begin
                                ALU_o = 32'b0;
                            end
                            else begin
                                ALU_o = 32'hffffffff;
                            end
                            signed_operator = 32'b0;
                        end
                        default: begin
                            ALU_o = 32'b0;
                            signed_operator = 32'b0;
                        end
                    endcase
                end
                5'b10010: begin
                    if(adder_o[31]) begin
                                ALU_o = 32'b0;
                            end
                            else begin
                                ALU_o = 32'hffffffff;
                            end
                            signed_operator = 32'b0;
                end
                default: begin
                            ALU_o = 32'b0;
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
endmodule //Converter_o