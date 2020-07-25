`timescale 1ns / 1ps

module HazDetection(
    input [4:0] IF_ID_Rt,
    input [4:0] IF_ID_Rs,
    input ID_EX_MemRead,
    input [4:0] ID_EX_Rt,
    input [4:0] ID_EX_Dst,
    input BranchEq,
    input BranchNe,  
    input EXMEM_memread,
    output reg Hazard,
    output reg PCWrite,
    output reg IF_IDWrite
);
initial begin
    Hazard=1'b0;
    PCWrite=1'b0;
    IF_IDWrite=1'b0;
end

always @(*)begin
    if(ID_EX_MemRead && (ID_EX_Rt==IF_ID_Rs || ID_EX_Rt==IF_ID_Rt))
	  begin
	      Hazard=1'b1;
        PCWrite=1'b0;
        IF_IDWrite=1'b0;
	  end
	
    else if((BranchEq || BranchNe) && ID_EX_MemRead && (ID_EX_Rt==IF_ID_Rs || ID_EX_Rt==IF_ID_Rt))
	  begin
	      Hazard=1'b1;
        PCWrite=1'b0;     // branch hazard
        IF_IDWrite=1'b0;
	  end
	
    else if((BranchEq || BranchNe)&& EXMEM_memread && (ID_EX_Rt==IF_ID_Rs || ID_EX_Rt==IF_ID_Rt))
	  begin
	      Hazard=1'b1;
        PCWrite=1'b0;     
        IF_IDWrite=1'b0;
	  end
	  
	else
	  begin
	      Hazard=1'b0;
        PCWrite=1'b1;     
        IF_IDWrite=1'b1;
	  end
end

endmodule
