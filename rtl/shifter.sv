module shifter(input logic [4:0] shamt5,
					input logic [1:0]	sh,
					input logic signed [31:0] Rm,
					output logic signed [31:0] shifted);
		
	always_comb begin
			case (sh)
				2'b00: shifted = Rm << shamt5; //LSL
				2'b01: shifted = Rm >> shamt5; //LSR
				2'b10: shifted = Rm >>> shamt5; //ASR
				2'b11: shifted = (Rm >> shamt5) | (Rm << (32-shamt5)); //ROR
			endcase
	end
endmodule 