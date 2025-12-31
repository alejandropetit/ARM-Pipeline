/*
 * This module is the Control Unit of ARM pipeline processor
 */ 
module controller(input logic clk, reset,
						input logic [31:12] InstrD,
						input logic [3:0] ALUFlags,
						output logic [1:0] RegSrcD,
						output logic RegWriteW, RegWriteM,
						output logic [1:0] ImmSrcD,
						output logic ALUSrcE,
						output logic [2:0] ALUControlE,
						output logic MemWriteM, MemtoRegW, MemtoRegE, linkW,
						output logic PCSrcW, BranchTakenE, PCWrPending,
						input logic FlushE);
	logic [1:0] FlagWriteD, FlagWriteE;
	logic PCSrcD, RegWriteD, MemWriteD, MemWriteE, LD, LE, MemtoRegD, ALUSrcD, BranchD;
	logic PCSrcE, RegWriteE, BranchE, linkM, linkEc;
	logic PCSrcM, MemtoRegM;
	logic PCSrcEc, RegWriteEc, MemWriteEc;
	logic [19:0] ReginDEC;
	logic [3:0] CondE, FlagsE, ReginMWC, Flags;
	logic [2:0] ALUControlD;
	logic [4:0] ReginEMC;
	
	

	decoder dec(InstrD[27:26], InstrD[25:20], InstrD[15:12],
					FlagWriteD, PCSrcD, RegWriteD, MemWriteD, LD, BranchD,
					MemtoRegD, ALUSrcD, ImmSrcD, RegSrcD, ALUControlD);
	
	assign ReginDEC = {FlagWriteD, PCSrcD, RegWriteD, MemWriteD,
					MemtoRegD, ALUSrcD, ALUControlD, InstrD[31:28], Flags, BranchD,LD};
	
	flopclr #(20) RegDEC(clk, reset, FlushE, ReginDEC, {FlagWriteE, PCSrcE, RegWriteE, MemWriteE,
					MemtoRegE, ALUSrcE, ALUControlE, CondE, FlagsE, BranchE,LE});//para agregar los flush y enables cambiar el flop			
	
	condlogic cl(clk, reset, CondE, ALUFlags, FlagsE,
					FlagWriteE, PCSrcE, RegWriteE, MemWriteE, LE, BranchE, Flags,
					PCSrcEc, RegWriteEc, BranchTakenE, MemWriteEc, linkEc);

					
	assign ReginEMC = {PCSrcEc, RegWriteEc, MemWriteEc, MemtoRegE, linkEc};
	
	flopr #(5) RegEMC(clk, reset, ReginEMC, {PCSrcM, RegWriteM, MemWriteM, MemtoRegM, linkM});
	
	assign ReginMWC = {PCSrcM, RegWriteM, MemtoRegM, linkM};
	
	flopr #(4) RegMWC(clk, reset, ReginMWC, {PCSrcW, RegWriteW, MemtoRegW, linkW});
	
	assign PCWrPending =  PCSrcD | PCSrcE | PCSrcM;

	
endmodule
