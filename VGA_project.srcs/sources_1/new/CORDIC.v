`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 10.22.2023 15:51:33

// Module Name: CORDIC

// Description: Uses CORDIC algorithm to convert (x,y) rectangular coordinates to (r,θ) polar coordinates

//////////////////////////////////////////////////////////////////////////////////


module CORDIC(
    input [7:0] i_x,
    input [7:0] i_y,
    input [14:0] i_SumAngle, 
    input [3:0] count,    // iteration # i

    output reg [7:0] o_x,
    output reg [7:0] o_y,
    output reg [14:0] o_SumAngle
);

reg [14:0] atan_val; // possibly can be 1 bit less, just anticipating subtraction which requires signed arithmetic 

always @ (*) begin
    case (count) 
        0: atan_val <= 15'b010110100000000;
        1: atan_val <= 15'b001101010010001;
        2: atan_val <= 15'b000111000001001;
        3: atan_val <= 15'b000011100100000;
        4: atan_val <= 15'b000001110010100;
        5: atan_val <= 15'b000000111001010;
        6: atan_val <= 15'b000000011100101;
        7: atan_val <= 15'b000000001110011;
        8: atan_val <= 15'b000000000111001;
        9: atan_val <= 15'b000000000011100;
    endcase
end // always

always @ (*) begin
    if (!i_y[7]) begin   // if y >= 0
        // i_x guaranteed positive, i_y guaranteed positive
        o_x = i_x + (i_y >> count);     // unsigned addition fine?
        o_y = i_y + ~((i_x >> count) - 1'b1);   // signed subtraction
        o_SumAngle = i_SumAngle + atan_val;
    end // if
    else begin  // if y < 0
        o_x = i_x + ~((-i_y >> count) - 1'b1); // signed subtraction
        o_y = i_y + (i_x >> count);
        o_SumAngle = i_SumAngle + ~(atan_val - 1'b1);
    end // if
end // always
