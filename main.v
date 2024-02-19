`timescale 1ns / 1ps

module main(
	input wire clk_1,
	input wire clk_10,
	input wire reset,
	input wire start	
);

	wire [7:0] code_encoder_uart_rx;
	wire done_encodet_uart_rx;
	wire error_encoder_uart_rx;
	wire [8:0] perimeter_encoder_decoder;
	wire [11:0] area_encoder_decoder;
	wire [5:0] startx_encoder_decoder;
	wire [5:0] starty_encoder_decoder;
	wire tx_out_rx_tx;
	wire [7:0] rx_data_uart_rx_decoder;
	wire ready_uart_rx_decoder;	

	Encoder Encoder (
    .reset(reset), 
    .clk(clk_10), 
    .start(start), 
    .code(code_encoder_uart_rx), 
    .done(done_encodet_uart_rx), 
    .error(error), 
    .perimeter(perimeter_encoder_decoder), 
    .area(area_encoder_decoder), 
    .start_x(startx_encoder_decoder), 
    .start_y(starty_encoder_decoder)
    );

	TX_UART TX_UART (
    .clk(clk_1), 
    .reset(reset), 
    .tx_data(code_encoder_uart_rx), 
    .ready(done_encodet_uart_rx), 
    .tx_out(tx_out_rx_tx)
    );

	RX_UART RX_UART (
    .clk(clk_1), 
    .reset(reset), 
    .rx_in(tx_out_rx_tx), 
    .rx_data(rx_data_uart_rx_decoder), 
    .ready(ready_uart_rx_decoder)
    );

	Decoder Decoder (
    .clk(clk_10), 
    .reset(reset), 
    .code(rx_data_uart_rx_decoder), 
    .start(ready_uart_rx_decoder), 
    .perimeter(perimeter_encoder_decoder), 
    .area(area_encoder_decoder), 
    .start_x(startx_encoder_decoder), 
    .start_y(starty_encoder_decoder)
    );

endmodule
