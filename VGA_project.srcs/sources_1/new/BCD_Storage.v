`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 13.10.2023 11:18:26

// Module Name: BCD_Storage

// Description: Holds BCD values while they are being entered in the keyboard.

//////////////////////////////////////////////////////////////////////////////////


module BCD_Storage(
    input clk,
    input rst,
    input [2:0] op_signal,
    input [11:0] BCD_in,

    output [1:0] prev_input,
    output [11:0] full_BCD
    );
    
    reg [11:0] r_full_BCD;
    reg [11:0] r_next_full_BCD;
    reg [1:0] r_counter;
    reg [1:0] r_next_counter;
    reg [1:0] r_prev_input;
    reg [1:0] r_next_prev_input;
    
    localparam MAX_VALUE = 12'b001001010101;
    
    // Operation Representations
    localparam NUM_FOUND = 3'b000;
    localparam OP_FOUND = 3'b001;
    localparam DELETE_FOUND = 3'b010;
    localparam ENTER_FOUND = 3'b011;
    localparam EQUAL_FOUND = 3'b100;
    localparam NOTHING = 3'b111;
    
always @(posedge clk) begin
    if (rst) begin
        r_full_BCD <= 12'b0;
        r_counter <= 2'b0;
        r_prev_input <= 2'b00;
    end
    else begin
        r_full_BCD <= r_next_full_BCD;
        r_counter <= r_next_counter;
        r_prev_input <= r_next_prev_input;
    end
end // always

always @ (*) begin
    case(op_signal)
        NUM_FOUND: begin
            if (r_counter == 2'b11) begin
                r_next_counter <= r_counter;
                r_next_full_BCD <= MAX_VALUE;
                r_next_prev_input <= 2'b01; // 1 if previous input was a number
            end // if
            else if (r_counter == 2'b00) begin
                r_next_counter <= r_counter + 1;
                r_next_full_BCD <= {8'b0, BCD_in[3:0]};
                r_next_prev_input <= 2'b01; // 1 if previous input was a number
            end // else if
            else if (r_counter == 2'b10) begin
                if (r_full_BCD[7:0] > 8'b00100101) begin
                    if (BCD_in[3:0] > 4'b0101 || r_full_BCD[7:4] > 4'b0010) begin
                        r_next_full_BCD <= MAX_VALUE;
                    end // if
                    else begin
                        r_next_full_BCD <= {r_full_BCD[7:0], BCD_in[3:0]};
                    end
                end
                else begin
                    r_next_full_BCD <= {r_full_BCD[7:0], BCD_in[3:0]};
                end
                r_next_counter <= r_counter + 1;
                r_next_prev_input <= 2'b01; // 1 if previous input was a number
            end // else if
            else begin
                r_next_counter <= r_counter + 1;
                r_next_full_BCD <= {r_full_BCD[7:0], BCD_in[3:0]};
                r_next_prev_input <= 2'b01; // 1 if previous input was a number
            end // else
        end
        DELETE_FOUND: begin
            r_next_full_BCD <= 12'b0;
            r_next_counter <= 2'b0;
            r_next_prev_input <= 2'b00; // 0 if previous input was a delete
        end
        OP_FOUND: begin
            r_next_full_BCD <= BCD_in;
            r_next_counter <= 2'b0;
            r_next_prev_input <= 2'b10; // 2 if previous input was an operation
        end
        EQUAL_FOUND: begin
            r_next_full_BCD <= r_full_BCD;
            r_next_counter <= 2'b0;
            r_next_prev_input <= r_prev_input; // store previous input
        end
        default: begin
            r_next_full_BCD <= r_full_BCD;
            r_next_counter <= r_counter;
            r_next_prev_input <= r_prev_input; // store previous input
        end
    endcase
end // always

assign prev_input = r_prev_input;
assign full_BCD = r_full_BCD;

endmodule