`timescale 1ns / 1ps

module Decoder(
    input wire clk,
    input wire reset,
    input wire [7:0] code,
    input wire start,
    input wire [8:0] perimeter,
    input wire [11:0] area,
    input wire [5:0] start_x,
    input wire [5:0] start_y,
    output reg done,
    output reg error
    );
	 
						////////////////////////////////////////////////////////////////

	localparam INIT = 4'b0000;
	localparam WAIT = 4'b0001;
	localparam RUN_DECODE = 4'b0010;
	localparam CHECK_DONE = 4'b0011;
	localparam RUN_AREA = 4'b0100;
	localparam TERMINATE = 4'b1000;
	
						////////////////////////////////////////////////////////////////

	reg [7:0] current_i = 0;
	reg [7:0] current_j = 0;
	reg [7:0] i, j;
	reg [0:63] output_mem [0:63];
	reg is_first_pixel;
	reg [3:0] state = 0;
	reg [3:0] next_state = 0;
	reg [0:63] output_mam [0:63];						
	initial $readmemb("output.txt", output_mam, 0, 63);
	reg [11:0] current_area;
	reg [8:0] current_perimeter = 0;
	reg [8:0] received_perimeter;
	reg [11:0] decoded_area;
	reg decoded_perimeter;
	
						////////////////////////////////////////////////////////////////

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= INIT;
        done <= 0;
        error <= 0;
		  
    end else begin
        case (state)
		  
						////////////////////////////////////////////////////////////////

            INIT: begin
                for (i = 0; i < 64; i = i + 1)
                    for (j = 0; j < 64; j = j + 1) 
								output_mem[i][j] <= 0;
					
                current_i <= start_x;
                current_j <= start_y;
                is_first_pixel <= 1;
                next_state <= WAIT;
            end

						////////////////////////////////////////////////////////////////

            WAIT: begin
                if (start) begin
                    received_perimeter <= perimeter;
                    next_state = RUN_DECODE;
                end else
                    next_state = WAIT;
            end
				
						////////////////////////////////////////////////////////////////

            RUN_DECODE: begin
                case (code)
                    0: begin
                        current_j <= current_j + 1;
                    end
                    1: begin
                        current_i <= current_i - 1;
                        current_j <= current_j + 1;
                    end
                    2: begin
                        current_i <= current_i - 1;
                    end
                    3: begin
                        current_i <= current_i - 1;
                        current_j <= current_j - 1;
                    end
                    4: begin
                        current_j <= current_j - 1;
                    end
                    5: begin
                        current_i <= current_i + 1;
                        current_j <= current_j - 1;
                    end
                    6: begin
                        current_i <= current_i + 1;
                    end
                    7: begin
                        current_i <= current_i + 1;
                        current_j <= current_j + 1;
                    end
                endcase

                if (is_first_pixel == 1) begin
							output_mem[start_x][start_y] <= 1;
							is_first_pixel = 0;
							current_perimeter <= current_perimeter + 1;
					 end
					 else begin
                    output_mem[current_i][current_j] <= 1;
                    current_perimeter <= current_perimeter + 1;
                end

                if (current_perimeter < received_perimeter) begin
                    next_state = RUN_DECODE;
                end else begin
                    next_state = CHECK_DONE;
                end

            end
				
					 ////////////////////////////////////////////////////////////////

            CHECK_DONE: begin
                if (current_i == start_x && current_j == start_y && current_perimeter == received_perimeter - 1) begin
                    error = (decoded_area != area) || (decoded_perimeter != perimeter);
                    done <= 1;
                    next_state = TERMINATE;
                end else begin
                    next_state = RUN_DECODE;
                end
            end
				
					 ////////////////////////////////////////////////////////////////

            TERMINATE: begin
                next_state = TERMINATE;
            end
				
					 ////////////////////////////////////////////////////////////////

        endcase

        state <= next_state;
		  
    end
end
	
	
endmodule
