module RX_UART (
  input wire clk,
  input wire reset,
  input wire rx_in,
  output reg [7:0] rx_data,
  output reg ready
);

  reg [3:0] counter_rx = 0; // Counter bits

  always @(posedge clk or posedge reset)
    if (!reset) begin   
		if (counter_rx == 0) begin // start bit
			rx_data <= 8'bX;
			if (rx_in == 1'b0) begin
				counter_rx <= 1;
				ready <= 0;
			end
		end else if (counter_rx < 9 && counter_rx > 0) begin
			rx_data[counter_rx - 1] <= rx_in;
			counter_rx <= counter_rx + 1;
		end else if (rx_in == 1'b1 && counter_rx == 9) begin // stop bit
			ready <= 1;
			counter_rx <= 4'b0;
	   end               
	 end

endmodule
