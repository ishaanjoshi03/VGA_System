`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2023 10:39:35
// Design Name: 
// Module Name: BCD2Binary_TB
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


module BCD2Binary_TB;

reg [11:0] r_BCD_in;
wire [7:0] w_binary_out;

BCD2BINARY UUD1 (
    .BCD_in(r_BCD_in),
    .binary_out(w_binary_out)
);

initial begin
    r_BCD_in = 12'b000000011001;
    
    $finish;
end

endmodule
