module RegisterFile(ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2, RegWrite, clk, switch, ssd_out);
    input RegWrite, clk;
    input [4:0] ReadReg1, ReadReg2, WriteReg, switch;
    input [31:0] WriteData;
    output wire [31:0] ReadData1, ReadData2, ssd_out;
    reg [31:0] registers [0:31];
    integer i;
    initial begin
      for (i = 0; i < 32; i = i + 1) begin
        registers[i] <= 32'b0;
      end
    end
    assign ReadData1 = registers[ReadReg1];
    assign ReadData2 = registers[ReadReg2];
    assign ssd_out = registers[switch];
    always @ (posedge clk) begin
      if (RegWrite == 1'b1) begin
        registers[WriteReg] <= WriteData;
      end
    end
endmodule
