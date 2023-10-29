`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 11.09.2023 10:19:34

// Module Name: convert_to_binary

// Description: LUT to convert scan code representations of keys to their binary representations

//////////////////////////////////////////////////////////////////////////////////


module convert_to_binary(
    input [7:0] scan_code_in,
    output [7:0] binary_out
    );
    
    //LUT                           //LD0
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
    
    
    reg [7:0] r_binary_out;
    
    
    always @ (scan_code_in) begin
        case (scan_code_in)
            NUM_0: r_binary_out <= 8'b00000000;
            NUM_1: r_binary_out <= 8'b00000001;
            NUM_2: r_binary_out <= 8'b00000010;
            NUM_3: r_binary_out <= 8'b00000011;
            NUM_4: r_binary_out <= 8'b00000100;
            NUM_5: r_binary_out <= 8'b00000101;
            NUM_6: r_binary_out <= 8'b00000110;
            NUM_7: r_binary_out <= 8'b00000111;
            NUM_8: r_binary_out <= 8'b00001000;
            NUM_9: r_binary_out <= 8'b00001001;
            PLUS: r_binary_out <= 8'b10000010;
            MINUS: r_binary_out <= 8'b10000011;
            MULTIPLY: r_binary_out <= 8'b10000100;
            MODULOS: r_binary_out <= 8'b10000101;
            SPACE: r_binary_out <= 8'b00001110;
            default: r_binary_out <= 8'b00001111; // # 10: Error, NEED TO CHANGE LATER ON
        endcase
    end //always
    
    assign binary_out = r_binary_out;
endmodule
