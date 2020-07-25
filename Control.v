module Control(
    input [5:0] Op,
    output reg RegDst, Jump, BranchEq, BranchNeq, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
);
    always @ (Op) begin
      case (Op)
        //R-type
        6'b000000: begin 
          RegDst <= 1;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 0;
          RegWrite <= 1;
          ALUOp <= 2'b10;
        end
        //I-type
        6'b001000: begin //addi
          RegDst <= 0;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 1;
          RegWrite <= 1;
          ALUOp <= 2'b00;
        end
        6'b001100: begin //andi
          RegDst <= 0;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 1;
          RegWrite <= 1;
          ALUOp <= 2'b11;
        end
        6'b000100: begin //beq
          RegDst <= 1;
          Jump <= 0;
          BranchEq <= 1;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 0;
          RegWrite <= 0;
          ALUOp <= 2'b01;
        end
        6'b000101: begin //bne
          RegDst <= 1;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 1;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 0;
          RegWrite <= 0;
          ALUOp <= 2'b01;
        end
        6'b100011: begin //lw
          RegDst <= 0;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 1;
          MemtoReg <= 1;
          MemWrite <= 0;
          ALUSrc <= 1;
          RegWrite <= 1;
          ALUOp <= 2'b00;
        end
        6'b101011: begin //sw
          RegDst <= 0;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 1;
          ALUSrc <= 1;
          RegWrite <= 0;
          ALUOp <= 2'b00;
        end
        //J-type
        6'b000010: begin //j
          RegDst <= 1;
          Jump <= 1;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 0;
          RegWrite <= 0;
          ALUOp <= 2'b10;
        end
        default: begin 
          RegDst <= 0;
          Jump <= 0;
          BranchEq <= 0;
          BranchNeq <= 0;
          MemRead <= 0;
          MemtoReg <= 0;
          MemWrite <= 0;
          ALUSrc <= 0;
          RegWrite <= 0;
          ALUOp <= 2'b00;
        end
      endcase
    end
endmodule