`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 13.10.2023 10:25:26

// Module Name: BCD2BINARY
 
// Description: Uses Reverse Double Dabble algorithm to convert 12-bit BCD representations
//              to 8-bit binary numbers

//////////////////////////////////////////////////////////////////////////////////


module BCD2BINARY(
    input [11:0] BCD_in,
    input [2:0] op_signal,
    input [1:0] prev_input,
    output [7:0] binary_out
    );
    
    localparam c_reset_BCD_val = 8'b00000000;  //The initial value of the BCD register part before starting conversion
    
    // Operation Representations
    localparam NUM_FOUND = 3'b000;
    localparam OP_FOUND = 3'b001;
    localparam EQUAL_FOUND = 3'b100;
    
    // 4-bit Binary Representations of Operations
    localparam PLUS = 4'b1010;
    localparam MINUS = 4'b1011;
    localparam MULTIPLY = 4'b1100;
    localparam MODULOS = 4'b1101;
    localparam EQUAL = 4'b1110;
    
    wire [19:0] nibbles_out1;
    wire [19:0] nibbles_out2;
    wire [19:0] nibbles_out3;
    wire [19:0] nibbles_out4;
    wire [19:0] nibbles_out5;
    wire [19:0] nibbles_out6;
    wire [19:0] nibbles_out7;
    reg [19:0] nibbles_outfin;
    

   always @ (*) begin
       case (op_signal)
           NUM_FOUND: nibbles_outfin = nibbles_out7 >> 1'b1;
           OP_FOUND: begin
                case (BCD_in[3:0])
                    PLUS: nibbles_outfin[7:0] <= 8'b10000010;
                    MINUS: nibbles_outfin[7:0] <= 8'b10000011;
                    MULTIPLY: nibbles_outfin[7:0] <= 8'b10000100;
                    MODULOS: nibbles_outfin[7:0] <= 8'b10000101;
                    default: nibbles_outfin[7:0] <= 8'b00000000;
                endcase
           end
           EQUAL_FOUND: begin // if equal pressed, pass the previous OP/NUM to RAMCtrl
                if (prev_input > 2'b00) begin
                    nibbles_outfin = nibbles_out7 >> 1'b1;
                end // if
                else begin
                    nibbles_outfin[7:0] <= 8'b00000000;
                end // else
           end
           default: nibbles_outfin = nibbles_out7 >> 1'b1;
       endcase
   end // always
    
    // Reverse Double Dabble Algorithm

    Reverse_BCD_Nibble_Module U0 (
        .nibbles_in({BCD_in, c_reset_BCD_val} >> 1'b1),
        .nibbles_out(nibbles_out1)
    ); 
    Reverse_BCD_Nibble_Module U1 (
        .nibbles_in(nibbles_out1 >> 1'b1),
        .nibbles_out(nibbles_out2)
    );
    Reverse_BCD_Nibble_Module U2 (
        .nibbles_in(nibbles_out2 >> 1'b1),
        .nibbles_out(nibbles_out3)
    );     
    Reverse_BCD_Nibble_Module U3 (
        .nibbles_in(nibbles_out3 >> 1'b1),
        .nibbles_out(nibbles_out4)
    );     
    Reverse_BCD_Nibble_Module U4 (
        .nibbles_in(nibbles_out4 >> 1'b1),
        .nibbles_out(nibbles_out5)
    );     
    Reverse_BCD_Nibble_Module U5 (
        .nibbles_in(nibbles_out5 >> 1'b1),
        .nibbles_out(nibbles_out6)
    );     
    Reverse_BCD_Nibble_Module U6 (
        .nibbles_in(nibbles_out6 >> 1'b1),
        .nibbles_out(nibbles_out7)
    );     
          
    assign binary_out = nibbles_outfin[7:0];
    
endmodule