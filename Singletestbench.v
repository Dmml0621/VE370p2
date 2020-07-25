`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/06 16:49:41
// Design Name: 
// Module Name: Singletest
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "SingleCycle.v"

module Singletest;
    integer i;
	reg clk;
	SingleCycle uut (clk);
	
	initial begin
		clk = 0;
		i = 0;
        $dumpfile("singleCycle.vcd");
        $dumpvars(1, uut);
        $display("Single cycle simulation result:");
        $display("==========================================================");
        #600;
        $stop;
	end

    always #10 begin
        $display("Time: %d ns, Clock = %d, PC = 0x%H", i, clk, uut.PC_out);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.regfile.registers[16], uut.regfile.registers[17], uut.regfile.registers[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.regfile.registers[19], uut.regfile.registers[20], uut.regfile.registers[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.regfile.registers[22], uut.regfile.registers[23], uut.regfile.registers[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.regfile.registers[9], uut.regfile.registers[10], uut.regfile.registers[11]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        if (~clk) i = i + 1;
    end
endmodule
