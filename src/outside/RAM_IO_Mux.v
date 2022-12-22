module RAM_IO_Mux 
   #(
        parameter            ram_addr = 4'h2, 
        parameter            io_addr = 4'h4
    )
    (
        input      [3:0]     addr,
        input      [31:0]    rd_ram_dat,
        input      [31:0]    rd_io_dat,

        input                ram_or_io_wr,

        output reg [31:0]    rd_ram_or_io_dat,
        output reg           ram_wr,
        output reg           io_wr
    );

        always @(*) begin
            case (addr)
                ram_addr: begin
                    rd_ram_or_io_dat  = rd_ram_dat;
                    ram_wr = ram_or_io_wr;
                    io_wr  = 0;
                end
                io_addr: begin
                    rd_ram_or_io_dat = rd_io_dat;
                    io_wr = ram_or_io_wr;
                    ram_wr = 0;
                end
                default: begin
                    rd_ram_or_io_dat  = rd_ram_dat;
                    ram_wr = 0;
                    io_wr  = 0;
                end
            endcase
        end

    
endmodule