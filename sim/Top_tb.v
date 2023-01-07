module Top_tb ();
        reg                   clk;
        reg                   rst_n;
        wire                   ps2_clk;
        wire                   ps2_data;

        wire  [3:0]           vga_o_red;
        wire  [3:0]           vga_o_blue;
        wire  [3:0]           vga_o_green;
        wire                  h_sync;
        wire                  v_sync;

    Riscv_top riscv_top(clk,rst_n,ps2_clk,ps2_data,vga_o_red,vga_o_blue,vga_o_green,h_sync,v_sync);

    always #5 clk=~clk;
    initial begin
        rst_n = 0; clk = 0;
        #3 rst_n =1;
    end



    

endmodule