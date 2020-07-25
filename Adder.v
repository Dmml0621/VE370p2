`ifndef MODULE_ADDER
`define MODULE_ADDER
`timescale 1ns / 1ps

module Adder(
    in0, in1, out
);

    parameter size = 32;
    input [size - 1:0] in0, in1;
    output [size - 1:0] out;
    assign out = in0 + in1;

endmodule
`endif