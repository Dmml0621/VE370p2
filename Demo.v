`timescale 1ns / 1ps

`include "main.v"

module Demo(clk, clk2, switch, pc_switch, cathode, anode);
    integer i;
	input clk, clk2;
	input [4:0] switch;
	wire [31:0] num, pc;
    output [6:0] cathode;
    output [3:0] anode;
    input pc_switch;
	main uut (clk, switch, num, pc);
	SSD ssd(clk2, pc_switch, num, pc, anode, cathode);
	
	initial begin
//		clk = 0;
		i = 0;
        $dumpfile("TestBenchPipl.vcd");
        $dumpvars(1, uut);
        $display("Pipelined simulation result:");
        $display("==========================================================");
        #760;
        $stop;
	end

    always @(posedge clk) begin
        $display("Time: %d ns, PC = 0x%H", i, uut.pcOut);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.rf.registers[16], uut.rf.registers[17], uut.rf.registers[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.rf.registers[19], uut.rf.registers[20], uut.rf.registers[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.rf.registers[22], uut.rf.registers[23], uut.rf.registers[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.rf.registers[9], uut.rf.registers[10], uut.rf.registers[11]);
        
//        clk = ~clk;
        if (~clk) i = i + 1;
    end
endmodule
