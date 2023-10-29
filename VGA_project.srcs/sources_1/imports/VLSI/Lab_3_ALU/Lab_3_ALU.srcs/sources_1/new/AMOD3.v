`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 27.09.2023 15:53:05

// Module Name: AMOD3

// Description: Submodule to perform MOD operation

//////////////////////////////////////////////////////////////////////////////////


module AMODX(
    input [7:0] A_in,
    input [7:0] Theta,
    output reg [7:0] A_out
    );
    
    
    always @ (*) begin
        if (A_in >= Theta) begin
            A_out = A_in - Theta;
        end // if
        else begin
            A_out = A_in;
        end // else
    end //always
endmodule
