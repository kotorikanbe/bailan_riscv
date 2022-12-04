`timescale 1ns/1ns
module Mux
    (
        input [31:0]    data1_i,
        input [31:0]    data2_i,
        input           sel_i,
        input [31:0]    dat_o
    );
	
	    assign  dat_o = sel_i ? data1_i : data2_i;

endmodule
