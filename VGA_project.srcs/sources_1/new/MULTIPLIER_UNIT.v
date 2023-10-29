`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 18.10.2023 17:15:34

// Module Name: MULTIPLIER_UNIT

// Description: Returns product of two numbers.

//////////////////////////////////////////////////////////////////////////////////


module MULTIPLIER_UNIT(
    input [7:0] NUM_A,
    input [7:0] NUM_B,
    input [8:0] PRODUCT,
    output reg [7:0] NEW_B,
    output reg [8:0] RESULT,
    output reg OVERFLOW
    );
    
    always @(*) begin
        if(NUM_B == 0) begin
            RESULT = PRODUCT;
            NEW_B = NUM_B;
        end //if
        else begin
            RESULT = PRODUCT + NUM_A;
            NEW_B = NUM_B - 1'b1;
            if(RESULT[8]) begin
                OVERFLOW = 1'b1;
            end //if
            else begin
                OVERFLOW = 1'b0;
            end //else
        end //else
    end //always
endmodule
