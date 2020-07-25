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

`include "main.v"

module Pipltest;
    integer i;
	reg clk;
	main uut (clk);
	
	initial begin
		clk = 0;
		i = 0;
        $dumpfile("TestBenchPipl.vcd");
        $dumpvars(1, uut);
        $display("Pipelined simulation result:");
        $display("==========================================================");
        #760;
        $stop;
	end

    always #10 begin
        $display("Time: %d ns, Clock = %d, PC = 0x%H", i, clk, uut.pcOut);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.rf.registers[16], uut.rf.registers[17], uut.rf.registers[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.rf.registers[19], uut.rf.registers[20], uut.rf.registers[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.rf.registers[22], uut.rf.registers[23], uut.rf.registers[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.rf.registers[9], uut.rf.registers[10], uut.rf.registers[11]);
        $display("[$t4] = 0x%H, [$t5] = 0x%H, [$t6] = 0x%H", uut.rf.registers[12], uut.rf.registers[13], uut.rf.registers[14]);
        $display("[$t7] = 0x%H, [$t8] = 0x%H, [$t9] = 0x%H", uut.rf.registers[15], uut.rf.registers[16], uut.rf.registers[17]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        if (~clk) i = i + 1;
    end
endmodule
