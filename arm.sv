/*
 * This module is the ARM 5 stages pipeline processor, 
 * which instantiates the Control and Datapath units
 */ 
module arm(input logic clk, reset,
			  output logic [31:0] PC,
			  input logic [31:0] InstrF,
			  output logic MemWrite,
			  output logic [31:0] ALUResult, WriteData,
			  input logic [31:0] ReadData);

	// Internal signals to interconnect the control and datapath units
	logic [3:0] ALUFlags;
	logic [4:0] match;
	logic RegWriteW, RegWriteM, ALUSrc, MemtoRegW, MemtoRegE, PCSrc, link;
	logic [1:0] RegSrc, ImmSrc;
	logic [2:0] ALUControl;
	logic [31:0] InstrD;
	logic [63:0] ReginFD;
	logic [31:0] PCPlus4F, PCPlus4D;
	logic StallD, StallF, FlushD, FlushE, PCWrPendingF, BranchTakenE;
	logic [1:0] ForwardAE, ForwardBE;
	
	assign ReginFD = {InstrF, PCPlus4F};
	flopclenr #(64) RegFE(clk, reset, ~StallD, FlushD, ReginFD, {InstrD, PCPlus4D});//para agregar los flush y enables cambiar el flop
						
	
	// Control unit instantiation
	controller c(clk, reset, InstrD[31:12], ALUFlags,
						RegSrc, RegWriteW, RegWriteM, ImmSrc,
						ALUSrc, ALUControl,
						MemWrite, MemtoRegW, MemtoRegE, link, PCSrc, BranchTakenE, PCWrPendingF, FlushE);
						
	// Datapath unit instantiation
	datapath dp(clk, reset,
						RegSrc, RegWriteW, link, ImmSrc,
						ALUSrc, ALUControl,
						MemtoRegW, PCSrc,
						ALUFlags, PC, PCPlus4F, PCPlus4D, InstrD,
						ALUResult, WriteData, ReadData, match, ForwardAE, ForwardBE, StallF, FlushE, BranchTakenE);
						
	hazard h(clk, reset, RegWriteM, RegWriteW,
					BranchTakenE, MemtoRegE, PCWrPendingF, PCSrc, match,
					ForwardAE, ForwardBE, StallF, StallD, FlushD, FlushE);
endmodule
