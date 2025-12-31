/*
 * This module is the Decoder of the Control Unit
 */ 
module decoder(input logic [1:0] Op,
					input logic [5:0] Funct,
					input logic [3:0] Rd,
					output logic [1:0] FlagW,
					output logic PCS, RegW, MemW, L, BranchD,
					output logic MemtoReg, ALUSrc,
					output logic [1:0] ImmSrc, RegSrc,
					output logic [2:0] ALUControl);
	// Internal signals
	logic [10:0] controls;
	logic Branch, ALUOp;

	// Main Decoder
	always_comb
		casex(Op)
											// Data-processing immediate
			2'b00: 	if (Funct[5])	controls = 11'b00001010010;
											// Data-processing register
						else				controls = 11'b00000010010;
											// LDR
			2'b01: 	if (Funct[0])	controls = 11'b00011110000;
											// STR
						else				controls = 11'b10011101000;
											// BL
			2'b10: 	if (Funct[4])	controls = 11'b01101010101;
											// B
						else				controls = 11'b01101000100;	
											// Unimplemented
			default: 					controls = 11'bx;
		endcase
		
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, L} = controls;

	// ALU Decoder
	always_comb
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: ALUControl = 3'b000; // ADD
				4'b0010: ALUControl = 3'b001; // SUB
				4'b0000: ALUControl = 3'b010; // AND
				4'b1100: ALUControl = 3'b011; // ORR
				4'b1101: ALUControl = 3'b100;	//	shifts
				default: ALUControl = 3'bx; // unimplemented
			endcase

			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & (ALUControl == 2'b000 | ALUControl == 2'b001);
		end 
		else begin
			ALUControl = 3'b000; // add for non-DP instructions
			FlagW = 2'b00; // don't update Flags
		end
			
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW);
	assign BranchD = Branch;
endmodule
