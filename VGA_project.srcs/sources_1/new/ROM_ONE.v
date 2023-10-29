`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 11.10.2023 15:42:28

// Module Name: ROM_ONE

// Description: LUTs to display 7-segment versions of numbers on VGA

//////////////////////////////////////////////////////////////////////////////////


module ROM_ONE(
    input clk, 
    input [10:0] start_col, // represents which of 12 'displays' we are currently on
    input en_draw,  //Signal for enabeling drawing
    input en_seg, 
    input [3:0] BCD,
    input [10:0] row,    //53
    input [10:0] col,    //80
    output reg [11:0] px_data
    );
    
//    localparam [11:0] BLACK = 12'h000;
    localparam [11:0] BLACK = 12'h000; //Temp testing value
    localparam [11:0] RED = 12'h00f;
    localparam [11:0] WHITE = 12'hfff;
    
    localparam NUM_HORIZONTAL_VISIBLE_PIXELS = 640;
    localparam NUM_HORIZONTAL_FRONT_PORCH_PIXELS = 16;
    localparam NUM_HORIZONTAL_SYNC_PIXELS = 96;
    localparam NUM_HORIZONTAL_BACK_PORCH_PIXELS = 48;
    localparam NUM_HORIZONTAL_ALL_PIXELS = 
        NUM_HORIZONTAL_VISIBLE_PIXELS + NUM_HORIZONTAL_FRONT_PORCH_PIXELS + 
        NUM_HORIZONTAL_SYNC_PIXELS + NUM_HORIZONTAL_BACK_PORCH_PIXELS;
    
    localparam NUM_VERTICAL_VISIBLE_PIXELS = 480;
    localparam NUM_VERTICAL_FRONT_PORCH_PIXELS = 10;
    localparam NUM_VERTICAL_SYNC_PIXELS = 2;
    localparam NUM_VERTICAL_BACK_PORCH_PIXELS = 29;
    localparam NUM_VERTICAL_ALL_PIXELS = 
        NUM_VERTICAL_VISIBLE_PIXELS + NUM_VERTICAL_FRONT_PORCH_PIXELS + 
        NUM_VERTICAL_SYNC_PIXELS + NUM_VERTICAL_BACK_PORCH_PIXELS;
    
    //Local parameters for seven segment segments
    localparam SEG_L = 35; //Length of a segment
    localparam SEG_L_BCEF = 56; 
    localparam SEG_W = 5; //Width of a segment
    localparam SEG_SP = 4; //Spacing between segments
    localparam ROW_START = 167; //Vetrtical pixels before we start drawing segments
    
    reg [10:0] r_row;
    reg [10:0] r_col;   
    reg [11:0] r_px_data;
    
    
    always @(posedge clk) begin
        r_row <= row;
        r_col <= col;
    end //always
    
    
    //Draw 0
    always @(*) begin
    if(en_draw && en_seg) begin     
           
        // Case for which number to display
        case(BCD) 
            4'b0000: begin
            //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg b
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg e
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0000
           

            4'b0001: begin               
                // seg b
                if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0001

            4'b0010: begin
                //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg b
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if               
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg e
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if                
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0010

            4'b0011: begin
            //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg b
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0011

            4'b0100: begin               
                // seg b
                if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                                            
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0100

            4'b0101: begin
            //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if               
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0101

            4'b0110: begin
            //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg e
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0110

            4'b0111: begin
            //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg b
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                                           
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //0111

            4'b1000: begin
                //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg b
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg e
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1000

            4'b1001: begin
            //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg b
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                
                // seg c
                else if ((r_col >= (start_col + 2*SEG_SP + SEG_L) && r_col <= (start_col + 2*SEG_SP + SEG_L + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //else if
                            
                // seg d
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF) && r_row <= (ROW_START + 4*SEG_SP + 2*SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1001            
            
            4'b1010: begin //(plus sign)                
                // seg g
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // central vertical line for plus
                else if ((r_col >= (start_col + SEG_SP/2 + SEG_L/2) && r_col <= (start_col + SEG_SP/2 + SEG_L/2 + SEG_W)) && 
                    (r_row >= (ROW_START + 5*SEG_SP + SEG_L_BCEF/2) && r_row <= (ROW_START + 5*SEG_SP + SEG_L_BCEF/2 + SEG_L))) begin
                    px_data <= RED;
                end //else if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1010 (plus sign)
            
            4'b1011: begin //(minus sign)                
                // seg g
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
            
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1011 (minus sign)
            
            4'b1100: begin //(multiply sign)                
                // square to indicate multiply
                if ((r_col >= (start_col + SEG_L/2) && r_col <= (start_col + SEG_L/2 + 2*SEG_SP)) && 
                    (r_row >= (ROW_START + SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1100 (multiply sign)
            
            4'b1101: begin //(modulos sign)                
                // square 1 on top
                if ((r_col >= (start_col + SEG_L/2) && r_col <= (start_col + SEG_L/2 + 2*SEG_SP)) && 
                    (r_row >= (ROW_START + SEG_SP + SEG_L_BCEF/2) && r_row <= (ROW_START + 3*SEG_SP + SEG_L_BCEF/2))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // square 2 on the bottom
                else if ((r_col >= (start_col + SEG_L/2) && r_col <= (start_col + SEG_L/2 + 2*SEG_SP)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + 3*SEG_L_BCEF/2) && r_row <= (ROW_START + 5*SEG_SP + 3*SEG_L_BCEF/2))) begin
                    px_data <= RED;
                end //if
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1101 (modulos sign)
            
            4'b1110: begin //(equal sign)                
                // seg g (shifted up)
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 5*SEG_SP + SEG_L_BCEF/2) && r_row <= (ROW_START + 5*SEG_SP + SEG_L_BCEF/2 + SEG_W))) begin
                    px_data <= RED;
                end //if
            
                 // seg g (shifted down)
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 7*SEG_SP + 2*SEG_L_BCEF/3) && r_row <= (ROW_START + 7*SEG_SP + 2*SEG_L_BCEF/3 + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1110 (equals sign)
            
            4'b1111: begin //Overflow
                //  seg a
                if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START) && r_row <= (ROW_START + SEG_W))) begin
                    px_data <= RED;
                end //if

                // seg e
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + 3*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 3*SEG_SP + 2*SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg f
                else if ((r_col >= (start_col) && r_col <= (start_col + SEG_W)) && 
                    (r_row >= (ROW_START + SEG_SP) && r_row <= (ROW_START + SEG_SP + SEG_L_BCEF))) begin
                    px_data <= RED;
                end //if
                
                // seg g
                else if ((r_col >= (start_col + SEG_SP) && r_col <= (start_col + SEG_SP + SEG_L)) && 
                    (r_row >= (ROW_START + 2*SEG_SP + SEG_L_BCEF) && r_row <= (ROW_START + 2*SEG_SP + SEG_L_BCEF + SEG_W))) begin
                    px_data <= RED;
                end //if
                
                // No seg
                else begin
                    px_data <= BLACK;
                end //else
            end //1111
            
            default: begin
                px_data <= BLACK;
            end
            
        endcase
    end //if
        // Only instance of else WHITE, we might remove this and put it in the vga.v file
    end //always


endmodule
