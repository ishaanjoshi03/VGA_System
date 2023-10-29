`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 18.10.2023 08:40:30

// Module Name: SevSegDisplay

// Description: Displays 4 numbers on 4 Seven-Segment Displays

//////////////////////////////////////////////////////////////////////////////////


module SevSegDisplay(
    input clk,
    input rst,
    input valid_code,
    input  [7:0] scan_code_in,
    
    output [3:0] ANODES,
    output [7:0] code_for_segment
    );
    
    // Internal constants
    localparam c_break_code = 8'hf0; // Keyboard break code (F0) in decimal
    localparam c_zero_code = 8'b01110000;
    
    // States
    localparam STATE_0 = 1'b0;
    localparam STATE_1 = 1'b1;
    
    // Scancode codes
    localparam EQUAL = 8'b01000101;
    localparam PLUS = 8'b01111001;
    localparam MINUS = 8'b01111011;
    localparam MULTIPLY = 8'b01111100;
    localparam MODULOS = 8'b01001010;
    localparam DELETE = 8'b01110001;
    localparam ENTER = 8'b01011010;
    localparam SPACE = 8'b00101001;
    
    localparam NUM_0 = 8'b01110000;
    localparam NUM_1 = 8'b01101001;
    localparam NUM_2 = 8'b01110010;
    localparam NUM_3 = 8'b01111010;
    localparam NUM_4 = 8'b01101011;
    localparam NUM_5 = 8'b01110011;
    localparam NUM_6 = 8'b01110100;
    localparam NUM_7 = 8'b01101100;
    localparam NUM_8 = 8'b01110101;
    localparam NUM_9 = 8'b01111101;
        
    // Internal registers
    reg [31:0] r_seg_code;
    reg [31:0] r_next_seg_code;
    reg [23:0] r_cnt_XHz; //Register to switch the segments in XHz
    reg [7:0] r_code_to_display;
    reg [7:0] r_next_code_to_display;
    reg [7:0] r_scan_code_in;
    reg [7:0] r_next_scan_code_in;
    reg [3:0] r_seg_en;
    reg [3:0] r_next_seg_en;
    reg r_current_state;
    reg r_next_state;
 
    always @(posedge clk) begin
        if(rst == 1) begin
            r_seg_code <= {c_zero_code,c_zero_code,c_zero_code,c_zero_code};
            r_code_to_display <= c_zero_code;
            r_cnt_XHz <= 0;
            r_current_state <= STATE_0;
            r_seg_en <= 4'b1110;
        end
        else begin //if(!valid_code) 
            r_seg_code <= r_next_seg_code;
            r_cnt_XHz <= r_cnt_XHz + 1;    
            r_seg_en <= r_next_seg_en;        
            r_code_to_display <= r_next_code_to_display;
            r_current_state <= r_next_state;    //Switch state
            if (r_cnt_XHz == 100000) begin  //Slower switching of segments 
                r_cnt_XHz <= 0;           
            end //if
        end //else if
    end //always
    
     always @ (*) begin
        case(r_current_state)
            STATE_0: begin
                if (valid_code && scan_code_in == c_break_code) begin
                    r_next_seg_code <= {r_seg_code[23:0],8'b0}; //Shift data and fill with zeros
                    r_next_state <= STATE_1;                     
                end //if
                else if (valid_code && scan_code_in != c_break_code) begin
                    r_next_state <= STATE_0;
                    r_next_seg_code <= r_seg_code;
                end // else if
                else begin
                    r_next_state <= r_current_state;
                    r_next_seg_code <= r_seg_code;
                end //else
            end // STATE 0
            STATE_1: begin
                if (scan_code_in == c_break_code) begin
                    r_next_state <= STATE_1;
                    r_next_seg_code <= r_seg_code;
                end // if
                else if (valid_code && scan_code_in != c_break_code) begin
                    r_next_state <= STATE_0;
                    if(scan_code_in == SPACE || scan_code_in == PLUS || scan_code_in == MINUS 
                    || scan_code_in == MODULOS || scan_code_in == MULTIPLY || scan_code_in == DELETE 
                    || scan_code_in ==  ENTER) begin
                        r_next_seg_code <= {c_zero_code,c_zero_code,c_zero_code,c_zero_code};
                    end //if
                    else begin
                        r_next_seg_code <= {r_seg_code[31:8],scan_code_in}; //Insert data
                    end                
                end // else if
                else begin
                    r_next_state <= r_current_state;
                    r_next_seg_code <= r_seg_code;
                end //else
            end // STATE 1
        endcase
    end // always
    
    always @(*) begin
        if (r_cnt_XHz == 0) begin
            if (r_seg_en == 4'b0111) begin
                    r_next_seg_en <= 4'b1110;
                    case (r_seg_en) 
                        4'b0111: r_next_code_to_display <= r_seg_code[7:0];
                        4'b1110: r_next_code_to_display <= r_seg_code[15:8];
                        4'b1101: r_next_code_to_display <= r_seg_code[23:16];
                        4'b1011: r_next_code_to_display <= r_seg_code[31:24];
                        default: r_next_code_to_display <= r_code_to_display;
                    endcase
                end //if
                else begin
                    r_next_seg_en <= {r_seg_en[2:0], 1'b1};
                    case (r_seg_en) 
                        4'b0111: r_next_code_to_display <= r_seg_code[7:0];
                        4'b1110: r_next_code_to_display <= r_seg_code[15:8];
                        4'b1101: r_next_code_to_display <= r_seg_code[23:16];
                        4'b1011: r_next_code_to_display <= r_seg_code[31:24];
                        default: r_next_code_to_display <= r_code_to_display;
                    endcase
                end //else
        end // if
        else begin
            r_next_seg_en <= r_seg_en;
            r_next_code_to_display <= r_code_to_display;
        end // else
    end // always

    assign ANODES = r_seg_en;
    assign code_for_segment = r_code_to_display;
endmodule
