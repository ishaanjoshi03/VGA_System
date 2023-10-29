`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 26.10.2023 20:16:08

// Module Name: RAM_Ctrl2

// Description: Not used in final project.

//////////////////////////////////////////////////////////////////////////////////


module RAM_Ctrl2(
        input clk,
        input rst,
        input [2:0] op_signal,
        input [23:0] binary_in,
        input en_RAM,
        output ALU_fsm_en,    
        output pop_en,       
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
    
    reg r_ram_storing_count;
    reg r_next_ram_storing_count;
    
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
    
    // NEW stuff
    reg [2:0] r_input_cnt;
    reg [2:0] r_next_input_cnt;
    reg [23:0] r_temp_binary_in;
    reg [23:0] r_next_temp_binary_in;
    

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
            r_RAM_output <= 8'b0;
            r_code_saved <= 8'b0;
            r_ALU_fsm_en <= 1'b0;
            r_input_cnt <= 3'b0;
            r_pop_en <= 1'b0;
            r_ram_en <= 1'b0;
            r_temp_binary_in <= 24'b0;
        end
        else begin
            r_address <= r_next_address;
            r_en <= r_next_en;
            r_we <= r_next_we;
            r_RAM_output <= r_next_RAM_output;
            r_code_saved <= r_next_code_saved;
            r_delete_count <= r_next_delete_count;
            r_ALU_fsm_en <= r_next_ALU_fsm_en;
            r_input_cnt <= r_next_input_cnt;
            r_pop_en <= r_next_pop_en;
            r_ram_en <= r_next_ram_en;
            r_temp_binary_in <= r_next_temp_binary_in;
        end  
    end // always
    
    always @(*) begin
        if(op_signal == ENTER_FOUND) begin
            if(r_input_cnt == 6) begin
                r_next_pop_en <= 1'b0;
                r_next_ram_en <= 1'b0;
            end //if
            else begin
                r_next_pop_en <= 1'b1;
                r_next_ram_en <= 1'b0;
            end //else          
        end //else if
        else if(op_signal == EQUAL_FOUND) begin
            if(r_input_cnt == 6) begin
                r_next_pop_en <= 1'b0;
                r_next_ram_en <= 1'b0;
            end //if
            else begin
                r_next_pop_en <= 1'b0;
                r_next_ram_en <= 1'b1;
            end //else          
        end //else if
        else begin
            r_next_pop_en <= 1'b0;
            r_next_ram_en <= 1'b0;
        end //else
        if(en_RAM) begin
            r_next_temp_binary_in <= binary_in;
        end //if
        else begin
            r_next_temp_binary_in <= r_temp_binary_in;
        end //
    end
    
    
    always @(*) begin
        if(r_pop_en) begin
            case(r_input_cnt) 
                0: begin
                    r_next_en <= 1'b1;
                    r_next_we <= 1'b0;
                    r_next_code_saved <= r_code_saved;
                    if(r_pop_en) begin //Start incrementing when we detect a pop_en
                        r_next_address <= r_address - 1'b1;
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                    end
                    else begin
                        r_next_address <= r_address;
                        r_next_input_cnt <= r_input_cnt;
                    end //else                        
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= r_ALU_fsm_en;
                end //0
                1: begin
                    r_next_en <= 1'b1;
                    r_next_we <= 1'b0;
                    r_next_code_saved <= r_code_saved;
                    r_next_address <= r_address;
                    r_next_input_cnt <= r_input_cnt + 1'b1;
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= r_ALU_fsm_en;
                end //1
                2: begin
                    r_next_en <= 1'b1;
                    r_next_we <= 1'b0;
                    r_next_code_saved <= r_code_saved;
                    r_next_address <= r_address - 1'b1;
                    r_next_input_cnt <= r_input_cnt + 1'b1;
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= r_ALU_fsm_en;
                end //2
                3: begin
                    r_next_en <= 1'b1;
                    r_next_we <= 1'b0;
                    r_next_code_saved <= r_code_saved;
                    r_next_address <= r_next_address;
                    if(w_code_from_ram == MODULOS_BINARY) begin //If we find modulos, don't grab next RAM, data
                        r_next_input_cnt <= 3'b110;       
                    end //if
                    else begin
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                    end //else                      
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= r_ALU_fsm_en;
                end //3
                4: begin
                    r_next_en <= 1'b1;
                    r_next_we <= 1'b0;
                    r_next_code_saved <= r_code_saved;
                    r_next_address <= r_next_address  - 1'b1;
                    r_next_input_cnt <= r_input_cnt + 1'b1;
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= r_ALU_fsm_en;
                end //4
                5: begin
                    r_next_en <= 1'b1;
                    r_next_we <= 1'b0;
                    r_next_code_saved <= r_code_saved;
                    r_next_address <= r_next_address;
                    r_next_input_cnt <= r_input_cnt + 1'b1;
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= 1'b1;
                end //5
                default: begin
                    r_next_en <= r_en;
                    r_next_we <= r_we;
                    r_next_code_saved <= r_code_saved;
                    r_next_address <= r_next_address;
                    r_next_input_cnt <= 0;
                    r_next_RAM_output <= w_code_from_ram;
                    r_next_ALU_fsm_en <= r_ALU_fsm_en;
                end 
            endcase 
            end //if
            else if (r_ram_en) begin
                case(r_input_cnt) 
                    0: begin
                        r_next_en <= 1'b1;
                        r_next_we <= 1'b1;
                        r_next_code_saved <= r_temp_binary_in[7:0];
                        if(r_temp_binary_in[15:8] == MODULOS_BINARY) begin //Don't increment address if we find modulos, 
                                r_next_address <= r_next_address;       //just overwrite it
                            end //if
                            else begin
                                r_next_address <= r_next_address + 1'b1;
                            end //else
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end //0
                    1: begin
                        r_next_en <= 1'b1;
                        r_next_we <= 1'b1;
                        r_next_code_saved <= r_temp_binary_in[7:0];
                        r_next_address <= r_next_address;
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end //1
                    2: begin
                        r_next_en <= 1'b1;
                        r_next_we <= 1'b1;
                        r_next_code_saved <= r_temp_binary_in[15:8];
                        r_next_address <= r_next_address + 1'b1;
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end //2
                    3: begin
                        r_next_en <= 1'b1;
                        r_next_we <= 1'b1;
                        r_next_code_saved <= r_temp_binary_in[15:8];
                        r_next_address <= r_next_address;
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end //3
                    4: begin
                        r_next_en <= 1'b1;
                        r_next_we <= 1'b1;
                        r_next_code_saved <= r_temp_binary_in[23:16];
                        r_next_address <= r_next_address  + 1'b1;
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end //4
                    5: begin
                        r_next_en <= 1'b1;
                        r_next_we <= 1'b1;
                        r_next_code_saved <= r_temp_binary_in[23:16];
                        r_next_address <= r_next_address;
                        r_next_input_cnt <= r_input_cnt + 1'b1;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end //5
                    default: begin
                        r_next_en <= r_en;
                        r_next_we <= r_we;
                        r_next_code_saved <= r_code_saved;
                        r_next_address <= r_next_address;
                        r_next_input_cnt <= r_input_cnt;
                        r_next_RAM_output <= r_RAM_output;
                        r_next_ALU_fsm_en <= r_ALU_fsm_en;
                    end 
                endcase
            end //else if              
            else begin
                r_next_en <= r_en;
                r_next_we <= r_we;
                r_next_code_saved <= r_code_saved;
                r_next_address <= r_next_address;
                r_next_input_cnt <= 3'b0;
                r_next_RAM_output <= r_RAM_output;
                r_next_ALU_fsm_en <= 1'b0;
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
