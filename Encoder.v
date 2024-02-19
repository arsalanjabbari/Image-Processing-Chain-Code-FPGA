`timescale 1ns / 1ps

module Encoder(
    input wire reset,
    input wire clk,
    input wire start,
    output reg [7:0] code,
    output reg done,
    output wire error,
    output reg [8:0] perimeter,
    output reg [11:0] area,
    output wire [5:0] start_x,
    output wire [5:0] start_y
);

						////////////////////////////////////////////////////////////////

    localparam INIT = 4'b0000;
    localparam WAIT = 4'b0001;
    localparam START_PX = 4'b0010;
    localparam RUN_CHAIN = 4'b0011;
    localparam CHECK_DONE = 4'b0100;
	 localparam INIT_PROPS = 4'b0101; 
	 localparam RUN_AREA = 4'b0110;
	 localparam SEND_CHAIN = 4'b0111;
    localparam DONE_ENC = 4'b1000;
	 
						////////////////////////////////////////////////////////////////

    reg [7:0] i = 0;
	 reg [7:0] j = 0;
	 reg [7:0] current_i = 0;
	 reg [7:0] current_j = 0;
    reg [5:0] start_i;
	 reg [5:0] start_j;
    reg [2:0] current_code;
    reg [11:0] current_area = 0;
    reg [11:0] output_index = 0;
    reg is_start_point_ready;
    reg [0:63] testcase_mem [0:63];
    reg [2:0] encode_output [0:4095];
    reg [3:0] state = 0;
	 reg [3:0] next_state = 0;
	 wire [63:0] ram_dout;
	 reg [5:0] ram_addrin;
	
						////////////////////////////////////////////////////////////////
	
	BlockRam ram (
  .clka(clk), // input clka
  .addra(ram_addrin), // input [5 : 0] addra
  .douta(ram_dout) // output [63 : 0] douta
);

						////////////////////////////////////////////////////////////////
			
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= INIT;
				
        end else begin
		  
            case (state)
				
						////////////////////////////////////////////////////////////////

                INIT: begin
							if (i > 1)
								testcase_mem[i-2] <= ram_dout;
							if (i == 65)
								next_state = WAIT;
							else
								next_state<= INIT;
							i <= i + 1;
							ram_addrin <= i;
                    is_start_point_ready <= 0;
 						  perimeter <= 0;
                    done <= 0;
                end
					 
						////////////////////////////////////////////////////////////////

                WAIT: begin
                    if (start) 
                        next_state = START_PX;
                    else 
                        next_state = WAIT;
                end
					 
						////////////////////////////////////////////////////////////////

                START_PX: begin
							for (i = 63; i != 0; i = i - 1)
								for (j = 63; j != 0; j = j - 1) begin
								  if (testcase_mem[i][j] == 1'b1 && is_start_point_ready == 1'b0) begin
											start_i <=i;
											start_j <= j;
											current_i <= i;
											current_j <= j;
											is_start_point_ready <= 1;
											next_state = RUN_CHAIN;
									end
								end		  
                end
					 
						////////////////////////////////////////////////////////////////

                RUN_CHAIN: begin
                    if (testcase_mem[current_i][current_j + 1] == 1'b1 &&  testcase_mem[current_i - 1][current_j + 1] == 1'b0) begin current_code <= 3'b000; 
								current_j <= current_j + 1; end 
						  
						  else if (testcase_mem[current_i - 1][current_j + 1] == 1'b1 && testcase_mem[current_i - 1][current_j] == 1'b0) begin current_code <= 3'b001;
                        current_i <= current_i - 1;
                        current_j <= current_j + 1; end 
								
						  else if (testcase_mem[current_i - 1][current_j] == 1'b1 && testcase_mem[current_i - 1][current_j - 1] == 1'b0) begin current_code <= 3'b010;
                        current_i <= current_i - 1; end 
								
						  else if (testcase_mem[current_i - 1][current_j - 1] == 1'b1 && testcase_mem[current_i][current_j - 1] == 1'b0) begin current_code <= 3'b011;
                        current_i <= current_i - 1;
                        current_j <= current_j - 1; end 
								
						  else if (testcase_mem[current_i][current_j - 1] == 1'b1 && testcase_mem[current_i + 1][current_j - 1] == 1'b0) begin current_code <= 3'b100;
                        current_j <= current_j - 1; end 
								
						  else if (testcase_mem[current_i + 1][current_j - 1] == 1'b1 && testcase_mem[current_i + 1][current_j] == 1'b0) begin current_code <= 3'b101;
                        current_i <= current_i + 1;
                        current_j <= current_j - 1; end 
								
						  else if (testcase_mem[current_i + 1][current_j] == 1'b1 && testcase_mem[current_i + 1][current_j + 1] == 1'b0) begin current_code <= 3'b110;
                        current_i <= current_i + 1; end 
								
						  else if (testcase_mem[current_i + 1][current_j + 1] == 1'b1 && testcase_mem[current_i][current_j - 1] == 1'b0) begin current_code <= 3'b111;
                        current_i <= current_i + 1;
                        current_j <= current_j + 1; end
						  
						  perimeter <= perimeter + 1;

                    encode_output[output_index - 1] <= current_code;
						  output_index <= output_index + 1;
						  next_state = CHECK_DONE;
                end
					 
						////////////////////////////////////////////////////////////////

                CHECK_DONE: begin
                    if (current_i == start_i && current_j == start_j)
                        next_state = INIT_PROPS;
                    else 
								next_state = RUN_CHAIN;
				    end
					 
						////////////////////////////////////////////////////////////////
					 
					INIT_PROPS: begin
							i <= 0;
							j <= 0;
							area <= 0;
							next_state = RUN_AREA;						
					end
					
						////////////////////////////////////////////////////////////////
					 
					RUN_AREA: begin
							if (testcase_mem[i][j] == 1'b1)
								area <= area + 1;
								
							if (j == 63) begin
								j <= 0;
								i <= i + 1;
							end else 
								j <= j + 1;
							
							if (i == 63 && j == 63) begin
								next_state = SEND_CHAIN;
							   i <= 0;
							end else
								next_state = RUN_AREA;
					end
					
						////////////////////////////////////////////////////////////////
					 
                SEND_CHAIN: begin
						code <= {5'b00000, encode_output[i]};
						 
						 if (i < perimeter + 1) begin
								done <= i > 0 ? 1 : 0;
								next_state = SEND_CHAIN;
								i <= i + 1;
						 end else
								next_state = DONE_ENC;		
						 end
						 
						////////////////////////////////////////////////////////////////

                DONE_ENC: begin
							next_state = DONE_ENC;
					 end
					 
						////////////////////////////////////////////////////////////////

            endcase

            state <= next_state;
				
        end
    end
	 
						////////////////////////////////////////////////////////////////

    assign error = area == 0 ? 1 : 0;
    assign start_x = start_i;
    assign start_y = start_j;

endmodule
