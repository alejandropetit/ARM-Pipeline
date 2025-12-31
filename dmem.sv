/*
 * This module is the Data Memory of the ARM single-cycle processor
 * It corresponds to the RAM array and some external peripherals
 */ 
module dmem(input logic clk, we, button,
				input logic [31:0] a, wd, output logic [31:0] rd,
            input logic [9:0] switches, output logic [9:0] leds,
				output logic [7:0] s6, s5, s4, s3, s2, s1);
	// Internal array for the memory (Only 64 32-words)
	logic [31:0] RAM[63:0];
	logic [23:0] num;	
	logic sign;

	initial
		// Uncomment the following line only if you want to load the required data for the peripherals test
		//$readmemh("dmem_to_test_peripherals.dat",RAM);

		// Uncomment the following line only if you want to load the required data for the program made by your group
		 $readmemh("C:/Users/josea/Downloads/pip-ARM/pip-ARM/dmem_made_by_students.dat",RAM);
	
	// Process for reading from RAM array or peripherals mapped in memory
	// Process for reading from RAM array or peripherals mapped in memory
	always_comb
		if (a == 32'hC000_0000)			// Read from Switches (10-bits)
			//if(switches[9]==0)
				rd = {22'b0, switches};
			//else
				//rd = {22'b1, switches};
		else if (a == 32'hC000_0010)	// Read "enter" Button
			rd = {31'b0, button};
		else									// Reading from 0 to 252 retrieves data from RAM array
			rd = RAM[a[31:2]]; 			// Word aligned (multiple of 4)
	
	// Process for writing to RAM array or peripherals mapped in memory
	always_ff @(posedge clk) begin
		if (we)
			if (a == 32'hC000_0004)	// Write into LEDs (10-bits)
				leds <= wd[9:0];
			else if(a == 32'hC000_0008)
				sign <= wd[0];
			else if(a == 32'hC000_000C)	
				num <= wd[23:0];
			else
				RAM[a[31:2]] <= wd;
	end
	
	displays disp(num, sign, s6, s5, s4, s3, s2, s1);
endmodule