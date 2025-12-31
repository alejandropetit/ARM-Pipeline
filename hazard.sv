module hazard(input logic clk, reset, RegWriteM, RegWriteW, 
				  input logic BranchTakenE, MemtoRegE, PCWrPendingF, PCSrcW,
				  input logic [4:0] match, 
				  output logic [1:0] ForwardAE, ForwardBE,
				  output logic StallF, StallD,
				  output logic FlushD, FlushE);

logic ldrStallD;				  
				  
always_comb begin
	if (match[4] & RegWriteM)      ForwardAE = 2'b10;
	else if (match[2] & RegWriteW) ForwardAE = 2'b01;
	else       							 ForwardAE = 2'b00;

	if(match[3] & RegWriteM)       ForwardBE = 2'b10;
	else if (match[1] & RegWriteW) ForwardBE = 2'b01;
	else 									 ForwardBE = 2'b00;
end	

 assign ldrStallD = match[0] & MemtoRegE; 
 
 assign StallD = ldrStallD; 
 assign StallF = ldrStallD | PCWrPendingF; 
 assign FlushE = ldrStallD | BranchTakenE; 
 assign FlushD = PCWrPendingF | PCSrcW | BranchTakenE; 		
endmodule		