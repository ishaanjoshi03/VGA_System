`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 11.09.2023 10:19:34

// Module Name: binary_to_sg

// Description: Converts binary numbers to their 7Segment representations

//////////////////////////////////////////////////////////////////////////////////


module binary_to_sg(
    input [3:0] binary_in,
    output [7:0] sev_seg
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
    
    reg [7:0] r_sev_seg;
    
    
    always @(binary_in) begin
        case(binary_in)
            4'b0000: r_sev_seg <= NUM_0;
            4'b0001: r_sev_seg <= NUM_1;
            4'b0010: r_sev_seg <= NUM_2;
            4'b0011: r_sev_seg <= NUM_3;
            4'b0100: r_sev_seg <= NUM_4;
            4'b0101: r_sev_seg <= NUM_5;
            4'b0110: r_sev_seg <= NUM_6;
            4'b0111: r_sev_seg <= NUM_7;
            4'b1000: r_sev_seg <= NUM_8;
            4'b1001: r_sev_seg <= NUM_9;
            4'b1010: r_sev_seg <= NUM_E;
            default: r_sev_seg <= NUM_0; // change to error signal eventually
        endcase
    end //always
    
    assign sev_seg = r_sev_seg;
endmodule
