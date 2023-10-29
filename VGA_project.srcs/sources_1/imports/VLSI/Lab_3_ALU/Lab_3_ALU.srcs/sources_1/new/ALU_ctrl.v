`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 23.09.2023 10:19:03

// Module Name: ALU_ctrl

// Description: Holds numbers in temporary registers until proper sequences are detected.
//              Data is received from RAM pops.

//////////////////////////////////////////////////////////////////////////////////


module ALU_ctrl(
        input clk,
        input rst,
        input [7:0] data_in,
        input ALU_fsm_en,

        output [7:0] o_A,
        output [3:0] o_OP, // conforming to ALU signals previously used to limit changing code
        output [7:0] o_B,
        output calc_en
    );

    localparam STATE_0 = 2'b00;
    localparam STATE_1 = 2'b01;
    localparam STATE_2 = 2'b10;

    localparam PLUS_BINARY = 8'b10000010;
    localparam MINUS_BINARY = 8'b10000011;
    localparam MULTIPLY_BINARY = 8'b10000100;
    localparam MODULOS_BINARY = 8'b10000101;
    
    // VGA codes for non-numbers
    localparam PLUS_SIGN = 4'b1010; //10
    localparam MINUS_SIGN = 4'b1011; //11
    localparam MULTIPLICATION_SIGN = 4'b1100; //12
    localparam MODULUS_SIGN = 4'b1101; //13
    localparam EQUAL_SIGN = 4'b1110; //14
    localparam OVERFLOW_SIGN = 4'b1111; //15

    reg [1:0] r_state;
    reg [1:0] r_next_state;
    reg [7:0] r_A;
    reg [7:0] r_B;
    reg [3:0] r_OP;
    reg [7:0] r_next_A;
    reg [7:0] r_next_B;
    reg [3:0] r_next_OP;
    reg [7:0] r_temp_A;
    reg [7:0] r_temp_B;
    reg [3:0] r_temp_OP;
    reg [7:0] r_next_temp_A;
    reg [7:0] r_next_temp_B;
    reg [3:0] r_next_temp_OP;
    reg r_calc_en; // acts as Mealy output to state machine
    reg r_next_calc_en;

    always @ (posedge clk) begin
        if (rst == 1) begin
            r_state <= STATE_0;
            r_A <= 8'b0;
            r_OP <= 4'b0;
            r_B <= 8'b0;
            r_temp_A <= 8'b0;
            r_temp_OP <= 4'b0;
            r_temp_B <= 8'b0;
            r_calc_en <= 1'b0;
        end
        else begin
            r_state <= r_next_state;
            r_A <= r_next_A;
            r_OP <= r_next_OP;
            r_B <= r_next_B;
            r_temp_A <= r_next_temp_A;
            r_temp_OP <= r_next_temp_OP;
            r_temp_B <= r_next_temp_B;
            r_calc_en <= r_next_calc_en;
        end
    end // always

    always @ (*) begin
        if (ALU_fsm_en) begin
        case(r_state)
            STATE_0: begin
                if (data_in == PLUS_BINARY || data_in == MINUS_BINARY || data_in == MULTIPLY_BINARY) begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_temp_A <= r_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= r_OP;
                    r_next_state <= STATE_0;
                end
                else if (data_in == MODULOS_BINARY) begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_temp_A <= r_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= r_OP;
                    r_next_state <= STATE_0;
                end
                else begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_temp_A <= data_in;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= r_OP;
                    r_next_state <= STATE_1;
                end
            end
            STATE_1: begin
                if (data_in == PLUS_BINARY) begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP; 
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= PLUS_SIGN; // FN = Unsigned Addition for ALU
                    r_next_state <= STATE_2;
                end
                else if (data_in == MINUS_BINARY) begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP; 
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= MINUS_SIGN; // FN = Unsigned Subtraction for ALU
                    r_next_state <= STATE_2;
                end
                else if (data_in == MULTIPLY_BINARY) begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP; 
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= MULTIPLICATION_SIGN; // FN = Unsigned Multiplication for ALU
                    r_next_state <= STATE_2;
                end
                else if (data_in == MODULOS_BINARY) begin 
                    r_next_calc_en <= 1'b1; 
                    r_next_A <= r_temp_A;
                    r_next_B <= 8'b00000011;
                    r_next_OP <= MODULUS_SIGN;  
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= 8'b00000011;
                    r_next_temp_OP <= MODULUS_SIGN; // FN = Unsigned Mod for ALU
                    r_next_state <= STATE_2;
                end
                else begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= r_temp_OP;
                    r_next_state <= STATE_0;
                end
            end
            STATE_2: begin
                if (data_in == PLUS_BINARY || data_in == MINUS_BINARY || data_in == MULTIPLY_BINARY) begin
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= r_temp_OP;
                    r_next_state <= STATE_0;
                end
                else if (data_in == MODULOS_BINARY) begin 
                    r_next_calc_en <= 1'b0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= r_B;
                    r_next_temp_OP <= r_temp_OP;
                    r_next_state <= STATE_0;
                end
                else begin
                    r_next_calc_en <= 1'b1; // A OP B has been received, enable ALU
                    r_next_A <= r_temp_A;
                    r_next_B <= data_in;
                    r_next_OP <= r_temp_OP;
                    r_next_temp_A <= r_temp_A;
                    r_next_temp_B <= data_in;
                    r_next_temp_OP <= r_temp_OP;
                    r_next_state <= STATE_0;
                end
            end
            default: begin
                r_next_calc_en <= 1'b0;
                r_next_A <= r_A;
                r_next_B <= r_B;
                r_next_OP <= r_OP;
                r_next_temp_A <= r_temp_A;
                r_next_temp_B <= r_temp_B;
                r_next_temp_OP <= r_temp_OP;
                r_next_state <= STATE_0;
            end // default case
        endcase
        end
        else begin
            r_next_calc_en <= 1'b0;
            r_next_A <= r_A;
            r_next_B <= r_B;
            r_next_OP <= r_OP;
            r_next_temp_A <= r_temp_A;
            r_next_temp_B <= r_B;
            r_next_temp_OP <= r_temp_OP;
            r_next_state <= r_state;
        end
    end // always

    assign o_A = r_A;
    assign o_OP = r_OP;
    assign o_B = r_B;
    assign calc_en = r_calc_en;

endmodule