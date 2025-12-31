/*
 * This module is the Conditional Logic block of the Control Unit
 */ 
module condlogic(input logic clk, reset,
						input logic [3:0] Cond,
						input logic [3:0] ALUFlags, FlagsE,
						input logic [1:0] FlagW,
						input logic PCS, RegW, MemW, L, Branch,
						output logic [3:0] Flags,
						output logic PCSrc, RegWrite, BranchTakenE,
						MemWrite, link);
	// Internal signals
	logic [1:0] FlagWrite;
	//logic [3:0] Flags;
	logic CondEx;

	// Registers to store the ALUFlags when S == 1
	//flopenr #(2)flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
	//flopenr #(2)flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);
	mux2 #(2) flagmux1(FlagsE[3:2], ALUFlags[3:2],FlagWrite[1], Flags[3:2]);
	mux2 #(2) flagmux0(FlagsE[1:0], ALUFlags[1:0],FlagWrite[0], Flags[1:0]);	
	// write controls are conditional
	condcheck cc(Cond, Flags, CondEx);
	assign FlagWrite = FlagW & {2{CondEx}};
	assign RegWrite = RegW & CondEx;
	assign MemWrite = MemW & CondEx;
	assign link = L & CondEx;
	assign PCSrc = (PCS & CondEx);
	assign BranchTakenE = Branch & CondEx;
endmodule

/*
 * This submodule is the Condition Check block of the Conditional Logic block
 */ 
module condcheck(input logic [3:0] Cond,
						input logic [3:0] Flags,
						output logic CondEx);
	// Internal signals
	logic neg, zero, carry, overflow, ge;
	assign {neg, zero, carry, overflow} = Flags;
	assign ge = (neg == overflow);
	// Combinational process to check conditions
	always_comb
		case(Cond)
			4'b0000: CondEx = zero; // EQ
			4'b0001: CondEx = ~zero; // NE
			4'b0010: CondEx = carry; // CS
			4'b0011: CondEx = ~carry; // CC
			4'b0100: CondEx = neg; // MI
			4'b0101: CondEx = ~neg; // PL
			4'b0110: CondEx = overflow; // VS
			4'b0111: CondEx = ~overflow; // VC
			4'b1000: CondEx = carry & ~zero; // HI
			4'b1001: CondEx = ~(carry & ~zero); // LS
			4'b1010: CondEx = ge; // GE
			4'b1011: CondEx = ~ge; // LT
			4'b1100: CondEx = ~zero & ge; // GT
			4'b1101: CondEx = ~(~zero & ge); // LE
			4'b1110: CondEx = 1'b1; // Always
			default: CondEx = 1'bx; // undefined
		endcase
endmodule