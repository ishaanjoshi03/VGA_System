`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 11.09.2023 10:19:34

// Module Name: convert_scancode

// Description: Converts serial keyboard data to parallel scan codes

//////////////////////////////////////////////////////////////////////////////////


module convert_scancode(
    input clk,
    input rst,
    input edge_found,
    input serial_data,
    output valid_scan_code,
    output [7:0] scan_code_out
    );
    
    // Internal constants
    localparam c_bit_cnt = 8;   //Number of bits to shift
    
    // Internal registers
    reg [9:0] r_scan_code;
    reg [9:0] r_next_scan_code;
    reg [3:0] r_bit_cnt;
    reg [3:0] r_next_bit_cnt; 
    reg r_valid_scan_code;
    reg r_next_valid_scan_code;
    
    // The incoming data from the keyboard is leftshifted into a register and 
    // when all the bits are shifted the valid_scan_code bit is set high
   

    always @(posedge clk) begin
        if (rst == 1) begin // Synchronous Reset
            r_bit_cnt <= 4'b0000;
            r_scan_code <= 10'b0000000000;
            r_valid_scan_code <= 1'b0;
        end //if
        else begin
            r_bit_cnt <= r_next_bit_cnt;
            r_scan_code <= r_next_scan_code;
            r_valid_scan_code <= r_next_valid_scan_code;
        end //else
    end //always
    
    always @(*) begin
        if(edge_found && r_bit_cnt == 9) begin
            r_next_bit_cnt <= r_bit_cnt + 1;
            r_next_scan_code <= r_scan_code;
            r_next_valid_scan_code <= 1'b1;
        end //if
        else if(edge_found && r_bit_cnt == 10) begin
            r_next_bit_cnt <= 1'b0;
            r_next_scan_code <= r_scan_code;
            r_next_valid_scan_code <= 1'b1;
        end //else if
        else if(edge_found && r_bit_cnt >= 0 && r_bit_cnt < 9)begin
            r_next_bit_cnt <= r_bit_cnt + 1;
            r_next_scan_code <= {serial_data, r_scan_code[9:1]};
            r_next_valid_scan_code <= 1'b0;
        end //else
        else begin
            r_next_bit_cnt <= r_bit_cnt;                            
            r_next_scan_code <= r_scan_code;
            r_next_valid_scan_code <= r_valid_scan_code;  
        end
    end //always
    
    
    // Connects registers to outputs
    assign valid_scan_code = r_valid_scan_code; 
    assign scan_code_out = r_scan_code[9:2]; 
endmodule
