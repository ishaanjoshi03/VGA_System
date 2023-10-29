`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Module Name: vga

// Description: Displays information on VGA monitor from ALU

//////////////////////////////////////////////////////////////////////////////////

module vga(
    input clock,
    input reset,
    input [47:0] BCD_vector,
    output horizontal_sync,
    output vertical_sync,
    output reg [11:0] rgb_color
);

    localparam COLOR_BLUE = 12'hf00;
    localparam COLOR_GREEN = 12'h0f0;
    localparam COLOR_RED = 12'h00f;
    localparam COLOR_WHITE = 12'hfff;
    
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

    reg [10:0] horizontal_counter_reg, horizontal_counter_next;
    reg [10:0] vertical_counter_reg, vertical_counter_next;
    
    wire [1:0] counter_25mhz_next;
    reg [1:0] counter_25mhz_reg;
    wire clock_25mhz = counter_25mhz_reg == 3;

    reg h_sync_reg, h_sync_next;
    reg v_sync_reg, v_sync_next;

    reg is_displaying_pixels;
    
    reg [10:0] r_curr_col;
    //Registers for enbling segments
    reg [11:0] en_seg;
    
    wire [11:0] w_io_rgb_color_0;
    wire [11:0] w_io_rgb_color_1;
    wire [11:0] w_io_rgb_color_2;
    wire [11:0] w_io_rgb_color_3;
    wire [11:0] w_io_rgb_color_4;
    wire [11:0] w_io_rgb_color_5;
    wire [11:0] w_io_rgb_color_6;
    wire [11:0] w_io_rgb_color_7;
    wire [11:0] w_io_rgb_color_8;
    wire [11:0] w_io_rgb_color_9;
    wire [11:0] w_io_rgb_color_10;
    wire [11:0] w_io_rgb_color_11;
    
    
    wire [11:0] w_io_rgb_color;
    
    always @ (posedge clock)
    begin
        if (reset == 1) begin
            horizontal_counter_reg <= 0;
            vertical_counter_reg <= 0;
            h_sync_reg <= 1;
            v_sync_reg <= 1;     
            counter_25mhz_reg <= 0;
            //io_rgb_color <= COLOR_RED;
        end 
        else begin
            horizontal_counter_reg <= horizontal_counter_next;
            vertical_counter_reg <= vertical_counter_next;
            h_sync_reg <= h_sync_next;
            v_sync_reg <= v_sync_next;     
            counter_25mhz_reg <= counter_25mhz_next;
            //io_rgb_color <= w_io_rgb_color;
        end
    end
    
    
    assign counter_25mhz_next = counter_25mhz_reg + 1;
    

    always @ (*)
    begin
        horizontal_counter_next = horizontal_counter_reg;
        vertical_counter_next = vertical_counter_reg;            
        
        if (clock_25mhz) begin
            if (horizontal_counter_reg == NUM_HORIZONTAL_ALL_PIXELS-1) begin
                horizontal_counter_next = 0;
            end
            else begin
                horizontal_counter_next = horizontal_counter_reg + 1;
            end
            
            if (horizontal_counter_reg == NUM_HORIZONTAL_ALL_PIXELS-1) begin
                vertical_counter_next = vertical_counter_reg + 1;
                if (vertical_counter_reg == NUM_VERTICAL_ALL_PIXELS-1) begin
                    vertical_counter_next = 0;
                end
            end
        end
    end
    
    
    always @ (*)
    begin
        h_sync_next = h_sync_reg;
        v_sync_next = v_sync_reg;      
        
        if (clock_25mhz) begin            
            if (
                horizontal_counter_reg >= NUM_HORIZONTAL_VISIBLE_PIXELS + NUM_HORIZONTAL_FRONT_PORCH_PIXELS &&
                horizontal_counter_reg < NUM_HORIZONTAL_VISIBLE_PIXELS + NUM_HORIZONTAL_FRONT_PORCH_PIXELS + NUM_HORIZONTAL_SYNC_PIXELS
            ) begin
                h_sync_next = 0;
            end
            else begin
                h_sync_next = 1;
            end
            
            if (
                vertical_counter_reg >= NUM_VERTICAL_VISIBLE_PIXELS + NUM_VERTICAL_FRONT_PORCH_PIXELS &&
                vertical_counter_reg < NUM_VERTICAL_VISIBLE_PIXELS + NUM_VERTICAL_FRONT_PORCH_PIXELS + NUM_VERTICAL_SYNC_PIXELS
            ) begin
                v_sync_next = 0;
            end
            else begin
                v_sync_next = 1;
            end                              
        end                      
    end
        
        
    always @ (*)
    begin
        is_displaying_pixels = 1'b0;              
        if (horizontal_counter_reg < NUM_HORIZONTAL_VISIBLE_PIXELS && vertical_counter_reg < NUM_VERTICAL_VISIBLE_PIXELS) begin
            is_displaying_pixels = 1'b1;
        end                          
    end
    
    
    always @ (*) begin
        rgb_color = 0;
        if(is_displaying_pixels) begin
            if (horizontal_counter_reg >= 3 && horizontal_counter_reg <= 55) begin
                r_curr_col <= 2;
                en_seg <= 12'b000000000001;
                rgb_color = w_io_rgb_color_0;
            end // if
            else if (horizontal_counter_reg >= 56 && horizontal_counter_reg <= 108) begin
                r_curr_col <= 56;
                en_seg <= 12'b000000000010;
                rgb_color = w_io_rgb_color_1;
            end // else if
            else if (horizontal_counter_reg >= 109 && horizontal_counter_reg <= 161) begin
                r_curr_col <= 109;
                en_seg <= 12'b000000000100;
                rgb_color = w_io_rgb_color_2;
            end // else if
            else if (horizontal_counter_reg >= 162 && horizontal_counter_reg <= 214) begin
                r_curr_col <= 162;
                en_seg <= 12'b000000001000;
                rgb_color = w_io_rgb_color_3;
            end // else if
            else if (horizontal_counter_reg >= 215 && horizontal_counter_reg <= 267) begin
                r_curr_col <= 215;
                en_seg <= 12'b000000010000;
                rgb_color = w_io_rgb_color_4;
            end // else if
            else if (horizontal_counter_reg >= 268 && horizontal_counter_reg <= 320) begin
                r_curr_col <= 268;
                en_seg <= 12'b000000100000;
                rgb_color = w_io_rgb_color_5;
            end // else if
            else if (horizontal_counter_reg >= 321 && horizontal_counter_reg <= 373) begin
                r_curr_col <= 321;
                en_seg <= 12'b000001000000;
                rgb_color = w_io_rgb_color_6;
            end // else if
            else if (horizontal_counter_reg >= 374 && horizontal_counter_reg <= 426) begin
                r_curr_col <= 374;
                en_seg <= 12'b000010000000;
                rgb_color = w_io_rgb_color_7;
            end // else if
            else if (horizontal_counter_reg >= 427 && horizontal_counter_reg <= 479) begin
                r_curr_col <= 427;
                en_seg <= 12'b000100000000;
                rgb_color = w_io_rgb_color_8;
            end // else if
            else if (horizontal_counter_reg >= 480 && horizontal_counter_reg <= 532) begin
                r_curr_col <= 480;
                en_seg <= 12'b001000000000;
                rgb_color = w_io_rgb_color_9;
            end // else if
            else if (horizontal_counter_reg >= 533 && horizontal_counter_reg <= 585) begin
                r_curr_col <= 533;
                en_seg <= 12'b010000000000;
                rgb_color = w_io_rgb_color_10;
            end // else if
            else if (horizontal_counter_reg >= 586 && horizontal_counter_reg <= 638) begin
                r_curr_col <= 586;
                en_seg <= 12'b100000000000;
                rgb_color = w_io_rgb_color_11;
            end // else if
        end// if
    end // always
    
    ROM_ONE UUDROM0 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[0]),
        .BCD(BCD_vector[47:44]),
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_0)
    );
    
    ROM_ONE UUDROM1 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[1]),
        .BCD(BCD_vector[43:40]),
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_1)
    );
    
    ROM_ONE UUDROM2 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[2]),
        .BCD(BCD_vector[39:36]), 
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_2)
    );
    
    ROM_ONE UUDROM3 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[3]),
        .BCD(BCD_vector[35:32]), 
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_3)
    );
    
    ROM_ONE UUDROM4 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[4]),
         .BCD(BCD_vector[31:28]), 
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_4)
    );
    
    ROM_ONE UUDROM5 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[5]),
        .BCD(BCD_vector[27:24]), 
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_5)
    );
    
    ROM_ONE UUDROM6 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[6]),
        .BCD(BCD_vector[23:20]), 
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_6)
    );
    
    ROM_ONE UUDROM7 (  //Segment for equals sign, should always be the same
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[7]),
        .BCD(BCD_vector[19:16]), 
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_7)
    );
    
    ROM_ONE UUDROM8 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[8]),
        .BCD(BCD_vector[15:12]),
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_8)
    );
    
    ROM_ONE UUDROM9 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[9]),
         .BCD(BCD_vector[11:8]),
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_9)
    );
    
    ROM_ONE UUDROM10 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[10]),
         .BCD(BCD_vector[7:4]),
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_10)
    );
    
    ROM_ONE UUDROM11 (
        .clk(clock), 
        .start_col(r_curr_col),
        .en_draw(is_displaying_pixels),
        .en_seg(en_seg[11]),
         .BCD(BCD_vector[3:0]),
        .row(vertical_counter_reg),   
        .col(horizontal_counter_reg),    
        .px_data(w_io_rgb_color_11)
    );
        
    assign horizontal_sync = h_sync_reg;
    assign vertical_sync = v_sync_reg;        
endmodule
