module MUX(in1, in2, sel, out);
    parameter size = 32;
    input sel;
    input [size - 1:0] in1, in2;
    output [size - 1:0] out;
    assign out = (sel == 1'b0) ? in1 : in2;
endmodule