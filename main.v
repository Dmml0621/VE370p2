`ifndef MODULE_MAIN
`define MODULE_MAIN
`timescale 1ns / 1ps
`include "ALU.v"
`include "ALUControl.v"
`include "Control.v"
`include "DataMem.v"
`include "InstructionMem.v"
`include "MUX.v"
`include "PC.v"
`include "RegisterFile.v"
`include "SignExtend.v"
`include "Adder.v"
`include "MUX3.v"
`include "Shift2.v"
`include "Comparison.v"
`include "PipeReg.v"
`include "HazDetection.v"
`include "Forward.v"

module main(clk, switch, regi, pcSSD);
    input clk;
    input [4:0] switch;
    output [31:0] regi, pcSSD;
    wire [31:0] pcAdd4, branchPC, pcIn1, jumpPC, pcIn, pcOut, inst, regPcAdd4, regInst,
        writeData, readData1, readData2, signedImm, branchImm, cmp1, cmp2, regData1,
        regData2, regSignedImm, ALU2A, ALU1, ALU2, ALUOut, regALUOut, regALU2A, memOut,
        regMemOut, WBALUOut;
    wire [27:0] jumpAddr;
    wire [25:0] pseudoAddr;
    wire [15:0] imm;
    wire [7:0] ctrlMUXOut;
    wire [5:0] IDOpcode, EXFunct;
    wire [4:0] IDRt, IDRs, IDRd, EXRs, EXRt, EXRd, EXDst, MEMDst, WBDst;
    wire [3:0] aluCtrl;
    wire [1:0] ALUOp, EXALUOp, forwardA, forwardB;
    wire branch, jump, pcWrite, flush, IFIDWrite, regWrite, clk, forward1, forward2,
        branchCmp, ALUSrc, regDst, hazard, EXALUSrc, EXMemRead, EXMemWrite, EXRegWrite, EXMem2Reg,
        EXRegDst, MEMMemRead, MEMMemWrite, MEMRegWrite, MEMMem2Reg, memRead, memWrite, WBRegWrite,
        WBMem2Reg, branchEq, branchNe, mem2Reg;
    
    assign pcSSD = pcOut;
    Adder add4 (pcOut, 32'h4, pcAdd4);
    MUX muxPC1(pcAdd4, branchPC, branch, pcIn1);
    MUX muxPC2(pcIn1, jumpPC, jump, pcIn);
    PC pc(clk, pcWrite, pcIn, pcOut);
    InstructionMem im(pcOut, inst);

    PipeReg IFID(clk, flush, IFIDWrite, {pcAdd4, inst}, {regPcAdd4, regInst}, , );

    assign {IDOpcode, IDRs, IDRt, IDRd} = regInst[31:11];
    assign imm = regInst[15:0];
    assign pseudoAddr = regInst[25:0];
    assign jumpAddr = {pseudoAddr, 2'b00};
    assign jumpPC = {pcAdd4[31:28], jumpAddr};
    RegisterFile rf(IDRs, IDRt, WBDst, writeData, readData1, readData2, WBRegWrite, clk, switch, regi);
    SignExtend signEx(imm, signedImm);

    Shift2 shift2(signedImm, branchImm);
    Adder adder(branchImm, regPcAdd4, branchPC);
    MUX muxCmp1(readData1, ALUOut, forward1, cmp1);
    MUX muxCmp2(readData2, ALUOut, forward2, cmp2);
    Comparison cmp(cmp1, cmp2, branchCmp);

    MUX #(.size(8)) ctrlMUX({ALUOp, ALUSrc, regDst, memRead, memWrite, regWrite, mem2Reg}, 8'b0, hazard, ctrlMUXOut);

    PipeReg #(.size(111), .ctrlSize(8))
        IDEX(clk, 1'b0, 1'b1, {readData1, readData2, signedImm, IDRs, IDRt, IDRd},
            {regData1, regData2, regSignedImm, EXRs, EXRt, EXRd}, ctrlMUXOut,
            {EXALUOp, EXALUSrc, EXRegDst, EXMemRead, EXMemWrite, EXRegWrite, EXMem2Reg});
    
    assign EXFunct = regSignedImm[5:0];
    MUX3 muxA(regData1, writeData, regALUOut, forwardA, ALU1);
    MUX3 muxB(regData2, writeData, regALUOut, forwardB, ALU2A);
    MUX muxALU(ALU2A, regSignedImm, EXALUSrc, ALU2);
    ALU alu(aluCtrl, ALU1, ALU2, ALUOut, );
    MUX #(.size(5)) muxDst(EXRt, EXRd, EXRegDst, EXDst);

    PipeReg #(.size(69), .ctrlSize(4))
        EXMEM(clk, 1'b0, 1'b1, {ALUOut, ALU2A, EXDst},
            {regALUOut, regALU2A, MEMDst},
            {EXMemRead, EXMemWrite, EXRegWrite, EXMem2Reg},
            {MEMMemRead, MEMMemWrite, MEMRegWrite, MEMMem2Reg});
    
    DataMem dm(regALUOut, regALU2A, memOut, MEMMemRead, MEMMemWrite, clk);

    PipeReg #(.size(69), .ctrlSize(2))
        MEMWB(clk, 1'b0, 1'b1, {memOut, regALUOut, MEMDst},
            {regMemOut, WBALUOut, WBDst}, {MEMRegWrite, MEMMem2Reg}, {WBRegWrite, WBMem2Reg});

    MUX MUXRegWrite(WBALUOut, regMemOut, WBMem2Reg, writeData);
    Control ctrl(IDOpcode, regDst, jump, branchEq, branchNe, memRead, mem2Reg, memWrite, ALUSrc, regWrite, ALUOp);
    assign branch = (branchEq && branchCmp) || (branchNe && !branchCmp);
    assign flush = branch;
    HazDetection hazDetection(IDRt, IDRs, EXMemRead, EXRt, EXRd, branchEq, branchNe, MEMMemRead,
        hazard, pcWrite, IFIDWrite);
    ALUControl aluControl(EXALUOp, EXFunct, aluCtrl);
    Forward forward(MEMDst, WBDst, EXRs, EXRt, MEMRegWrite, WBRegWrite, forwardA, forwardB, forward1, forward2);

endmodule
`endif