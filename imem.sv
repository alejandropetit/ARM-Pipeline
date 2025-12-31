/*
 * This module is the Instruction Memory of the ARM pipeline processor
 */ 
module imem(input logic [31:0] a, output logic [31:0] rd);
	// Internal array for the memory (Only 64 32-words)
	logic [31:0] RAM[255:0];

	// The following line loads the program instruction
	initial
		 $readmemh("C:/Users/josea/projects/ARM/imem_made_by_students.dat",RAM);

	assign rd = RAM[a[31:2]]; // word aligned
endmodule