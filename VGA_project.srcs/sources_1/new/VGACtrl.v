`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 26.10.2023 10:19:44

// Module Name: VGACtrl

// Description: Displays live information from keyboard presses

//////////////////////////////////////////////////////////////////////////////////


module VGACtrl(
    input clk,
    input rst,
    input valid_code,
    input  [7:0] scan_code_in,
    output [47:0] VGA_DISPLYA_DATA
    );
    
    
    // Internal constants
    localparam c_break_code = 8'hf0; //Possibly the break code (F0) in decimal
    localparam c_zero_code = 8'b01110000;
    localparam c_seg_zeros = {c_zero_code,c_zero_code,c_zero_code};
    
    localparam c_BCD_zero = 4'b0000;
    localparam c_five_BCD_zero = {c_BCD_zero,c_BCD_zero,c_BCD_zero,c_BCD_zero,c_BCD_zero};
    
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
    
    localparam PLUS_SIGN = 4'b1010; //10
    localparam MINUS_SIGN = 4'b1011; //11
    localparam MULTIPLICATION_SIGN = 4'b1100; //12
    localparam MODULUS_SIGN = 4'b1101; //13
    localparam EQUAL_SIGN = 4'b1110; //14
    
    // Operation Representations
    localparam NUM_FOUND = 3'b000;
    localparam OP_FOUND = 3'b001;
    localparam DELETE_FOUND = 3'b010;
    localparam ENTER_FOUND = 3'b011;
    localparam EQUAL_FOUND = 3'b100;
    localparam NOTHING = 3'b111;
    
    localparam END_SEQ = {EQUAL_SIGN,EQUAL_SIGN,EQUAL_SIGN,EQUAL_SIGN,EQUAL_SIGN};
    localparam MINUS_SEQ = {EQUAL_SIGN,EQUAL_SIGN,EQUAL_SIGN};
    
    reg [55:0] r_scan_code_vector;
    reg [55:0] r_next_scan_code_vector;
    reg [3:0] r_op_code;
    reg [3:0] r_next_op_code;
    reg r_current_state;
    reg r_next_state;
    reg r_op_found;
    reg r_next_op_found;
    
    wire [7:0] w_binary0;
    wire [7:0] w_binary1;
    wire [7:0] w_binary2;
    wire [7:0] w_binary3;
    wire [7:0] w_binary4;
    wire [7:0] w_binary5;
    wire [7:0] w_binary6;
    
    wire [11:0] w_BCD0;
    wire [11:0] w_BCD1;
    wire [11:0] w_BCD2;
    wire [11:0] w_BCD3;
    wire [11:0] w_BCD4;
    wire [11:0] w_BCD5;
    wire [11:0] w_BCD6;
    
    
    always @(posedge clk) begin
        if(rst == 1) begin
//            r_BCD_vga <= {ZERO_SIGN,ZERO_SIGN,ZERO_SIGN,ZERO_SIGN};
            r_scan_code_vector <= {MINUS_SEQ,c_zero_code,c_seg_zeros};
            r_current_state <= 1'b0;
            r_op_found <= 1'b0;
            r_op_code <= 4'b1111;
        end //if
        else begin
//            r_BCD_vga <= r_next_BCD_vga;
            r_scan_code_vector <= r_next_scan_code_vector;
            r_current_state <= r_next_state;
            r_op_found <= r_next_op_found;
            r_op_code <= r_next_op_code;
        end //else
    end //always
    
    always @ (*) begin
        case(r_current_state)
            STATE_0: begin
                if (valid_code && scan_code_in == c_break_code) begin
                    r_next_scan_code_vector <= r_scan_code_vector; 
                    r_next_state <= STATE_1;   
                    r_next_op_found <= r_op_found;   
                    r_next_op_code <= r_op_code;   
//                    op_signal <= NOTHING;            
                end //if
                else if (valid_code && scan_code_in != c_break_code) begin
                    r_next_state <= STATE_0;
                    r_next_scan_code_vector <= r_scan_code_vector;
                    r_next_op_found <= r_op_found;
                    r_next_op_code <= r_op_code;
//                    op_signal <= NOTHING; 
                end // else if
                else begin
                    r_next_state <= r_current_state;
                    r_next_scan_code_vector <= r_scan_code_vector;
                    r_next_op_found <= r_op_found;
                    r_next_op_code <= r_op_code;
//                    op_signal <= NOTHING; 
                end //else
            end // STATE 0
            STATE_1: begin
                if (scan_code_in == c_break_code) begin
                    r_next_state <= STATE_1;
                    r_next_scan_code_vector <= r_scan_code_vector;
                    r_next_op_found <= r_op_found;
                    r_next_op_code <= r_op_code;
//                    op_signal <= NOTHING; 
                end // if
                else if (valid_code && scan_code_in != c_break_code) begin
                    r_next_state <= STATE_0;
                    if(scan_code_in == PLUS || scan_code_in == MINUS 
                    || scan_code_in == MODULOS || scan_code_in == MULTIPLY) begin
                        case(scan_code_in) 
                            PLUS: r_next_op_code <= PLUS_SIGN;
                            MINUS: r_next_op_code <= MINUS_SIGN;
                            MODULOS: r_next_op_code <= MODULUS_SIGN;
                            MULTIPLY: r_next_op_code <= MULTIPLICATION_SIGN;
                            default: r_next_op_code <= r_op_code;
                        endcase
//                        r_next_scan_code_vector <= {r_scan_code_vector[55:32],scan_code_in,r_scan_code_vector[23:0]};
                        r_next_scan_code_vector <= {MINUS_SEQ,scan_code_in,r_scan_code_vector[23:0]};
                        r_next_op_found <= 1'b1;
//                        op_signal <= OP_FOUND; 
                    end //if
                    else if(scan_code_in == DELETE) begin
                        r_next_op_found <= 1'b0;
                        r_next_op_code <= r_op_code;
//                        op_signal <= DELETE_FOUND;
                        r_next_scan_code_vector <= {r_scan_code_vector[55:24],c_seg_zeros};
//                        if(r_op_found) begin
//                            r_next_scan_code_vector <= {c_seg_zeros,r_scan_code_vector[31:0]};
//                        end 
//                        else begin
//                            r_next_scan_code_vector <= {r_scan_code_vector[55:24],c_seg_zeros};
//                        end
                    end //else if
                    else if(scan_code_in == ENTER) begin
                        r_next_scan_code_vector <= {MINUS_SEQ,c_zero_code,c_seg_zeros};
                        r_next_op_found <= 1'b0;
                        r_next_op_code <= r_op_code;
//                        op_signal <= ENTER_FOUND;
                    end //else if
                    else if(scan_code_in == SPACE) begin
                        r_next_scan_code_vector <= {MINUS_SEQ,c_zero_code,c_seg_zeros};
                        r_next_op_found <= r_op_found;
                        r_next_op_code <= 4'b1111;
//                        op_signal <= EQUAL_FOUND;
                    end //else if
                    else begin //If we find a number or something else
                        r_next_op_code <= r_op_code;
//                        op_signal <= NUM_FOUND; 
                        r_next_scan_code_vector <= {r_scan_code_vector[55:24],r_scan_code_vector[15:0],scan_code_in};
//                        if(r_op_found) begin
//                            r_next_scan_code_vector <= {r_scan_code_vector[48:32],scan_code_in,r_scan_code_vector[31:0]};
//                            r_next_op_found <= r_op_found;
//                        end 
//                        else begin
//                            r_next_scan_code_vector <= {r_scan_code_vector[55:24],r_scan_code_vector[15:0],scan_code_in};
//                            r_next_op_found <= r_op_found;
//                        end
                    end                
                end // else if
                else begin
                    r_next_state <= r_current_state;
                    r_next_scan_code_vector <= r_scan_code_vector;
                    r_next_op_found <= r_op_found;
                    r_next_op_code <= r_op_code;
                end //else
            end // STATE 1
        endcase
    end // always
    
    convert_to_binary CONVMOD0(
        .scan_code_in(r_scan_code_vector[55:48]),
        .binary_out(w_binary6)
    );
    
    convert_to_binary CONVMOD1(
        .scan_code_in(r_scan_code_vector[47:40]),
        .binary_out(w_binary5)
    );
    
    convert_to_binary CONVMOD2(
        .scan_code_in(r_scan_code_vector[39:32]),
        .binary_out(w_binary4)
    );
    
    convert_to_binary CONVMOD3(
        .scan_code_in(r_scan_code_vector[31:24]),
        .binary_out(w_binary3)
    );
    
    convert_to_binary CONVMOD4(
        .scan_code_in(r_scan_code_vector[23:16]),
        .binary_out(w_binary2)
    );
    
    convert_to_binary CONVMOD5(
        .scan_code_in(r_scan_code_vector[15:8]),
        .binary_out(w_binary1)
    );
    
    convert_to_binary CONVMOD6(
        .scan_code_in(r_scan_code_vector[7:0]),
        .binary_out(w_binary0)
    );
    /////////////////////////////////////////////////////////////////7
    Binary2BCD CONVMODBCD0(
        .binary_in(w_binary6),
        .BCD_out(w_BCD6)
    );
    
    Binary2BCD CONVMODBCD1(
        .binary_in(w_binary5),
        .BCD_out(w_BCD5)
    );
    
    Binary2BCD CONVMODBCD2(
        .binary_in(w_binary4),
        .BCD_out(w_BCD4)
    );
    
    Binary2BCD CONVMODBCD3(
        .binary_in(w_binary3),
        .BCD_out(w_BCD3)
    );
    
    Binary2BCD CONVMODBCD4(
        .binary_in(w_binary2),
        .BCD_out(w_BCD2)
    );
    
    Binary2BCD CONVMODBCD5(
        .binary_in(w_binary1),
        .BCD_out(w_BCD1)
    );
    
    Binary2BCD CONVMODBCD6(
        .binary_in(w_binary0),
        .BCD_out(w_BCD0)
    );
    
    assign VGA_DISPLYA_DATA = {w_BCD2[3:0],w_BCD1[3:0],w_BCD0[3:0],r_op_code,MINUS_SEQ,END_SEQ};
endmodule
