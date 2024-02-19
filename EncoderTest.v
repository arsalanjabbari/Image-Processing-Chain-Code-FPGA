`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:16:52 01/30/2024
// Design Name:   Encoder
// Module Name:   C:/Users/usof/CA_Project/FPGA-Project/EncoderTest.v
// Project Name:  FPGA-Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Encoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module EncoderTest;

	// Inputs
	reg reset;
	reg clk;
	reg start; 

	// Instantiate the Unit Under Test (UUT)
	Encoder uut (
		.reset(reset), 
		.clk(clk), 
		.start(start)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		clk = 0;
		start = 0;

		// Wait 100 ns for global reset to finish
		#6;
		
		reset = 0;
		start = 1;
        
		// Add stimulus here

	end
	always #1 clk = ~clk;
   
endmodule

