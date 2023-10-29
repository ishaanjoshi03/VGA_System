`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2023 14:13:36
// Design Name: 
// Module Name: Project_TB
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


module Project_TB;
    reg clk = 1'b1;
    reg reset = 1'b0;
    reg kb_data;
    reg kb_clk = 1'b1;
    reg b_Enter;
    reg b_Sign;
    reg [7:0] w_scan_code = 8'b00000000;
    reg w_valid_scan_code = 1'b0;
    wire [7:0] sc;
    wire [7:0] seven_seg;
    wire [3:0] anode;
    wire io_horizontal_sync;
    wire io_vertical_sync;
    wire [11:0] io_rgb_color;
    wire [3:0] ADDRESS;
    
    ALU_top Text(
        .clk(clk),
        .reset(reset),
        .kb_data(kb_data),
        .kb_clk(kb_clk),
        .b_Enter(b_Enter),
        .b_Sign(b_Sign),
        .w_scan_code(w_scan_code),
        .w_valid_scan_code(w_valid_scan_code),
        .sc(sc),
        .seven_seg(seven_seg),
        .anode(anode),
        .io_horizontal_sync(io_horizontal_sync),
        .io_vertical_sync(io_vertical_sync),
        .io_rgb_color(io_rgb_color),
        .ADDRESS(ADDRESS)   
    );
    
    localparam c_break_code = 8'hf0; 
    localparam NUM_0 = 8'b01110000; //01000101
    localparam NUM_1 = 8'b01101001; //00010110
    localparam NUM_2 = 8'b01110010; //00011110
    localparam NUM_3 = 8'b01111010; //00100110
    localparam NUM_4 = 8'b01101011; //00100101
    localparam NUM_5 = 8'b01110011; //00101110
    localparam NUM_6 = 8'b01110100; //00110110
    localparam NUM_7 = 8'b01101100; //00111101
    localparam NUM_8 = 8'b01110101; //00111110
    localparam NUM_9 = 8'b01111101; //01000110
    localparam EQUAL = 8'b01000101;
    localparam PLUS = 8'b01111001;
    localparam MINUS = 8'b01111011;
    localparam MULTIPLY = 8'b01111100;
    localparam MODULOS = 8'b01001010;
    localparam DELETE = 8'b01110001;
    localparam ENTER = 8'b01011010;
    localparam SPACE = 8'b00101001;


    always #5 clk = !clk;
    always #20 kb_clk = !kb_clk;
    
    initial begin
        #100
        reset = !reset;
        #20
        
        #20
        w_scan_code = NUM_3;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_3;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_6;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_6;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        // ------------------------------------------------------------------------------------------------
        
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_1;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_1;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MINUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MINUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_8;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_8;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        // ------------------------------------------------------------------------------------------------
        
        #50
        w_scan_code = NUM_4;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_4;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        // ------------------------------------------------------------------------------------------------
        
        #50
        w_scan_code = NUM_1;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_1;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_1;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_1;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        // ---------------------------------------------------------------------------------
        
        #50
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MODULOS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MODULOS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_6;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_6;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_8;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_8;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_6;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_6;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_3;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_3;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_5;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_9;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_9;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MODULOS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MODULOS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_8;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_8;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = PLUS;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_2;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
         #50
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_0;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = MULTIPLY;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = NUM_7;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = SPACE;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        // ------------------------------------------------------------------------------------------------
        
        
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        #50
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = c_break_code;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        #20
        w_scan_code = ENTER;
        w_valid_scan_code = 1'b1;
        #20
        w_valid_scan_code = 1'b0;
        
        
        
        
    $finish;
    end
endmodule