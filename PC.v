module PC (clk, pcWrite, in, out);
    input clk, pcWrite;
    input [31:0] in;
    output reg [31:0] out;
    initial out = 0;
    always @ (posedge clk) begin
      if (pcWrite) out <= in;
    end
endmodule