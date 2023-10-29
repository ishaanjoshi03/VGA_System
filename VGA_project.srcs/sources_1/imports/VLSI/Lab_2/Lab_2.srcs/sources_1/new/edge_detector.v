`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 11.09.2023 10:19:34

// Module Name: edge_detector

// Description: Detects falling edges on keyboard's clock to make data stable before it is read.

//////////////////////////////////////////////////////////////////////////////////


module edge_detector(
    input clk,
    input rst,
    input kb_clk_sync,

    output edge_found
    );
    
    //Internal register
    reg r_current_clk_state;
    reg r_prev_clk_state;
    reg r_edge_found;
    
    // Check if the next clock state is different from the current clock state 
    // to find a falling edge.
    always @(posedge clk) begin
        if (rst == 1) begin
            r_prev_clk_state <= 0;
            //r_edge_found <= 0;
        end
        else begin
            r_prev_clk_state <= kb_clk_sync;
        end
    end //always
    
    always @ (*) begin
        r_edge_found <= (r_prev_clk_state) && (!kb_clk_sync); //I avoid using the register since the r_edge_found was driven by multible pins
    end
    
    assign edge_found = r_edge_found;   //Connect the edge_found output to the edge_found register.
endmodule
