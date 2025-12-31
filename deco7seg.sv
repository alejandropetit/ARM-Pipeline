module peripheral_deco7seg(
	input  logic [3:0] D,
	output logic [7:0] SEG
);
 
	always_comb begin
			case(D)				 // gfedcba
				4'b0000: SEG = 8'b01000000; // 0
				4'b0001: SEG = 8'b01111001; // 1
				4'b0010: SEG = 8'b00100100; // 2
				4'b0011: SEG = 8'b00110000; // 3
				4'b0100: SEG = 8'b00011001; // 4
				4'b0101: SEG = 8'b00010010; // 5 
				4'b0110: SEG = 8'b00000010; // 6
				4'b0111: SEG = 8'b01111000; // 7
				4'b1000: SEG = 8'b00000000; // 8
				4'b1001: SEG = 8'b00011000; // 9
				4'b1010: SEG = 8'b00001000; // A
				4'b1011: SEG = 8'b01001000; // n
				4'b1100: SEG = 8'b01111001; // i
				4'b1101: SEG = 8'b00001110; // f
				4'b1110: SEG = 8'b00111111; // -
				4'b1111: SEG = 8'b11111111; // nothing
			endcase

	end
endmodule
