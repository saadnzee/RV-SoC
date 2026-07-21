`timescale 1ns / 1ps

// ============================================================================
// System memory map
//
// Peripheral select = wb_adr_i[15:12] (a 4-bit field -> 16 possible 4KB
// windows, one per peripheral, leaving room for future peripherals like
// UART without redesigning the decoder).
//
//   0x0000_0000 - 0x0000_0FFF : Data Memory        (window select = 4'h0)
//   0x0000_1000 - 0x0000_1FFF : Matrix Accelerator (window select = 4'h1)
//   0x0000_2000 - 0x0000_2FFF : UART               (window select = 4'h2)
//   0x0000_3000 - 0x0000_FFFF : reserved for future peripherals
//
// Only the low bits within each window are actually implemented; the rest
// of a peripheral's 4KB window is simply unused address space reserved
// for that peripheral to grow into later (e.g. a bigger data memory).
//
// --- Data Memory (WBS_Data_Mem), byte-addressed, word-aligned accesses ---
//   0x0000_0000  word 0
//   0x0000_0004  word 1
//   0x0000_0008  word 2
//   0x0000_000C  word 3
//   0x0000_0010  word 4
//   0x0000_0014  word 5
//   0x0000_0018  word 6
//   0x0000_001C  word 7
//   0x0000_0020  word 8
//   0x0000_0024  word 9
//   (0x0000_0020 - 0x0000_0FFF reserved for future use)
//
// --- Matrix Accelerator (WBS_Matrix_Accelerator) ---
//   0x0000_1000  Matrix A Column0               (W)
//   0x0000_1004  Matrix A Column1               (W)
//   0x0000_1008  Matrix A Column2               (W)
//   0x0000_100C  Matrix B Row0                  (W)
//   0x0000_1010  Matrix B Row1                  (W)
//   0x0000_1014  Matrix B Row2                  (W)
//   0x0000_1018  CONTROL (any write -> start)   (W)
//   0x0000_101C  STATUS  (bit0=done, bit1=busy) (R)
//   0x0000_1020  Matrix C00                     (R)
//   0x0000_1024  Matrix C01                     (R)
//   0x0000_1028  Matrix C02                     (R)
//   0x0000_102C  Matrix C10                     (R)
//   0x0000_1030  Matrix C11                     (R)
//   0x0000_1034  Matrix C12                     (R)
//   0x0000_1038  Matrix C20                     (R)
//   0x0000_103C  Matrix C21                     (R)
//   0x0000_1040  Matrix C22                     (R)
//   (0x0000_1044 - 0x0000_1FFF reserved)
//
// --- UART (WBS_UART) ---
//   0x0000_2000  TX_DATA (write -> starts transmission, ignored if busy) (W)
//   0x0000_2004  RX_DATA (read clears rx_valid/rx_overrun)               (R)
//   0x0000_2008  STATUS  (bit0=tx_busy, bit1=rx_valid, bit2=framing_err,
//                         bit3=rx_overrun)                               (R)
//   (0x0000_200C - 0x0000_2FFF reserved)
//
// Neither slave wrapper does its own base-address subtraction; both only
// look at their own low local-offset bits (WBS_Data_Mem: wb_adr_i[4:0],
// WBS_Matrix_Accelerator: wb_adr_i[6:2], WBS_UART: wb_adr_i[4:2]), which 
// is safe precisely because this interconnect only ever asserts a slave's 
// cyc/stb when the upper address bits already match that slave's window, 
// and the low bits are identical whether the base is 0x0000 or 0x1000.
//
// Unmapped addresses (periph_sel not 0, 1, or 2) never receive an ack,
// exactly like an unmapped access on real Wishbone classic hardware. No
// bus error/timeout mechanism is implemented, in keeping with the
// project's "no optional Wishbone signals" decision.
// ============================================================================

module Wishbone_Interconnect #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter CLOCK_FREQ_HZ  = 50_000_000,
    parameter UART_BAUD_RATE = 9600
)(
    input  logic        wb_clk_i,
    input  logic        wb_rst_i,

    // Master-facing port - this is what the RV32I's Wishbone master interface connects to.
    input  logic        wb_cyc_i,
    input  logic        wb_stb_i,
    input  logic        wb_we_i,
    input  logic [31:0] wb_adr_i,
    input  logic [31:0] wb_dat_i,
    output logic [31:0] wb_dat_o,
    output logic        wb_ack_o,
    
    // UART physical pins
    input  logic        uart_rx_i,
    output logic        uart_tx_o
);

    localparam [3:0] SEL_DATA_MEM = 4'h0;
    localparam [3:0] SEL_ACCEL    = 4'h1;
    localparam [3:0] SEL_UART     = 4'h2;
 
    logic [3:0] periph_sel;
 
    logic sel_data_mem;
    logic sel_accel;
    logic sel_uart;
    
    // Per-slave cyc/stb gating - only the addressed slave ever sees a
    // live transaction; everything else (we, adr, dat_i) is broadcast to
    // all three since it's harmless when cyc/stb are low.
    logic dm_cyc,  dm_stb;
    logic acc_cyc, acc_stb;
    logic uart_cyc, uart_stb;
    
    always_comb begin
        periph_sel = wb_adr_i[15:12];
 
        sel_data_mem = (periph_sel == SEL_DATA_MEM);
        sel_accel    = (periph_sel == SEL_ACCEL);
        sel_uart     = (periph_sel == SEL_UART);
 
        dm_cyc   = wb_cyc_i & sel_data_mem;
        dm_stb   = wb_stb_i & sel_data_mem;
 
        acc_cyc  = wb_cyc_i & sel_accel;
        acc_stb  = wb_stb_i & sel_accel;
 
        uart_cyc = wb_cyc_i & sel_uart;
        uart_stb = wb_stb_i & sel_uart;
    end

    logic [31:0] dm_dat_o;
    logic        dm_ack_o;
 
    logic [31:0] acc_dat_o;
    logic        acc_ack_o;
 
    logic [31:0] uart_dat_o;
    logic        uart_ack_o;

    WBS_Data_Mem u_data_mem (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_cyc_i(dm_cyc),
        .wb_stb_i(dm_stb),
        .wb_we_i(wb_we_i),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(dm_dat_o),
        .wb_ack_o(dm_ack_o)
    );

    WBS_Matrix_Accelerator #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) u_accel (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_cyc_i(acc_cyc),
        .wb_stb_i(acc_stb),
        .wb_we_i(wb_we_i),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(acc_dat_o),
        .wb_ack_o(acc_ack_o)
    );

    WBS_uart #(
        .CLOCK_FREQ_HZ(CLOCK_FREQ_HZ),
        .BAUD_RATE(UART_BAUD_RATE)
    ) u_uart (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_cyc_i(uart_cyc),
        .wb_stb_i(uart_stb),
        .wb_we_i(wb_we_i),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(uart_dat_o),
        .wb_ack_o(uart_ack_o),
        .uart_rx_i(uart_rx_i),
        .uart_tx_o(uart_tx_o)
    );

    // Return-path mux, keyed off the same select field used to route the
    // request. Safe as a plain mux (no OR-ing needed) since only one
    // slave is ever live for a given transaction.
    always_comb begin
        wb_dat_o = 32'd0;
        wb_ack_o = 1'b0;
        case (periph_sel)
            SEL_DATA_MEM: begin wb_dat_o = dm_dat_o;   wb_ack_o = dm_ack_o;   end
            SEL_ACCEL:    begin wb_dat_o = acc_dat_o;  wb_ack_o = acc_ack_o;  end
            SEL_UART:     begin wb_dat_o = uart_dat_o; wb_ack_o = uart_ack_o; end
            default:      begin wb_dat_o = 32'd0;      wb_ack_o = 1'b0;      end
        endcase
    end

endmodule
