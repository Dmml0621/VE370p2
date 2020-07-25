`ifndef MODULE_COMPARISON
`define MODULE_COMPARISON
`timescale 1ns / 1ps

module Comparison(
    in0, in1, out
);

    parameter size = 32;
    input [size - 1:0] in0, in1;
    output out;
    assign out = (in0 == in1);

endmodule
`endif