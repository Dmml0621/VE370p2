module DataMem(Address, WriteData, ReadData, MemRead, MemWrite, clk);
    input [31:0] Address, WriteData;
    input MemRead, MemWrite, clk;
    output [31:0] ReadData;
    reg [31:0] memory [0:31];
    wire [31:0] index;
    assign index = Address >> 2;
    integer i;
    initial begin
      for (i = 0; i < 32; i = i + 1) begin
        memory[i] <= 32'b0;
      end
    end
    always @ (posedge clk) begin
      if (MemWrite == 1'b1) begin
        memory[index] = WriteData;
      end
    end
    assign ReadData = (MemRead == 1'b0) ? 32'b0 : memory[index];
endmodule
