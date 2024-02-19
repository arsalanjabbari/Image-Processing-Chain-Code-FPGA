`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:47:06 02/01/2024
// Design Name:   main
// Module Name:   C:/Users/usof/Desktop/FPGA-Project/FPGA-Project/main_test.v
// Project Name:  FPGA-Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_test;

	// Inputs
	reg clk_1;
	reg clk_10;
	reg reset;
	reg start;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.clk_1(clk_1), 
		.clk_10(clk_10), 
		.reset(reset), 
		.start(start)
	);

	initial begin
		// Initialize Inputs
		// Initialize Inputs
		clk_1 = 1;
		clk_10 = 1;
		reset = 0;
		start = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always #1 clk_1 = ~clk_1;
	always #10 clk_10 = ~clk_10;
      
endmodule

