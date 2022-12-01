module Imm_extractor 
    #(
        parameter [6:0]     op_R        = 7'b0110011, //R型指令
        parameter [6:0]     op_I_load   = 7'b0000011, //I型指令的load类
        parameter [6:0]     op_I_jalr   = 7'b1100111, //I型指令的跳转指令
        parameter [6:0]     op_I_cal    = 7'b0010011, //I型指令的计算类指令
        parameter [6:0]     op_S        = 7'b0100011, //S型指令
        parameter [6:0]     op_B        = 7'b1100011, //B型指令
        parameter [6:0]     op_U_lui    = 7'b0110111, //U型指令的lui指令
        parameter [6:0]     op_U_auipc  = 7'b0010111, //U型指令的auipc指令
        parameter [6:0]     op_J        = 7'b1101111  //J型指令
    ) 

    (
        input  [31:0] inst,
        output [31:0] imm
    );

        wire [6:0]  opcode;
        reg [31:0] imm_reg;
        reg [2:0]  funct3;

        assign opcode = inst[6:0];
        assign imm = imm_reg;
    always @(*)
    begin
        case (opcode)

            op_R: 
            begin
                imm_reg = 'd0;
            end

            op_I_load:
            begin
                imm_reg[11:0] = inst[31:20];

                if(imm_reg[11] == 1'b1)
                imm_reg[31:12] = 20'b1111_1111_1111_1111;
                else if(imm_reg[11] == 1'b0)
                imm_reg[31:12] = 20'b0000_0000_0000_0000;
            end

            op_I_jalr:
            begin
                imm_reg[11:0]  = inst[31:20];

                if(imm_reg[11] == 1'b1)
                imm_reg[31:12] = 20'b1111_1111_1111_1111;
                else if(imm_reg[11] == 1'b0)
                imm_reg[31:12] = 20'b0000_0000_0000_0000;
            end

            op_I_cal:
            begin
                imm_reg[11:0]  = inst[31:20];
                imm_reg[31:12] = 20'b0000_0000_0000_0000;
            end

            op_S:
            begin
                imm_reg[4:0]  = inst[11:4];
                imm_reg[11:5] = inst[31:25]; 

                if(imm_reg[11] == 1'b1)
                imm_reg[31:12] = 20'b1111_1111_1111_1111;
                else if(imm_reg[11] == 1'b0)
                imm_reg[31:12] = 20'b0000_0000_0000_0000;
            end

            op_B:
            begin
                imm_reg[4:1]  = inst[11:8];
                imm_reg[10:5] = inst[30:25];
                imm_reg[11]   = inst[7];
                imm_reg[12]   = inst[31];
                imm_reg[0]    = 1'b0;
                if(imm_reg[12] == 1'b1)
                imm_reg[31:13] = 19'b1111_1111_1111_111;
                else if(imm_reg[12] == 1'b0)
                imm_reg[31:13] = 19'b0000_0000_0000_000;
            end

            op_U_lui:
            begin
                imm_reg[31:12] = inst[31:12];
                imm_reg[11:0]  = 12'b0000_0000_0000;
            end

            op_U_auipc:
            begin
                imm_reg[31:12] = inst[31:12];
                imm_reg[11:0]  = 12'b0000_0000_0000;
            end

            op_J:
            begin
                imm_reg[10:1]  = inst[30:21];
                imm_reg[11]    = inst[20];
                imm_reg[19:12] = inst[19:12];
                imm_reg[20]    = inst[31];
                imm_reg[19:0]  = imm_reg[20:1];

                if(imm_reg[19] == 1'b1)
                imm_reg[31:20] = 12'b1111_1111_1111;
                else if(imm_reg[19] == 1'b0)
                imm_reg[31:20] = 12'b0000_0000_0000;
            end

            default: imm_reg[31:0] = 'd0;
        endcase
    end
endmodule