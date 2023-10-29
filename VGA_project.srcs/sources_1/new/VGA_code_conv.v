`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 26.10.2023 13:15:30

// Module Name: VGA_code_conv

// Description: Not used in final project.

//////////////////////////////////////////////////////////////////////////////////


module VGA_code_conv(
    input [47:0] VGA_DISPLYA_DATA,
    output [23:0] binary_RAM_DATA 
    );
    
    
    wire [7:0] w_A_value;
    wire [7:0] w_OP_value;
    wire [7:0] w_B_value;
    
    
    BCD2BINARY2 MODUAL_A (
        .BCD_in(VGA_DISPLYA_DATA[27:16]),
        .binary_out(w_A_value)
    );
    
    BCD2BINARY2 MODUAL_OP (
        .BCD_in({8'b00000000,VGA_DISPLYA_DATA[15:12]}),
        .binary_out(w_OP_value)
    );
    
    BCD2BINARY2 MODUAL_B (
        .BCD_in(VGA_DISPLYA_DATA[11:0]),
        .binary_out(w_B_value)
    );
    
    assign RAM_DATA = {w_A_value,w_OP_value,w_B_value};
endmodule
