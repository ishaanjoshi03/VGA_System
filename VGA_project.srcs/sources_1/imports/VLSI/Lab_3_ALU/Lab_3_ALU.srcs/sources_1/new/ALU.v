`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 23.09.2023 10:19:03

// Module Name: ALU

// Description: Performs arithmetic operations that are displayed on the VGA driver.

//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [7:0] A,
    input [7:0] B,
    input [3:0] FN,
    input calc_en,
    output reg [15:0] result, //Temporary 9 bits
    output reg overflow,
    output reg sign
    );
    
    // VGA codes for non-numbers
    localparam PLUS_SIGN = 4'b1010; //10
    localparam MINUS_SIGN = 4'b1011; //11
    localparam MULTIPLICATION_SIGN = 4'b1100; //12
    localparam MODULUS_SIGN = 4'b1101; //13
    localparam EQUAL_SIGN = 4'b1110; //14
    localparam OVERFLOW_SIGN = 4'b1111; //15
    
    // Internal constant
    localparam MAXVAL = 255;
    //Internal registers
    wire [7:0] w_UA;
    wire [7:0] w_UB;
//    wire [8:0] w_result;
    
    // A mod 3 wires (Unsigned)
    wire [7:0] A_Uout1;
    wire [7:0] A_Uout2;
    wire [7:0] A_Uout3;
    wire [7:0] A_Uout4;
    wire [7:0] A_Uout5;
    wire [7:0] A_Uout6;
    wire [7:0] A_UoutFin;
    
    // A mod 3 wires (Signed)
    wire [7:0] A_Sout1;
    wire [7:0] A_Sout2;
    wire [7:0] A_Sout3;
    wire [7:0] A_Sout4;
    wire [7:0] A_Sout5;
    wire [7:0] A_Sout6;
    wire [7:0] A_SoutFin;
    
     // Combinatorial statemachine for which data to display depending on FN
    always @(*) begin
        if(calc_en) begin
            case(FN) 
                PLUS_SIGN: begin
                    result = (w_UA + w_UB);   //U(A+B)
                    overflow = result[8];
                    sign = 1'b0;
                end //0010
                MINUS_SIGN: begin
                    if (w_UA < w_UB) begin  //U(A-B)
                        result = w_UB - w_UA;  //-(B-A)
                        sign = 1'b1;
                        overflow = 1'b0;
                    end //if
                    else begin
                        result = w_UA - w_UB; // A-B
                        sign = 1'b0;
                        overflow = 1'b0;
                    end //else 
                end //0011
                MODULUS_SIGN: begin
                    result = A_UoutFin;
                    overflow = 1'b0;
                    sign = 1'b0;
                end //0100
                MULTIPLICATION_SIGN: begin //Multiplication
                    result = w_UA * w_UB;
                    if(result > MAXVAL) begin
                        overflow = 1'b1;
                        sign = 1'b0;
                    end //if
                    else begin
                        overflow = 1'b0;
                        sign = 1'b0;
                    end //else
                end //0101
                default: begin
                    result = A;
                    overflow = 1'b0;
                    sign = 1'b0;
                end
            endcase
        end
        else begin
//            result = A;
//            overflow = 1'b0;
//            sign = 1'b0;
        end // else
    end //always
    
    
    // A mod 3 calculations (unsigned)
    AMODX U0 (
        .A_in(w_UA),
        .Theta(8'b11000000),
        .A_out(A_Uout1)
    );
    AMODX U1 (
        .A_in(A_Uout1),
        .Theta(8'b01100000),
        .A_out(A_Uout2)
    );
    AMODX U2 (
        .A_in(A_Uout2),
        .Theta(8'b00110000),
        .A_out(A_Uout3)
    );
    AMODX U3 (
        .A_in(A_Uout3),
        .Theta(8'b00011000),
        .A_out(A_Uout4)
    );
    AMODX U4 (
        .A_in(A_Uout4),
        .Theta(8'b00001100),
        .A_out(A_Uout5)
    );
    AMODX U5 (
        .A_in(A_Uout5),
        .Theta(8'b00000110),
        .A_out(A_Uout6)
    );
    AMODX U6 (
        .A_in(A_Uout6),
        .Theta(8'b00000011),
        .A_out(A_UoutFin)
    );
    
    
        
    assign w_UA = A;
    assign w_UB = B;
endmodule
