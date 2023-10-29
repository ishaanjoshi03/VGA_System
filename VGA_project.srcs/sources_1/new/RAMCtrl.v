`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 10.10.2023 08:33:19

// Module Name: RAMCtrl

// Description: Module to control adding / popping values from RAM on FPGA.
//              Only adds data when a proper sequence is found.
// Dependencies: RAM IP, KeyboardCtrl

//////////////////////////////////////////////////////////////////////////////////


module RAMCtrl(
        input clk,
        input rst,
        input [2:0] op_signal,
        input [7:0] binary_in,
 
        output ALU_fsm_en,    
        output [7:0] RAM_DATA,
        output [3:0] ADDRESS
    );
    
    
    localparam c_zero_code = 8'b01000101;
    
    
    reg [7:0] r_code_saved;
    reg [7:0] r_next_code_saved;
    reg [15:0] r_address;
    reg [15:0] r_next_address;

    reg r_en;
    reg r_next_en;
    reg r_we;
    reg r_next_we;
    reg r_pop_en;
    reg r_next_pop_en;

    reg r_ram_en;    // enables adding data to RAM, output to FSM
    reg r_next_ram_en;
    
    reg r_fsm_en;
    reg r_next_fsm_en; 
    
    reg r_ALU_fsm_en;
    reg r_next_ALU_fsm_en; 

    reg [2:0] r_delete_count;
    reg [2:0] r_next_delete_count;
    
    reg [1:0] r_ram_count;
    reg [1:0] r_next_ram_count;
    
    
    reg [1:0] r_state;
    reg [1:0] r_next_state;
    reg [7:0] r_A;
    reg [7:0] r_B;
    reg [7:0] r_OP;
    reg [7:0] r_next_A;
    reg [7:0] r_next_B;
    reg [7:0] r_next_OP;  
      
      
//    reg ALU_fsm_en;
    
    reg [7:0] r_RAM_output;
    reg [7:0] r_next_RAM_output;

    wire [7:0] w_code_from_ram;
    wire [7:0] w_data;
    wire [15:0] w_address;
    wire w_en;  // enables reading of RAM
    wire w_we;   // if en and we are high, enables writing to RAM
    
    // Operation Representations
    localparam NUM_FOUND = 3'b000;
    localparam OP_FOUND = 3'b001;
    localparam DELETE_FOUND = 3'b010;
    localparam ENTER_FOUND = 3'b011;
    localparam EQUAL_FOUND = 3'b100;
    localparam NOTHING = 3'b111;
    
    // Signal Representations of Operations
    localparam PLUS = 4'b1010;
    localparam MINUS = 4'b1011;
    localparam MULTIPLY = 4'b1100;
    localparam MODULOS = 4'b1101;
    localparam EQUAL = 4'b1110;
    
    // Binary Representations of Operations
    localparam PLUS_BINARY = 8'b10000010;
    localparam MINUS_BINARY = 8'b10000011;
    localparam MULTIPLY_BINARY = 8'b10000100;
    localparam MODULOS_BINARY = 8'b10000101;
    
    // FSM States
    localparam STATE_0 = 2'b00;
    localparam STATE_1 = 2'b01;
    localparam STATE_2 = 2'b10;
    
    // sequential always block to update registers
    always @ (posedge clk) begin
        if (rst == 1) begin
            r_address <= 16'b0;
            r_en <= 1'b0;
            r_we <= 1'b0;
            r_RAM_output <= 8'b10000010;
            r_state <= STATE_0;
            r_A <= 8'b0;
            r_OP <= 8'b0;
            r_B <= 8'b0;
            r_ram_en <= 1'b0;
            r_fsm_en <= 1'b0;
            r_code_saved <= 8'b0;
            r_pop_en <= 1'b0;
            r_delete_count <= 3'b0;
            r_ram_count <= 2'b0;
            r_ALU_fsm_en <= 1'b0;
        end
        else begin
            r_address <= r_next_address;
            r_en <= r_next_en;
            r_we <= r_next_we;
            r_RAM_output <= r_next_RAM_output;
            r_state <= r_next_state;
            r_A <= r_next_A;
            r_OP <= r_next_OP;
            r_B <= r_next_B;
            r_ram_en <= r_next_ram_en;
            r_fsm_en <= r_next_fsm_en;
            r_code_saved <= r_next_code_saved;
            r_pop_en <= r_next_pop_en;
            r_delete_count <= r_next_delete_count;
            r_ram_count <= r_next_ram_count;
            r_ALU_fsm_en <= r_next_ALU_fsm_en;
        end  
    end // always
    
    
    always @(*) begin
        if(op_signal == EQUAL_FOUND) begin
            r_next_fsm_en <= 1'b1;
            r_next_pop_en <= 1'b0;
        end //if
        else if(op_signal == ENTER_FOUND && ~r_address) begin
            r_next_fsm_en <= 1'b0;
            if(r_ram_count) begin
                r_next_pop_en <= 1'b0;
            end //if
            else begin
                r_next_pop_en <= 1'b1;
            end //else          
        end //else if
        else begin
            r_next_fsm_en <= 1'b0;
            r_next_pop_en <= 1'b0;
        end //else
    end
    
    // alaways block to add data to RAM or pop data from RAM
    always @ (*) begin
        if (r_ram_en && !r_ram_count) begin 
                r_next_ram_count <= 2'b11; 
                r_next_delete_count <= r_delete_count;
                
                r_next_en <= 1'b1;
                r_next_we <= 1'b0;
                r_next_code_saved <= r_code_saved;
                if (r_address == 16'b0) begin
                    r_next_address <= r_address;
                end
                else begin
                    r_next_address <= r_address; // don't overwrite previous operation
                end

                r_next_RAM_output <= 8'b10000010;
                
                r_next_ALU_fsm_en <= 1'b0;

        end // if 

        // ADD NUM B TO ADDRESS 1
        else if (r_ram_count == 2'b11) begin 
                r_next_ram_count <= r_ram_count - 1'b1;
                r_next_delete_count <= r_delete_count;
                
                r_next_en <= 1'b1;
                r_next_we <= 1'b1;
                                       
                   
                if(r_OP == MODULOS_BINARY) begin
                    r_next_address <= r_address + 1'b1;
                    r_next_code_saved <= 8'b00000011;
                end //if
                else begin
                    r_next_address <= r_address + 1'b1;
                    r_next_code_saved <= r_B;                  
                end //else 
                
                r_next_RAM_output <= 8'b10000010;   
                r_next_ALU_fsm_en <= 1'b0;    
        end // else if

        // ADD OP TO ADDRESS 2
        else if (r_ram_count == 2'b10) begin 
            r_next_ram_count <= r_ram_count - 1'b1;
            r_next_delete_count <= r_delete_count;
            
            r_next_en <= 1'b1;
            r_next_we <= 1'b1;  
            
            if(r_OP == MODULOS_BINARY) begin
                r_next_address <= r_address + 1'b1;
                r_next_code_saved <= r_OP;
            end //if
            else begin
                r_next_address <= r_address + 1'b1;
                r_next_code_saved <= r_OP;                  
            end //else 

                r_next_RAM_output <= 8'b10000010;
    
            r_next_ALU_fsm_en <= 1'b0;    
        end // else if

        // ADD NUM B TO ADDRESS 3 (IF NOT MOD OPERATION)
        else if (r_ram_count == 2'b01) begin // add data to RAM
                r_next_ram_count <= r_ram_count - 1'b1;
                r_next_delete_count <= r_delete_count;
                
                r_next_en <= 1'b1;
                r_next_we <= 1'b1;
                r_next_address <= r_address + 1;
                r_next_code_saved <= r_A;
                
                r_next_RAM_output <= 8'b10000010;
                r_next_ALU_fsm_en <= 1'b0;
           
        end // else if

        // pop_en detected from enter key, signal to pop values from RAM
        else if (r_pop_en && !r_delete_count) begin
            r_next_ram_count <= r_ram_count;
            r_next_delete_count <= 3'b111;
                             
            r_next_en <= 1'b1;
            r_next_we <= 1'b0;
            r_next_address <= r_address;
            r_next_code_saved <= r_code_saved;
                
            r_next_RAM_output <= w_code_from_ram;
            if (r_RAM_output != r_next_RAM_output) begin
                r_next_ALU_fsm_en <= 1'b1;
            end
            else begin
                r_next_ALU_fsm_en <= 1'b1;
            end
            
        end // if

        else if (r_delete_count) begin
            r_next_ram_count <= r_ram_count;
            r_next_delete_count <= r_delete_count - 1'b1;
                             
            r_next_en <= 1'b1;
            r_next_we <= 1'b0;
            if (r_delete_count == 3'b110 || r_delete_count == 3'b100 || r_delete_count == 3'b001) begin
                r_next_address <= r_address - 1'b1;
            end // if
            else begin
                r_next_address <= r_address;
            end // else
            r_next_code_saved <= r_code_saved;
            
            r_next_RAM_output <= w_code_from_ram;
            if (r_RAM_output != r_next_RAM_output) begin
                r_next_ALU_fsm_en <= 1'b1;
            end
            else begin
                r_next_ALU_fsm_en <= 1'b0;
            end
        end 

        // DEFAULT CASE, DON'T POP OR ADD TO RAM
        else begin
            r_next_ram_count <= r_ram_count;
            r_next_delete_count <= r_delete_count;  // maybe change to 2'b00
                             
            r_next_en <= 1'b1;
            r_next_we <= 1'b0;
            r_next_address <= r_address;
            
            r_next_code_saved <= r_code_saved;
            
            r_next_RAM_output <= 8'b10000010; 
            r_next_ALU_fsm_en <= 1'b0;
        end // else
    end // always
    
    // FSM
    always @(*) begin
        if(r_fsm_en) begin
            case(r_state)
                STATE_0: begin
                    if(binary_in == PLUS_BINARY || binary_in == MINUS_BINARY 
                    || binary_in == MULTIPLY_BINARY || binary_in == MODULOS_BINARY) begin
                        r_next_state <= STATE_0;
                        r_next_A <= r_A;
                        r_next_B <= r_B;
                        r_next_OP <= r_OP;
                        r_next_ram_en <= 1'b0;
                    end //if
                    else begin
                        r_next_state <= STATE_1;
                        r_next_A <= binary_in;
                        r_next_B <= r_B;
                        r_next_OP <= r_OP;
                        r_next_ram_en <= 1'b0;
                    end 
                end //STATE_0
                
                STATE_1: begin
                     if(binary_in == PLUS_BINARY || binary_in == MINUS_BINARY 
                    || binary_in == MULTIPLY_BINARY) begin
                        r_next_state <= STATE_2;
                        r_next_A <= r_A;
                        r_next_B <= r_B;
                        r_next_OP <= binary_in;
                        r_next_ram_en <= 1'b0;
                    end //if
                    else if(binary_in == MODULOS_BINARY) begin
                        r_next_state <= STATE_0;
                        r_next_A <= r_A;
                        r_next_B <= r_B;
                        r_next_OP <= binary_in;
                        if(r_ram_count) begin
                            r_next_ram_en <= 1'b0;
                        end 
                        else begin
                            r_next_ram_en <= 1'b1;
                        end //else
                    end //else if
                    else begin
                        r_next_state <= STATE_0;
                        r_next_A <= r_A;
                        r_next_B <= r_B;
                        r_next_OP <= r_OP;
                        r_next_ram_en <= 1'b0;
                    end //else
                end //STATE_1
                
                STATE_2: begin
                    if(binary_in == PLUS_BINARY || binary_in == MINUS_BINARY 
                    || binary_in == MULTIPLY_BINARY || binary_in == MODULOS_BINARY) begin
                        r_next_state <= STATE_0;
                        r_next_A <= r_A;
                        r_next_B <= r_B;
                        r_next_OP <= r_OP;
                        r_next_ram_en <= 1'b0;
                    end //if
                    else begin
                        r_next_state <= STATE_0;
                        r_next_A <= r_A;
                        r_next_B <= binary_in;
                        r_next_OP <= r_OP;
                        if(r_ram_count) begin
                            r_next_ram_en <= 1'b0;
                        end 
                        else begin
                            r_next_ram_en <= 1'b1;
                        end //else
                        
                    end //else
                end //STATE_2
                default: begin
                    r_next_state <= STATE_0;
                    r_next_A <= r_A;
                    r_next_B <= r_B;
                    r_next_OP <= r_OP;
                    r_next_ram_en <= 1'b0;
                end
            endcase
        end
        else begin
            r_next_state <= r_state;
            r_next_A <= r_A;
            r_next_B <= r_B;
            r_next_OP <= r_OP;
            r_next_ram_en <= 1'b0;
        end //else
    end //always
    
    assign RAM_DATA = r_RAM_output;
    assign ADDRESS = r_address[3:0];
    assign ALU_fsm_en = r_ALU_fsm_en;
    assign pop_en = r_pop_en;
    
    blk_mem_gen_0 memory(
        .clka(clk),
        .ena(r_en),
        .wea(r_we),
        .addra(r_address),
        .dina(r_code_saved),
        .douta(w_code_from_ram)
    );
    
endmodule