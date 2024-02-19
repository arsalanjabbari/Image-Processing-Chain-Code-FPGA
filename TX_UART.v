module TX_UART (
  input wire clk,
  input wire reset,
  input wire [7:0] tx_data,
  input wire ready,
  output reg tx_out
);

  reg [7:0] inter_reg;
  reg [3:0] counter_tx = 0;
  
always @(posedge clk or posedge reset)
	if (!reset) begin
	
		if (ready) begin
		
			if (counter_tx == 0) begin
				inter_reg <= tx_data;
				tx_out <= 1'b0; // Start bit
				counter_tx <= counter_tx + 1;
				
			end else if (counter_tx < 9) begin
				tx_out <= inter_reg[counter_tx - 1];
				counter_tx <= counter_tx + 1;
				
			end else if (counter_tx == 9) begin
				tx_out <= 1'b1; // Stop bit
				counter_tx <= 0;
				
			end else if (counter_tx == 10) begin
				tx_out <= 1'bX; 
				counter_tx <= 0;
				
			end
			
		end
	end				
endmodule
