module ALU (ALUControl, rs, rt, ALUOut, zero);
    input [3:0] ALUControl;
    input [31:0] rs, rt;
    output reg [31:0] ALUOut;
    output zero;
    assign zero = (ALUOut == 0);
    always @ (rs, rt, ALUControl) begin
      case (ALUControl)
        4'b0000: 
          ALUOut <= rs & rt;
        4'b0001:
          ALUOut <= rs | rt;
        4'b0010:
          ALUOut <= rs + rt;
        4'b0110:
          ALUOut <= rs - rt;
        4'b0111:
          ALUOut <= (rs < rt) ? 1 : 0;
        4'b1100:
          ALUOut <= ~(rs | rt) ;
        default:
          ALUOut <= 0;
      endcase
    end
endmodule