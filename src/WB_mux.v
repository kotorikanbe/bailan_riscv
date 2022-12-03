module WB_mux 
    (
        input      [31:0]   pc_plus4_i,
        input      [31:0]   alu_result_i,
        input      [31:0]   imm_i,
        input      [31:0]   mem_i,
        input      [1:0]    sel_i,
        output reg [31:0]   wb_dat_o       
    );
        always @(*) begin
            case (sel_i)
                0:       wb_dat_o = pc_plus4_i;
                1:       wb_dat_o = alu_result_i;
                2:       wb_dat_o = imm_i;
                3:       wb_dat_o = mem_i;
                default: wb_dat_o = pc_plus4_i;
            endcase
        end


    
endmodule