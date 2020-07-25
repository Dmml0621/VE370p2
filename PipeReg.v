`ifndef MODULE_PIPEREG
`define MODULE_PIPEREG
`timescale 1ns / 1ps
module PipeReg(clk, flush, write, in, out, ctrlIn, ctrlOut);

    parameter size = 64;
    parameter ctrlSize = 5;
    input clk, flush, write;

    input [size - 1:0] in;
    output [size - 1:0] out;

    input [ctrlSize - 1:0] ctrlIn;
    output [ctrlSize - 1:0] ctrlOut;

    reg [size - 1:0] data;
    reg [ctrlSize - 1:0] ctrl;

    initial begin
        data <= {size{1'b0}};
        ctrl <= {ctrlSize{1'b0}};
    end

    always @(posedge clk) begin
        if (flush) begin
            data <= {size{1'b0}};
            ctrl <= {ctrlSize{1'b0}};
        end
        else if (write) begin
            data <= in;
            ctrl <= ctrlIn;
        end
    end

    assign out = data;
    assign ctrlOut = ctrl;

endmodule
`endif