module RAM_IO_Mux 
   #(
        parameter            ram_addr = 4'h2, 
        parameter            io_addr = 4'h4
    )
    (
        input      [3:0]     addr,
        input      [31:0]    rd_ram_dat,
        input      [31:0]    rd_IO_dat,

        input                wr_en,

        output reg [31:0]    dat_i,
        output reg           ram_wr,
        output reg           io_wr
    );

        always @(*) begin
            case (addr)
                ram_addr: begin
                    dat_i  = rd_ram_dat;
                    ram_wr = wr_en;
                    io_wr  = 0;
                end
                io_addr: begin
                    dat_i = rd_IO_dat;
                    io_wr = wr_en;
                    ram_wr = 0;
                end
                default: begin
                    dat_i  = rd_ram_dat;
                    ram_wr = 0;
                    io_wr  = 0;
                end
            endcase
        end

    
endmodule