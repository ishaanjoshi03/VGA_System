`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 13.10.2023 10:28:15

// Module Name: Reverse_BCD_Nibble_Module

// Description: Submodule for BCD2BINARY, uses Reverse Double Dabble algorithm

//////////////////////////////////////////////////////////////////////////////////


module Reverse_BCD_Nibble_Module(
    input [19:0] nibbles_in,
    output reg [19:0] nibbles_out
    );
    
    localparam c_DD_lim = 8;    //Value used in the Double Dabble algorithm to check when to add c_DD_val to a nibble
    localparam c_DD_val = 3;    //Value used in the Double Dabble algorithm when a nibble reaches c_DD_lim or higher
    
    always @(*) begin
        nibbles_out[7:0] <= nibbles_in[7:0];
        if(nibbles_in[11:8] >= c_DD_lim) begin  //Nibble 0
            nibbles_out[11:8] <= nibbles_in[11:8] - c_DD_val;
        end //if
        else begin
            nibbles_out[11:8] <= nibbles_in[11:8];
        end //else
        
        if(nibbles_in[15:12] >= c_DD_lim) begin //Nibble 1
            nibbles_out[15:12] <= nibbles_in[15:12] - c_DD_val;
        end //if
        
        else begin
            nibbles_out[15:12] <= nibbles_in[15:12];
        end //else
        
        if(nibbles_in[19:16] >= c_DD_lim) begin //Nibble 2
            nibbles_out[19:16] <= nibbles_in[19:16] - c_DD_val;
        end //if
        else begin
            nibbles_out[19:16] <= nibbles_in[19:16];
        end //else
    end //always
    
endmodule
