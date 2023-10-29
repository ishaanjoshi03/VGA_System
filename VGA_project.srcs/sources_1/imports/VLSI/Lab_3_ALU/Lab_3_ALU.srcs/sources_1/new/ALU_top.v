`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Ishaan Joshi and Billy Mårtensson

// Create Date: 23.09.2023 10:19:03

// Module Name: ALU_top

// Description: Project Top Module.

//////////////////////////////////////////////////////////////////////////////////


module ALU_top(
    input clk,
    input reset,
    input kb_data,
    input kb_clk,
    input b_Enter,
    input b_Sign,
//    input [7:0] w_scan_code,   // COMMENT FOR NOT SIMULATION
//    input w_valid_scan_code,   // COMMENT FOR NOT SIMULATION
    output [7:0] sc,
    output [7:0] seven_seg,
    output [3:0] anode,
    output io_horizontal_sync,
    output io_vertical_sync,
    output [11:0] io_rgb_color,
    output [3:0] ADDRESS
    );
    
    localparam c_slow_clk = 1;
    localparam c_consec_ones = 25000000;
    //Internal registers for debouncer
    reg r_inv_rst;
//    reg r_enter_db1;
    reg r_enter_db2;
//    reg r_sign_db1;
    reg r_sign_db2;
    reg [26:0] r_db_cnt;
    
    // Internal wires to connect modules
    wire w_overflow;
    wire w_sign;
    wire [3:0] w_FN;
    wire [1:0] w_RegCtrl;
    wire [7:0] w_A;
    wire [7:0] w_B;
    wire [15:0] w_result;
    wire [11:0] w_BCD_digit;
    wire w_kb_clk_sync;
    wire w_kb_data_sync;
    wire w_edge_found;
    wire w_valid_scan_code;     // COMMENT FOR SIMULATION
    wire [7:0] w_scan_code;     // COMMENT FOR SIMULATION
    wire [7:0] w_scan_code_out;
    wire [1:0] w_prev_input;
    
    wire w_ALU_fsm_en;
    wire w_pop_en;
    wire w_en_RAM;
    
    wire w_calc_en;
    wire [2:0] w_op_signal;
    wire [2:0] w_op_signal2;
    wire [7:0] w_binary_to_seg;
    wire [7:0] w_binary_out_to_RAM;
    wire [23:0] w_binary_out_to_RAM2;
    wire [7:0] w_binary_out_to_BCD;
    wire [7:0] w_RAM_DATA;
    wire [7:0] w_code_for_segment;
    wire [11:0] w_BCD_to_storage;
    wire [11:0] w_full_BCD;
    wire [7:0] w_o_A;
    wire [7:0] w_o_B;
    wire [3:0] w_o_OP;
    wire [47:0] w_VGA_DATA;
    wire [47:0] w_VGA_DATA2;
    wire [23:0] w_binary_RAM_data;
    //wire [7:0] w_Input;
    
   always @(posedge clk) begin
        if(reset == 0) begin
            r_inv_rst <= !reset;
            r_enter_db2 <= 0;
            r_sign_db2 <= 0; 
            r_db_cnt <= 0;
        end //if
        else begin
            r_inv_rst <= !reset;
        end //else
    end //always
    
    sync_keyboard UUD0 (
        .clk(clk),
        .kb_clk(kb_clk),
        .kb_data(kb_data),
        .kb_clk_sync(w_kb_clk_sync),
        .kb_data_sync(w_kb_data_sync)
    );
    
    edge_detector UUD1 (
        .clk(clk),
        .rst(r_inv_rst),
        .kb_clk_sync(w_kb_clk_sync),
        .edge_found(w_edge_found)
    );
    
    convert_scancode UUD2 (
        .clk(clk),
        .rst(r_inv_rst),
        .edge_found(w_edge_found),
        .serial_data(w_kb_data_sync),
        .valid_scan_code(w_valid_scan_code),
        .scan_code_out(w_scan_code)
    );
    
    keyboard_ctrl UUD3 (
        .clk(clk),
        .rst(r_inv_rst),
        .valid_code(w_valid_scan_code),
        .scan_code_in(w_scan_code),
        .scan_code_out(w_scan_code_out),
//        .kb_seg_en(kb_seg_en),  // don't need
//        .curr_state(curr_state), // only needed for testing
        .op_signal(w_op_signal)
    );
    
    convert_to_binary UUD4 (
        .scan_code_in(w_scan_code_out),
        .binary_out(w_binary_out_to_BCD)
    );
    
    // convert_scancode module should be wired to this module
    ALU_ctrl UUD5 (
        .clk(clk),
        .rst(r_inv_rst),
        .data_in(w_RAM_DATA),
        .ALU_fsm_en(w_ALU_fsm_en),
        .o_A(w_o_A),
        .o_OP(w_o_OP), // conforming to ALU signals previously used to limit changing code
        .o_B(w_o_B),
        .calc_en(w_calc_en)
    );
   
    
    // w_A and w_B come from RAM
    ALU UUD7 (
        .A(w_o_A),
        .B(w_o_B),
        .FN(w_o_OP),
        .calc_en(w_calc_en),
        .result(w_result),
        .overflow(w_overflow),
        .sign(w_sign)
    
    );
    
    Binary2BCD UUD8 (
        .binary_in(w_binary_out_to_BCD),
        .BCD_out(w_BCD_to_storage)
    );   
    
    BCD_Storage UUD12(
    .clk(clk),
    .rst(r_inv_rst),
    .op_signal(w_op_signal),
    .BCD_in(w_BCD_to_storage),
    .prev_input(w_prev_input),
    .full_BCD(w_full_BCD)
    );
    
    BCD2BINARY UUD13 (
    .BCD_in(w_full_BCD),
    .op_signal(w_op_signal),
    .prev_input(w_prev_input),
    .binary_out(w_binary_out_to_RAM)
    );
    
    BCD2VGA UUD14 (
        .clk(clk),
        .rst(r_inv_rst),
        .en_BCD_to_Binary(w_calc_en),
        .num_A(w_o_A),
        .num_B(w_o_B),
        .result(w_result[7:0]),
        .operation(w_o_OP),  //Here we send the current operation (plus, minus, multiplication, etc)
        .sign(w_sign),
        .overflow(w_overflow),
        .op_signal(w_op_signal),
        .VGA_DATA_in(w_VGA_DATA2),
        .VGA_DATA(w_VGA_DATA) //This goes to the vga
    );
    
    vga UUD15 (
        .clock(clk),
        .reset(r_inv_rst),
        .BCD_vector(w_VGA_DATA),
        .horizontal_sync(io_horizontal_sync),
        .vertical_sync(io_vertical_sync),
        .rgb_color(io_rgb_color)
    );
    
    // Used to display the numbers we press on the FPGA seven segment display (for debuging purposes)
    SevSegDisplay UUDExternal (
        .clk(clk),
        .rst(r_inv_rst),
        .valid_code(w_valid_scan_code),
        .scan_code_in(w_scan_code),
        .ANODES(anode),
        .code_for_segment(w_code_for_segment)
    );
    
    convert_to_binary UUDDisplay0 (
        .scan_code_in(w_code_for_segment),
        .binary_out(w_binary_to_seg)
    );  
    
    binary_to_sg UUDDisplay1 (
        .binary_in(w_binary_to_seg[3:0]),
        .sev_seg(seven_seg)
    );
    
    VGACtrl UUDDisplay3 (
        .clk(clk),
        .rst(r_inv_rst),
        .valid_code(w_valid_scan_code),
        .scan_code_in(w_scan_code),
        .VGA_DISPLYA_DATA(w_VGA_DATA2)
    );
    
//    VGA_code_conv UUDisplay(
//        .VGA_DISPLYA_DATA(w_VGA_DATA2),
//        .binary_RAM_DATA(w_binary_out_to_RAM2)
//    );
    
        RAMCtrl UUD11(
        .clk(clk),
        .rst(r_inv_rst),
        .op_signal(w_op_signal),
        .binary_in(w_binary_out_to_RAM),      
        .ALU_fsm_en(w_ALU_fsm_en), 
        .RAM_DATA(w_RAM_DATA),
        .ADDRESS(ADDRESS)
    );

//    RAM_Ctrl2 UUDisplay5(
//        .clk(clk),
//        .rst(r_inv_rst),
//        .op_signal(w_op_signal2),
//        .binary_in(w_binary_out_to_RAM2), 
//        .ALU_fsm_en(w_ALU_fsm_en), 
//        .pop_en(w_pop_en),
//        .RAM_DATA(w_RAM_DATA),
//        .ADDRESS(ADDRESS)
//    );
    
    assign sc = w_scan_code;
endmodule
