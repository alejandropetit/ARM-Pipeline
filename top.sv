/*
 * This module is the TOP of the ARM 5 stages pipeline processor
 */ 
module top(input logic clk, nreset, nbutton,
			  input logic [9:0] switches,
			  output logic [9:0] leds,
			  output logic [7:0] s6, s5, s4, s3, s2, s1);

	// Internal signals
	logic reset, button;
	assign reset = ~nreset;
	assign button = ~nbutton;
	logic [31:0] PC, Instr, ReadData;
	logic [31:0] WriteData, DataAdr;
	logic MemWrite;
	
	// Instantiate instruction memory
	imem imem(PC, Instr);

	// Instantiate data memory (RAM + peripherals)
	dmem dmem(clk, MemWrite, button, DataAdr, WriteData, ReadData, switches, leds, s6, s5, s4, s3, s2, s1);

	// Instantiate processor
	arm arm(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
endmodule