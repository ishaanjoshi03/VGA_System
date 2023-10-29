`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 11.09.2023 10:19:34

// Module Name: keyboard_ctrl

// Description: Detects "make break make" scancodes that indicate a key was pressed.
//              Also sends signals for the type of key pressed.

//////////////////////////////////////////////////////////////////////////////////


module keyboard_ctrl(
    input clk,
    input rst,
    input valid_code,
    input  [7:0] scan_code_in,

    output [7:0] scan_code_out,
    output [2:0] op_signal
    );
    
    // Internal constants
    localparam c_break_code = 8'hf0; // Keyboard break code (F0) in decimal
    localparam c_zero_code = 8'b01110000;
    
    localparam PLUS = 8'b01111001;
    localparam MINUS = 8'b01111011;
    localparam MULTIPLY = 8'b01111100;
    localparam MODULOS = 8'b01001010;
    localparam DELETE = 8'b01110001;
    localparam ENTER = 8'b01011010;
    localparam EQUAL = 8'b01000101;
    localparam SPACE = 8'b00101001;
    
    // States
    localparam STATE_0 = 1'b0;
    localparam STATE_1 = 1'b1;
    localparam STATE_2 = 2'b10;
    localparam STATE_3 = 2'b11;
    
    // Operation Representations
    localparam NUM_FOUND = 3'b000;
    localparam OP_FOUND = 3'b001;
    localparam DELETE_FOUND = 3'b010;
    localparam ENTER_FOUND = 3'b011;
    localparam EQUAL_FOUND = 3'b100;
    localparam NOTHING = 3'b111;
    
    // I wanna use these as the op-signals because we can use then to control the operation in the ALU 
    // and other spots as well
    localparam PLUS_SIGN = 4'b1010; //10
    localparam MINUS_SIGN = 4'b1011; //11
    localparam MULTIPLICATION_SIGN = 4'b1100; //12
    localparam MODULUS_SIGN = 4'b1101; //13
    localparam EQUAL_SIGN = 4'b1110; //14
    localparam OVERFLOW_SIGN = 4'b1111; //15
    
    // Internal registers

    reg [7:0] r_code_to_display;
    reg [7:0] r_next_code_to_display;
    reg r_current_state;
    reg r_next_state;
    reg [2:0] r_op_signal;
    reg [2:0] r_next_op_signal;
 
    always @(posedge clk) begin
        if(rst == 1) begin
            r_code_to_display <= c_zero_code;
            r_current_state <= STATE_0;
            r_op_signal <= 3'b0;
        end
        else begin        
            r_code_to_display <= r_next_code_to_display;
            r_current_state <= r_next_state;    //Switch state
            r_op_signal <= r_next_op_signal;
        end //else if
    end //always
    
     always @ (*) begin
        case(r_current_state)
            STATE_0: begin
                if (valid_code && scan_code_in == c_break_code) begin
                    r_next_code_to_display <= r_code_to_display;
                    r_next_state <= STATE_1;    
                    r_next_op_signal <= NOTHING; // do nothing signal                 
                end //if
                else if (valid_code && scan_code_in != c_break_code) begin
                    r_next_state <= STATE_0;
                    r_next_code_to_display <= r_code_to_display;
                    r_next_op_signal <= NOTHING; // do nothing signal
                end // else if
                else begin
                    r_next_state <= r_current_state;
                    r_next_code_to_display <= r_code_to_display;
                    r_next_op_signal <= NOTHING; // do nothing signal
                end //else
            end // STATE 0
            STATE_1: begin
                if (scan_code_in == c_break_code) begin
                    r_next_state <= STATE_1;
                    r_next_code_to_display <= r_code_to_display;
                    r_next_op_signal <= NOTHING; // do nothing signal
                end // if
                else if (valid_code && scan_code_in != c_break_code) begin
                    r_next_state <= STATE_0;
                    r_next_code_to_display <= scan_code_in;
                    case (scan_code_in)
                        // send signal that operation found
                        PLUS: r_next_op_signal <= OP_FOUND;
                        MINUS: r_next_op_signal <= OP_FOUND;
                        MODULOS: r_next_op_signal <= OP_FOUND;
                        MULTIPLY: r_next_op_signal <= OP_FOUND;
                        
                        // send signal that delete found
                        DELETE: r_next_op_signal <= DELETE_FOUND;
                        
                        // send signal that enter found
                        ENTER: r_next_op_signal <= ENTER_FOUND;
                        
                        // send signal that equal found
                        SPACE: r_next_op_signal <= EQUAL_FOUND;
                    
                        // send signal that a number was found
                        default: r_next_op_signal <= NUM_FOUND;
                    endcase
                end // else if
                else begin
                    r_next_state <= r_current_state;
                    r_next_code_to_display <= r_code_to_display;
                    r_next_op_signal <= NOTHING; // do nothing signal
                end //else
            end // STATE 1
        endcase
    end // always
    
   
    // Connects outputs to registers
    assign scan_code_out = r_code_to_display;
    assign op_signal = r_op_signal; 

    
endmodule
