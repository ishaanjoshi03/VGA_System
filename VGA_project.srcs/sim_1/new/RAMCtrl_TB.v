`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2023 13:45:45
// Design Name: 
// Module Name: RAMCtrl_TB
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


module RAMCtrl_TB;

    reg clk = 1'b1;
    reg reset = 1'b0;
    reg [2:0] op_signal;
    reg [7:0] binary_in;  
    wire [7:0] RAM_DATA;
    wire [3:0] ADDRESS;
    
    RAMCtrl RamCtrlTest (
        .clk(clk),
        .rst(reset),
        .op_signal(op_signal),
        .binary_in(binary_in),
        .RAM_DATA(RAM_DATA),
        .ADDRESS(ADDRESS)
    );
    
    always clk = !clk;
    
    initial begin
        #100
        reset = !reset;
        #20
        
        binary_in = 5;
        op_signal = 3'b000;
        #20
        
        binary_in = 0;
        op_signal = 3'b100;
        #20        
        
        binary_in = 8'b10000010;
        op_signal = 3'b001;
        #20        
        
        binary_in = 0;
        op_signal = 3'b100;
        #20  
        
        binary_in = 9;
        op_signal = 3'b000;
        #20        
        
        binary_in = 0;
        op_signal = 3'b100;
        #20        
    
        $finish;
    end
endmodule