`ifndef MODULE_MUX3
`define MODULE_MUX3
`timescale 1ns / 1ps

module MUX3(
    in0, in1, in2, sel, out
);

    parameter size = 32;
    input [size - 1:0] in0, in1, in2;
    input [1:0] sel;
    output [size - 1:0] out;
    assign out = (sel == 2'b0)? in0: (sel == 2'b1)? in1: in2;

endmodule
`endif