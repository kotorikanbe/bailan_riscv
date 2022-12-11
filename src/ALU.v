//他真的必须全部大写，不是我不想按照规则
`timescale 1ns/1ns
module  ALU 
    (
        input [31:0]         operator_1,
        input [31:0]         operator_2,
        input [4:0]          opcode,
        input                clk,
        input                clk_alu,
        //input                clk_mul,
        output reg [31:0]    answer,
        output reg           complete_signal
    );
        wire [31:0]      operator_1_c;
        wire [31:0]      operator_2_c;
        wire [31:0]      adder_o;
        wire [63:0]      multiplier_o;
        wire [31:0]      divider_q_o;//商
        wire [31:0]      divider_r_o;//余数
        wire [31:0]      and_o;
        wire [31:0]      or_o;
        wire [31:0]      xor_o;
        wire [31:0]      nor_o;
        wire [31:0]      l_shifter_o;
        wire [31:0]      r_shifter_o;
        wire [31:0]      r_a_shifter_o;
        wire [31:0]      ALU_o;
        wire             clk_mul;
        wire             C;    
        wire             clk_div;
        wire             complete_signal_mul;
        wire             complete_signal_div;
        // wire             clk_alu;
        // reg [31:0]       operator_1_c_mul;
        // reg [31:0]       operator_2_c_mul;
        // reg [31:0]       operator_1_c_div;
        reg [31:0]       operator_2_c_div;
        reg [31:0]       operator_1_r;
        reg [31:0]       operator_2_r;
        reg [4:0]        opcode_r;
        assign           and_o = operator_1_c & operator_2_c;
        assign           or_o = operator_1_c | operator_2_c;
        assign           xor_o = operator_1_c ^ operator_2_c;
        assign           nor_o = ~or_o;
        // always @(*) begin
        //     if((opcode_r >= 5'b00010) && (opcode_r <= 5'b00101))begin
        //         operator_1_c_mul = operator_1_c;
        //         operator_2_c_mul = operator_2_c;
        //     end
        //     else begin
        //         operator_1_c_mul = 32'b0;
        //         operator_2_c_mul = 32'b0;
        //     end
        // end
        // always @(*) begin
        //     if((opcode_r >= 5'b00110) && (opcode_r <= 5'b01001))begin
        //         operator_1_c_div = operator_1_c;
        //         operator_2_c_div = operator_2_c;
        //     end
        //     else begin
        //         operator_1_c_div = 32'b0;
        //         operator_2_c_div = 32'b0;
        //     end
        // end
        always @(negedge clk_alu) begin
            case (opcode_r)
                5'b00010: complete_signal <= complete_signal_mul;
                5'b00011: complete_signal <= complete_signal_mul;
                5'b00100: complete_signal <= complete_signal_mul;
                5'b00101: complete_signal <= complete_signal_mul;
                5'b00110: complete_signal <= complete_signal_div;
                5'b00111: complete_signal <= complete_signal_div;
                5'b01000: complete_signal <= complete_signal_div;
                5'b01001: complete_signal <= complete_signal_div;
                default: complete_signal <= 1'b1;
            endcase
        end
        always @(posedge clk_alu) begin
            operator_1_r <= operator_1;
            operator_2_r <= operator_2;
            opcode_r <= opcode;
        end
        always @(posedge clk_alu) begin
            answer <= ALU_o;
        end
        // Clkdiv u_clkdiv
        //     (
        //         .clk_100M(clk),
        //         .rst_n(1'b1),
        //         .clk_alu(clk_alu)
        //     );
        clk_wiz_alu u_clk_wizard
            (
                .clk_out1(clk_div),     // output clk_out1
                .clk_out2(clk_mul),
                .clk_in1(clk)
            );      // input clk_in1
        Converter_o u_converter_o0
            (
                .operator_1       (operator_1_r[31]),
                .operator_2       (operator_2_r[31]),
                .opcode           (opcode_r),
                .adder_o          (adder_o),
                .multiplier_o     (multiplier_o),
                .divider_q_o      (divider_q_o),
                .divider_r_o      (divider_r_o),
                .and_o            (and_o),
                .or_o             (or_o),
                .xor_o            (xor_o),
                .nor_o            (nor_o),
                .l_shifter_o      (l_shifter_o),
                .r_a_shifter_o    (r_a_shifter_o),
                .r_shifter_o      (r_shifter_o),
                .ALU_o            (ALU_o)
            );
        Left_logic_shifter u_left_logic_shifter0
            (
                .operator_1    (operator_1_c),
                .operator_2    (operator_2_c[4:0]),
                .answer        (l_shifter_o)
            );
        Right_logic_shifter u_right_logic_shifter0
            (
                .operator_1    (operator_1_c),
                .operator_2    (operator_2_c[4:0]),
                .answer        (r_shifter_o)
            );
        Right_arithmatic_shifter u_right_arithmatic_shifter0
            (
                .operator_1    (operator_1_c),
                .operator_2    (operator_2_c[4:0]),
                .answer        (r_a_shifter_o)
            );
        Converter_i u_converter_i
            (
                .operator_1      (operator_1_r),
                .operator_2      (operator_2_r),
                .opcode          (opcode_r),
                .operator_1_c    (operator_1_c),
                .operator_2_c    (operator_2_c) 
            );
        Thirty_two_bit_adder u_thirty_two_bit_adder2
            (
                .operator_1    (operator_1_c),
                .operator_2    (operator_2_c),
                .operator_3    (1'b0),
                .answer        (adder_o),
                .C             (C)
            );
        Thirty_two_bit_multiplier u_thirty_two_bit_multiplier0
            (
                .operator_1         (operator_1_c),
                .operator_2         (operator_2_c),
                .clk                (clk_mul),
                .answer             (multiplier_o),
                .complete_signal    (complete_signal_mul)
            );
        /*mult_gen_0 u_alu_mul_ip 
            (
                .CLK     (clk_mul),  // input wire CLK
                .A       (operator_1_c),      // input wire [31 : 0] A
                .B       (operator_2_c),      // input wire [31 : 0] B
                .P       (multiplier_o)      // output wire [63 : 0] P
            );*/
        Divider u_divider0
            (
                .dividend           (operator_1_c),
                .divisor            (operator_2_c),
                .clk                (clk_div),
                .quotient           (divider_q_o),
                .remainder          (divider_r_o),
                .complete_signal    (complete_signal_div)
            );
endmodule //ALU