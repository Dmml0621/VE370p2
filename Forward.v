module Forward(
    input[4:0] EX_MEM_Dst,
    input[4:0] MEM_WB_Dst,
    input[4:0] ID_EX_Rs,
    input[4:0] ID_EX_Rt,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg[1:0] ForwardA,
    output reg [1:0] ForwardB,
    output reg ForwardC,ForwardD
);

initial begin
	ForwardA = 2'b0;
	ForwardB = 2'b0;
	ForwardC = 1'b0;
	ForwardD = 1'b0;
end

always @(*)begin
    if (EX_MEM_RegWrite==1 && EX_MEM_Dst!=0 && (EX_MEM_Dst==ID_EX_Rs)) 
		ForwardA=2'b10;
    else if(MEM_WB_RegWrite==1 && MEM_WB_Dst!=0 && (MEM_WB_Dst==ID_EX_Rs)) 
		ForwardA=2'b01;
    else ForwardA=2'b00;
	if (EX_MEM_RegWrite==1 && EX_MEM_Dst!=0 && (EX_MEM_Dst==ID_EX_Rt)) 
		ForwardB=2'b10;
    else if(MEM_WB_RegWrite==1 && MEM_WB_Dst!=0 && (MEM_WB_Dst==ID_EX_Rt))
		ForwardB=2'b01;
    else ForwardB=2'b00;
end

always @ (*) begin
    if(EX_MEM_RegWrite==1 && EX_MEM_Dst!=0 && EX_MEM_Dst==ID_EX_Rs)
		ForwardC=1'b1;
	else 
		ForwardC=1'b0;
	if(EX_MEM_RegWrite==1 && EX_MEM_Dst!=0 && EX_MEM_Dst==ID_EX_Rs)
		ForwardD=1'b1;
	else 
		ForwardD=1'b0;
	
end

endmodule
