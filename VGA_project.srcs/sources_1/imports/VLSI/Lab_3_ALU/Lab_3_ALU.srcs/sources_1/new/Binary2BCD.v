`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 23.09.2023 10:19:03

// Module Name: Binary2BCD

// Description: Uses Double Dabble algorithm to convert 8-bit binary numbers
//              to 12-bit BCD representations

//////////////////////////////////////////////////////////////////////////////////


module Binary2BCD(
    input [7:0] binary_in,
    output [11:0] BCD_out
    );
    
    // Constants
    localparam c_reset_BCD_val = 12'b000000000000;  //The initial value of the BCD register part before starting conversion
    
    wire [19:0] nibbles_out1;
    wire [19:0] nibbles_out2;
    wire [19:0] nibbles_out3;
    wire [19:0] nibbles_out4;
    wire [19:0] nibbles_out5;
    wire [19:0] nibbles_out6;
    wire [19:0] nibbles_out7;
    wire [19:0] nibbles_outfin;
    
    // Double Dabble algorithm
    BCD_Nibble_Module U0 (
        .nibbles_in({c_reset_BCD_val, binary_in} << 1'b1),
        .nibbles_out(nibbles_out1)
    ); 
    BCD_Nibble_Module U1 (
        .nibbles_in(nibbles_out1 << 1'b1),
        .nibbles_out(nibbles_out2)
    );
    BCD_Nibble_Module U2 (
        .nibbles_in(nibbles_out2 << 1'b1),
        .nibbles_out(nibbles_out3)
    );     
    BCD_Nibble_Module U3 (
        .nibbles_in(nibbles_out3 << 1'b1),
        .nibbles_out(nibbles_out4)
    );     
    BCD_Nibble_Module U4 (
        .nibbles_in(nibbles_out4 << 1'b1),
        .nibbles_out(nibbles_out5)
    );     
    BCD_Nibble_Module U5 (
        .nibbles_in(nibbles_out5 << 1'b1),
        .nibbles_out(nibbles_out6)
    );     
    BCD_Nibble_Module U6 (
        .nibbles_in(nibbles_out6 << 1'b1),
        .nibbles_out(nibbles_out7)
    );     
//    BCD_Nibble_Module U7 (
//        .nibbles_in(nibbles_out7 << 1'b1),
//        .nibbles_out(nibbles_outfin)
//    );          
    assign nibbles_outfin = nibbles_out7 << 1'b1;
    assign BCD_out = nibbles_outfin[19:8];
    
endmodule
