/*
 * Testbench to test the peripherals part
 */ 
module testbench_peripherals();
	logic clk;
	logic reset, button;
	logic [9:0] switches, leds;
	logic [6:0] s6, s5, s4, s3, s2, s1;

	localparam DELAY = 10;
	
	// instantiate device to be tested
	top dut(clk, ~reset, ~button,
			  switches,
			  leds, s6,
			   s5, s4, s3, s2, s1);

	// initialize test
	initial
	begin
		reset <= 1; #DELAY; 
		reset <= 0; 
		button <= 0;

		switches <= 10'b1111111111; 
		#(DELAY*6);
		button <= 1;#(DELAY);
		button <= 0;
		
		#(DELAY*62);
		
		switches <= 10'b1110111101;
		
		#(DELAY*4)
		button <= 1;#(DELAY);
		button <= 0;
		
		#(DELAY*1000);
	
		
		$stop;
	end

	// generate clock to sequence tests
	always
	begin
		clk <= 1; #(DELAY/2); 
		clk <= 0; #(DELAY/2);
	end
endmodule