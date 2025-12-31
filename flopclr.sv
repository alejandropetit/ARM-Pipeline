/*
 * This module is the Flip Flop con Reset and Enable component
 */ 
module flopclr #(parameter WIDTH = 8)
		 (input logic clk, reset, clr,
		  input logic [WIDTH-1:0] d,
		  output logic [WIDTH-1:0] q);
	always_ff @(posedge clk, posedge reset)
		if (reset) 
			q <= 0;
		else begin
			if (clr) q <= 0;
			else	q <= d;
		end
endmodule