/*
 * This module is the Datapath Unit of the ARM single-cycle processor
 */ 
module datapath(input logic clk, reset,
					 input logic [1:0] RegSrc,
					 input logic RegWrite, link,
					 input logic [1:0] ImmSrc,
					 input logic ALUSrc,
					 input logic [2:0] ALUControl,
					 input logic MemtoReg,
					 input logic PCSrc,
					 output logic [3:0] ALUFlags,
					 output logic [31:0] PCF, PCPlus4F,
					 input logic [31:0] PCPlus4D,InstrD,
					 output logic [31:0] ALUOutM, WriteDataM,//ALUResultM, WriteDataM,
					 input logic [31:0] ReadDataM,
					 output logic [4:0] match,
					 input logic [1:0] ForwardAE, ForwardBE,
					 input logic StallF, FlushE, BranchTakenE);
	// Internal signals
	logic [31:0] PCNext;
	logic [31:0] ExtImmD, ExtImmE, SrcAE, SrcBE, ResultW;
	logic [31:0] WriteDataE;
	logic [31:0] ALUResultE, ALUOutW, ReadDataW;
	logic [31:0] Wt, PCPlus4E, PCPlus4M, PCPlus4W, shifted, PCResult;
	logic [146:0] ReginDE;
	logic [99:0] ReginEM, ReginMW;
	logic [6:0] shiftE;
	logic [31:0] RD1D, RD2D, RD1E, RD2E;
	logic [3:0] RA1E, RA2E;
   logic match_1e_m, match_2e_m, match_1e_w, match_2e_w, match_12d_e;
	
	
	//logic [31:0] shifted, strite;
	logic [3:0] RA1D, RA2D, WA3W, WA3E, WA3M, WA3;
	
	// next PC logic
	mux2 #(32) pcmux(PCPlus4F, ResultW, PCSrc, PCResult);
	mux2 #(32) pcmux2(PCResult, ALUResultE, BranchTakenE, PCNext);
	flopenr #(32) pcreg(clk, reset, ~StallF, PCNext, PCF);
	adder #(32) pcadd(PCF, 32'b100, PCPlus4F);
	
	
	// register file logic
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1D);
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2D);
	regfile rf(~clk, RegWrite, RA1D, RA2D, WA3, Wt, PCPlus4F, RD1D, RD2D);
	extend ext (InstrD[23:0], ImmSrc, ExtImmD);
	
	
	assign ReginDE = {RD1D, RD2D, RA1D, RA2D, InstrD[15:12], ExtImmD, PCPlus4D, InstrD[11:5]};
	flopclr #(147) RegDE(clk, reset, FlushE, ReginDE, {RD1E, RD2E, RA1E, RA2E, WA3E, ExtImmE, PCPlus4E, shiftE} );//para agregar los flush y enables cambiar el flop
	mux3 #(32) muxFA(RD1E, ResultW, ALUOutM, ForwardAE, SrcAE);
	mux3 #(32) muxFB(RD2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
	
	shifter shf(shiftE[6:2],shiftE[1:0], WriteDataE, shifted);
	mux2 #(32) srcbmux(shifted, ExtImmE, ALUSrc, SrcBE);
	alu #(32) alu(SrcAE, SrcBE, ALUControl, ALUResultE, ALUFlags);
	
	assign ReginEM = {ALUResultE, WriteDataE, WA3E, PCPlus4E};
	flopr #(100) RegEM(clk, reset, ReginEM, {ALUOutM, WriteDataM, WA3M, PCPlus4M});
	
	assign ReginMW = {ALUOutM, ReadDataM, WA3M, PCPlus4M};
	flopr #(100) RegMW(clk, reset, ReginMW, {ALUOutW, ReadDataW, WA3W, PCPlus4W});	
	
	mux2 #(4) pwmux(WA3W, 4'b1110, link, WA3);
	mux2 #(32) wmux(ResultW, PCPlus4W, link, Wt);
	mux2 #(32) resmux(ALUOutW, ReadDataW, MemtoReg, ResultW);
	
	assign match_1e_m = (RA1E == WA3M);
	assign match_2e_m = (RA2E == WA3M);
	assign match_1e_w = (RA1E == WA3W);
	assign match_2e_w = (RA2E == WA3W);
	assign match_12d_e = (RA1D == WA3E) | (RA2D == WA3E);
	assign match = {match_1e_m, match_2e_m, match_1e_w, match_2e_w, match_12d_e};
	
	

endmodule