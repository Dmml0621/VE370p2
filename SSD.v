`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 16:35:42
// Design Name: 
// Module Name: SSD
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


module SSD(input clk, pcSwitch,
    input [31:0] num, pc,
    output reg [3:0] anode,
    output reg [6:0] cathode
);
    reg [17:0] cnt;
    parameter shreshold = 200000;
    reg [17:0] cnt;
    reg [3:0] numDisplay;
    
    initial begin
        cathode <= 7'b0000001;
        anode <= 4'b1110;
        numDisplay <= 4'b0;
        cnt <= 18'b0;
    end
    wire [31:0] numSel;
    assign numSel = (pcSwitch==1'b0)? num: pc;
    always @(posedge clk)
    begin
        cnt <= cnt + 1;
        if (cnt == shreshold) begin
            cnt <= 0;
            case(anode)
                4'b0111: begin anode <= 4'b1110; numDisplay <= numSel[3:0]; end
                4'b1110: begin anode <= 4'b1101; numDisplay <= numSel[7:4];end
                4'b1101: begin anode <= 4'b1011; numDisplay <= numSel[11:8]; end
                4'b1011: begin anode <= 4'b0111; numDisplay <= numSel[15:12]; end
                default: begin numDisplay <= 4'b0; end
            endcase
        end
    end

    always @(numDisplay) begin
        case (numDisplay)
            4'b0000: cathode=7'b0000001;
            4'b0001: cathode=7'b1001111;
            4'b0010: cathode=7'b0010010;
            4'b0011: cathode=7'b0000110;
            4'b0100: cathode=7'b1001100;
            4'b0101: cathode=7'b0100100;
            4'b0110: cathode=7'b0100000;
            4'b0111: cathode=7'b0001111;
            4'b1000: cathode=7'b0000000;
            4'b1001: cathode=7'b0000100;
            4'b1010: cathode=7'b0001000;
            4'b1011: cathode=7'b1100000;
            4'b1100: cathode=7'b0110001;
            4'b1101: cathode=7'b1000010;
            4'b1110: cathode=7'b0110000;
            4'b1111: cathode=7'b0111000;
            default: cathode=7'b1111111;
        endcase
    end
    
endmodule 