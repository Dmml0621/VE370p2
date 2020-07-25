`include "ALU.v"
`include "ALUControl.v"
`include "Control.v"
`include "DataMem.v"
`include "InstructionMem.v"
`include "MUX.v"
`include "RegisterFile.v"
`include "SignExtend.v"
`include "PC.v"

module SingleCycle(clk);
    input clk;
    //control signal
    wire RegDst, Jump, BranchEq, BranchNeq, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    //PC
    wire [31:0] PC_in, PC_out, JumpAddress, Add4Address, NextAddress;
    //IM
    wire [31:0] IM_Instruction;
    //registers
    wire [31:0] Register_ReadData1, Register_ReadData2, Register_WriteData;
    wire [4:0] Register_WriteRegister;
    //sign extend
    wire [31:0] SignExtend_out;
    //ALUcontrol
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;
    //ALU
    wire [31:0] ALU_rt, ALUOut;
    wire ALU_zero;
    //memory
    wire [31:0] DM_ReadData;

    //MUXS(in1, in2, sel, out)
    assign Add4Address = PC_out + 4;
    assign JumpAddress = {Add4Address[31:28], IM_Instruction[25:0], 2'b0};
    MUX mux_branch(Add4Address, Add4Address + SignExtend_out << 2, 
        (BranchEq & ALU_zero) | (BranchNeq & ~ALU_zero), NextAddress);
    MUX mux_next(NextAddress, JumpAddress, Jump, PC_in);
    MUX mux_writereg(IM_Instruction[20:16], IM_Instruction[15:11], 
        RegDst, Register_WriteRegister);
    MUX mux_ALUin2(Register_ReadData2, SignExtend_out, ALUSrc, ALU_rt);
    MUX mux_writeback(ALUOut, DM_ReadData, MemtoReg, Register_WriteData);
    //PC(clk, in, out)
    PC pc(clk, PC_in, PC_out);
    //InstructionMem(ReadAddress, Instruction)
    InstructionMem im(PC_out, IM_Instruction);
    //Control(Op, RegDst, Jump, BranchEq, BranchNeq, MemRead, 
    //  MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp)
    Control control(IM_Instruction[31:26], RegDst, Jump, BranchEq, 
        BranchNeq, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);
    //RegisterFile(ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2, RegWrite, clk)
    RegisterFile regfile(IM_Instruction[25:21], IM_Instruction[20:16], 
        Register_WriteRegister, Register_WriteData, 
        Register_ReadData1, Register_ReadData2, RegWrite, clk);  
    //SignExtend(in, out)
    SignExtend signext(IM_Instruction[15:0], SignExtend_out);
    //ALUControl (ALUOp, FuncCode, ALUControl)
    ALUControl alucontrol(ALUOp, IM_Instruction[5:0], ALUControl);
    //ALU(ALUControl, rs, rt, ALUOut, zero)
    ALU alu(ALUControl, Register_ReadData1, ALU_rt, ALUOut, ALU_zero);
    //DataMem(Address, WriteData, ReadData, MemRead, MemWrite, clk)
    DataMem datamemory(ALUOut, Register_ReadData2, 
        DM_ReadData, MemRead, MemWrite, clk);
endmodule
