`ifndef MODULE_SHIFT2
`define MODULE_SHIFT2
`timescale 1ns / 1ps

module Shift2(
    in, out
);

    input [31:0] in;
    output [31:0] out;
    assign out = {in[29:0], 2'b00};

endmodule
`endif