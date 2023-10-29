`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 16.10.2023 14:45:01

// Module Name: BCD2VGA
 
// Description: We receive BCD representations of values from the RAM and we store them in a vector to
// be displayed on the screen via the VGA.

//////////////////////////////////////////////////////////////////////////////////

module BCD2VGA(
    input clk,
    input rst,
    input en_BCD_to_Binary,
    input [7:0] num_A,
    input [7:0] num_B,
    input [7:0] result,
    input [3:0] operation,
//    input [11:0] BCD_in,
    input sign,
    input overflow,
    input [2:0] op_signal,
    input [47:0] VGA_DATA_in,
    output [47:0] VGA_DATA
    );
    
    // Operation Representations
    localparam NUM_FOUND = 3'b000;
    localparam OP_FOUND = 3'b001;
    localparam DELETE_FOUND = 3'b010;
    localparam ENTER_FOUND = 3'b011;
    localparam EQUAL_FOUND = 3'b100;
    localparam NOTHING = 3'b111;
    
    // BCD codes for non-numbers
    localparam BCD_PLUS_SIGN = 12'b000100110000; //130
    localparam BCD_MINUS_SIGN = 12'b000100110001; //131
    localparam BCD_MULTIPLICATION_SIGN = 12'b000100110010; //132
    localparam BCD_MODULUS_SIGN = 12'b000100110011; //133
    localparam BCD_EQUAL_SIGN = 12'b000100110100; //134
    // VGA codes for non-numbers
    localparam PLUS_SIGN = 4'b1010; //10
    localparam MINUS_SIGN = 4'b1011; //11
    localparam MULTIPLICATION_SIGN = 4'b1100; //12
    localparam MODULUS_SIGN = 4'b1101; //13
    localparam EQUAL_SIGN = 4'b1110; //14
    localparam OVERFLOW_SIGN = 4'b1111; //15
    
    localparam ZERO_SIGN = 12'b000000000000;
    localparam THREE_SIGN = 12'b000000000011;
    
    reg [47:0] r_BCD_vga;
    reg [47:0] r_next_BCD_vga;
    wire [11:0] w_BCD_A;
    wire [11:0] w_BCD_B;
    wire [11:0] w_BCD_Result;
    
    always @(posedge clk) begin
        if(rst == 1) begin
            r_BCD_vga <= {ZERO_SIGN,ZERO_SIGN,ZERO_SIGN,ZERO_SIGN};
        end //if
        else begin
            r_BCD_vga <= r_next_BCD_vga;
        end //else
    end //always
    Binary2BCD UUDA (
        .binary_in(num_A),
        .BCD_out(w_BCD_A)
    );
    
    Binary2BCD UUDB (
        .binary_in(num_B),
        .BCD_out(w_BCD_B)
    );
    
    Binary2BCD UUDRESULT (
        .binary_in(result),
        .BCD_out(w_BCD_Result)
    );
    
    always @(*) begin
        if(en_BCD_to_Binary) begin
            case(operation) 
                PLUS_SIGN: begin
                    if(overflow) begin
                        r_next_BCD_vga <= {w_BCD_A, PLUS_SIGN, w_BCD_B, EQUAL_SIGN, OVERFLOW_SIGN, w_BCD_Result};
                    end //if 
                    else if(sign) begin
                        r_next_BCD_vga <= {w_BCD_A, PLUS_SIGN, w_BCD_B, EQUAL_SIGN, MINUS_SIGN, w_BCD_Result};
                    end //else if
                    else begin
                        r_next_BCD_vga <= {w_BCD_A, PLUS_SIGN, w_BCD_B, EQUAL_SIGN, PLUS_SIGN, w_BCD_Result};
                    end //else
                end //PLUS_SIGN 
                MINUS_SIGN: begin
                    if(overflow) begin
                        r_next_BCD_vga <= {w_BCD_A, MINUS_SIGN, w_BCD_B, EQUAL_SIGN, OVERFLOW_SIGN, w_BCD_Result};
                    end //if 
                    else if(sign) begin
                        r_next_BCD_vga <= {w_BCD_A, MINUS_SIGN, w_BCD_B, EQUAL_SIGN, MINUS_SIGN, w_BCD_Result};
                    end //else if
                    else begin
                        r_next_BCD_vga <= {w_BCD_A, MINUS_SIGN, w_BCD_B, EQUAL_SIGN, PLUS_SIGN, w_BCD_Result};
                    end //else
                end //MINUS_SIGN 
                MULTIPLICATION_SIGN: begin
                    if(overflow) begin
                        r_next_BCD_vga <= {w_BCD_A, MULTIPLICATION_SIGN, w_BCD_B, EQUAL_SIGN, OVERFLOW_SIGN, w_BCD_Result};
                    end //if 
                    else if(sign) begin
                        r_next_BCD_vga <= {w_BCD_A, MULTIPLICATION_SIGN, w_BCD_B, EQUAL_SIGN, MINUS_SIGN, w_BCD_Result};
                    end //else if
                    else begin
                        r_next_BCD_vga <= {w_BCD_A, MULTIPLICATION_SIGN, w_BCD_B, EQUAL_SIGN, PLUS_SIGN, w_BCD_Result};
                    end //else
                end //MULTIPLICATION_SIGN 
                MODULUS_SIGN: begin
                    if(overflow) begin
                        r_next_BCD_vga <= {w_BCD_A, MODULUS_SIGN, THREE_SIGN, EQUAL_SIGN, OVERFLOW_SIGN, w_BCD_Result};
                    end //if 
                    else if(sign) begin
                        r_next_BCD_vga <= {w_BCD_A, MODULUS_SIGN, THREE_SIGN, EQUAL_SIGN, MINUS_SIGN, w_BCD_Result};
                    end //else if
                    else begin
                        r_next_BCD_vga <= {w_BCD_A, MODULUS_SIGN, THREE_SIGN, EQUAL_SIGN, PLUS_SIGN, w_BCD_Result};
                    end //else
                end //MODULUS_SIGN 
                default: begin
                    r_next_BCD_vga <= 48'b0;
                end //default
            endcase
        end //if
        else begin
            if(op_signal == NUM_FOUND || op_signal == OP_FOUND || op_signal == EQUAL_FOUND
            || op_signal == DELETE_FOUND) begin
                r_next_BCD_vga <= VGA_DATA_in;
            end //if
            else begin
                r_next_BCD_vga <= r_BCD_vga;
            end //else
//            r_next_BCD_vga <= r_BCD_vga;
        end //else
    end //always
    
    assign VGA_DATA = r_BCD_vga;
endmodule
