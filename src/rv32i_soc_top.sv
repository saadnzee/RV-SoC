`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 07:23:50 PM
// Design Name: 
// Module Name: rv32i_soc_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rv32i_soc_top (
    input  logic        clk,
    input  logic        rst,
    output logic        led_out,
    output logic        locked,
    
    // UART physical pins
    input  logic        uart_rx_i,
    output logic        uart_tx_o
);

    logic [31:0] pc_out;

    logic        MemWrite, MemRead;
    logic [31:0] ALUResult, RS2, MemReadData;
    logic        stall;

    logic        wb_cyc, wb_stb, wb_we;
    logic [31:0] wb_adr, wb_dat_cpu_to_bus, wb_dat_bus_to_cpu;
    logic        wb_ack;
    
    logic sys_clk, rst_sys;
    
    assign led_out = |pc_out;
    
    assign rst_sys = rst | ~locked;
        
    clk_wiz_0 clock_divider (
        .clk_in1  (clk),      
        .clk_out1 (sys_clk),   
        .reset    (rst),
        .locked   (locked)
    );

    rv32i cpu (
        .clk(sys_clk),
        .rst(rst_sys),
        .pc_out(pc_out),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUResult(ALUResult),
        .RS2(RS2),
        .MemReadData(MemReadData),
        .stall(stall)
    );

    WBM_rv32i wb_master (
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUResult(ALUResult),
        .RS2(RS2),
        .MemReadData(MemReadData),
        .stall(stall),
        .wb_cyc_o(wb_cyc),
        .wb_stb_o(wb_stb),
        .wb_we_o(wb_we),
        .wb_adr_o(wb_adr),
        .wb_dat_o(wb_dat_cpu_to_bus),
        .wb_dat_i(wb_dat_bus_to_cpu),
        .wb_ack_i(wb_ack)
    );

    Wishbone_Interconnect soc_bus (
        .wb_clk_i(sys_clk),
        .wb_rst_i(rst_sys),
        .wb_cyc_i(wb_cyc),
        .wb_stb_i(wb_stb),
        .wb_we_i(wb_we),
        .wb_adr_i(wb_adr),
        .wb_dat_i(wb_dat_cpu_to_bus),
        .wb_dat_o(wb_dat_bus_to_cpu),
        .wb_ack_o(wb_ack),
        .uart_rx_i(uart_rx_i),
        .uart_tx_o(uart_tx_o)
    );

endmodule
