`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 11.09.2023 10:19:34

// Module Name: sync_keyboard

// Description: The FPGA and Keyboard ran on different clock speeds. This module synchronizes them.

//////////////////////////////////////////////////////////////////////////////////


module sync_keyboard(
    input clk,
    input kb_clk,
    input kb_data,
    output kb_clk_sync,
    output kb_data_sync
    );
    
    // Internal registers
    reg r_kb_clk_1 = 0;
    reg r_kb_clk_2 = 0;
    reg r_kb_data_1 = 0;
    reg r_kb_data_2 = 0;
    
    // Syncronize the keyboard clock and data so that it is aligned to the FPGA clock 
    always @(posedge clk) begin
       r_kb_clk_1 <= kb_clk;
       r_kb_clk_2 <= r_kb_clk_1;
       r_kb_data_1 <= kb_data;
       r_kb_data_2 <= r_kb_data_1;
    end //always
    
    assign kb_clk_sync = r_kb_clk_2; //Connect the kb_clk output to the kb_clk register.
    assign kb_data_sync = r_kb_data_2;//Connect the kb_data output to the kb_data register.
endmodule

