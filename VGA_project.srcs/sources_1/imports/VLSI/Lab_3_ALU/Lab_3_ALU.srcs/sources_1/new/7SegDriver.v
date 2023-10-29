`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 23.09.2023 10:19:03

// Module Name: 7SegDriver

// Description: 

//////////////////////////////////////////////////////////////////////////////////


module SevenSegDriver(
    input clk,
    input reset,
    input [11:0] BCD_digit,
    input sign,
    input overflow,
    output [3:0] DIGIT_ANODE,
    output [7:0] SEGMENT
    );
    
    //LUT
    localparam NUM_0 = 8'b11000000;
    localparam NUM_1 = 8'b11111001;
    localparam NUM_2 = 8'b10100100;
    localparam NUM_3 = 8'b10110000;
    localparam NUM_4 = 8'b10011001;
    localparam NUM_5 = 8'b10010010;
    localparam NUM_6 = 8'b10000010;
    localparam NUM_7 = 8'b11111000;
    localparam NUM_8 = 8'b10000000;
    localparam NUM_9 = 8'b10011000;
    localparam NUM_E = 8'b10000110;
    localparam NULL = 8'b11111111;
    localparam MINUS_SIGN = 8'b10111111;
    localparam LETTER_O = 8'b11000000;
    localparam LETTER_V = 8'b11010101;
    localparam LETTER_R = 8'b00000100;
    localparam LETTER_F = 8'b10001110;
    
    reg [31:0] r_sev_seg;
    reg [31:0] r_next_sev_seg;
    reg [19:0] r_cnt_XHz; //Register to switch the segments in XHz
    reg [3:0] r_seg_en;
    reg [3:0] r_next_seg_en; 
    reg [7:0] r_code_to_display;
    reg [7:0] r_next_code_to_display;
    
    always @(posedge clk) begin
        if(reset == 1) begin
            r_sev_seg <= 31'b0;
            r_cnt_XHz <= 19'b0;
            r_seg_en <= 4'b1110;
            r_code_to_display <= 8'b11000000;
        end //if
        else begin
            r_sev_seg <= r_next_sev_seg;
            r_seg_en <= r_next_seg_en;
            r_code_to_display <= r_next_code_to_display;
            r_cnt_XHz <= r_cnt_XHz + 1'b1;
            if (r_cnt_XHz == 100000) begin  //Slower switching of segments (syn_val = 100000)
                r_cnt_XHz <= 0;           
            end //if
        end //else
    end //always
    
    always @(*) begin
        case(BCD_digit[3:0])
            4'b0000: r_next_sev_seg[7:0] <= NUM_0;
            4'b0001: r_next_sev_seg[7:0] <= NUM_1;
            4'b0010: r_next_sev_seg[7:0] <= NUM_2;
            4'b0011: r_next_sev_seg[7:0] <= NUM_3;
            4'b0100: r_next_sev_seg[7:0] <= NUM_4;
            4'b0101: r_next_sev_seg[7:0] <= NUM_5;
            4'b0110: r_next_sev_seg[7:0] <= NUM_6;
            4'b0111: r_next_sev_seg[7:0] <= NUM_7;
            4'b1000: r_next_sev_seg[7:0] <= NUM_8;
            4'b1001: r_next_sev_seg[7:0] <= NUM_9;
            4'b1010: r_next_sev_seg[7:0] <= NUM_E;
            default: r_next_sev_seg[7:0] <= NUM_0; // change to error signal eventually
        endcase
        
        case(BCD_digit[7:4])
            4'b0000: r_next_sev_seg[15:8] <= NUM_0;
            4'b0001: r_next_sev_seg[15:8] <= NUM_1;
            4'b0010: r_next_sev_seg[15:8] <= NUM_2;
            4'b0011: r_next_sev_seg[15:8] <= NUM_3;
            4'b0100: r_next_sev_seg[15:8] <= NUM_4;
            4'b0101: r_next_sev_seg[15:8] <= NUM_5;
            4'b0110: r_next_sev_seg[15:8] <= NUM_6;
            4'b0111: r_next_sev_seg[15:8] <= NUM_7;
            4'b1000: r_next_sev_seg[15:8] <= NUM_8;
            4'b1001: r_next_sev_seg[15:8] <= NUM_9;
            4'b1010: r_next_sev_seg[15:8] <= NUM_E;
            default: r_next_sev_seg[15:8] <= NUM_0; // change to error signal eventually
        endcase
        
        case(BCD_digit[11:8])
            4'b0000: r_next_sev_seg[23:16] <= NUM_0;
            4'b0001: r_next_sev_seg[23:16] <= NUM_1;
            4'b0010: r_next_sev_seg[23:16] <= NUM_2;
            4'b0011: r_next_sev_seg[23:16] <= NUM_3;
            4'b0100: r_next_sev_seg[23:16] <= NUM_4;
            4'b0101: r_next_sev_seg[23:16] <= NUM_5;
            4'b0110: r_next_sev_seg[23:16] <= NUM_6;
            4'b0111: r_next_sev_seg[23:16] <= NUM_7;
            4'b1000: r_next_sev_seg[23:16] <= NUM_8;
            4'b1001: r_next_sev_seg[23:16] <= NUM_9;
            4'b1010: r_next_sev_seg[23:16] <= NUM_E;
            default: r_next_sev_seg[23:16] <= NULL; // change to error signal eventually
        endcase
        if(overflow) begin
            r_next_sev_seg[31:24] <= LETTER_F;
        end //if
        else if(sign) begin
            r_next_sev_seg[31:24] <= MINUS_SIGN;
        end //else if
        else begin
            r_next_sev_seg[31:24] <= NULL;
        end //else 
    end //always
    
    always @(*) begin
        if (r_cnt_XHz == 0) begin
            if (r_seg_en == 4'b0111) begin
                    r_next_seg_en <= 4'b1110;
                    case (r_seg_en) 
                        4'b0111: r_next_code_to_display <= r_sev_seg[7:0];
                        4'b1110: r_next_code_to_display <= r_sev_seg[15:8];
                        4'b1101: r_next_code_to_display <= r_sev_seg[23:16];
                        4'b1011: r_next_code_to_display <= r_sev_seg[31:24];
                        default: r_next_code_to_display <= r_code_to_display;
                    endcase
                end //if
                else begin
                    r_next_seg_en <= {r_seg_en[2:0], 1'b1};
                    case (r_seg_en) 
                        4'b0111: r_next_code_to_display <= r_sev_seg[7:0];
                        4'b1110: r_next_code_to_display <= r_sev_seg[15:8];
                        4'b1101: r_next_code_to_display <= r_sev_seg[23:16];
                        4'b1011: r_next_code_to_display <= r_sev_seg[31:24];
                        default: r_next_code_to_display <= r_code_to_display;
                    endcase
                end //else
        end // if
        else begin
            r_next_seg_en <= r_seg_en;
            r_next_code_to_display <= r_code_to_display;
        end // else
    end // always
    
    assign DIGIT_ANODE = r_seg_en;
    assign SEGMENT = r_code_to_display;
endmodule
