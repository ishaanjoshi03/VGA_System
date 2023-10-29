`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2023 15:59:49
// Design Name: 
// Module Name: BCD2VGA_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BCD2VGA_TB;
    reg [11:0] BCD_in;
    reg sign = 1;
    reg overflow = 1;
    wire [47:0] VGA_DATA;

BCD2VGA Test(
    .BCD_in(BCD_in),
    .sign(sign),
    .overflow(overflow),
    .VGA_DATA(VGA_DATA)
);

localparam BCD_PLUS_SIGN = 12'b000100110000; //130
localparam BCD_MINUS_SIGN = 12'b000100110001; //131
localparam BCD_MULTIPLICATION_SIGN = 12'b000100110010; //132
localparam BCD_MODULUS_SIGN = 12'b000100110011; //133
localparam BCD_EQUAL_SIGN = 12'b000100110100; //134

initial begin
    overflow <= 1'b1;
    sign <= 1'b0;
    #100
    BCD_in <= 12'b000100100011; //123
    #20
    BCD_in <= BCD_MINUS_SIGN;
    #20
    BCD_in <= 12'b101111111101; //123
    #20
    BCD_in <= BCD_EQUAL_SIGN;
    #20
    BCD_in <= 12'b111111111111; //123
    
    $finish;
end
endmodule
