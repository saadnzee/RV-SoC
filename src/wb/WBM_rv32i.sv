`timescale 1ns / 1ps

// ============================================================================
// Bridges the single-cycle RV32I's simple memory-request interface
// (MemWrite/MemRead/ALUResult/RS2/MemReadData) to a Wishbone B4 Classic
// master port, and generates the `stall` signal the CPU needs to freeze
// its PC and register writeback while a load/store is in flight.
//
// No separate master FSM or registers are needed: as long as the CPU
// freezes on `stall`, MemWrite/MemRead/ALUResult/RS2 stay constant for
// the whole transaction, so this is a purely combinational bridge.
// ============================================================================

module WBM_rv32i (
    // CPU-facing simple memory-request interface
    input  logic        MemWrite,
    input  logic        MemRead,
    input  logic [31:0] ALUResult,
    input  logic [31:0] RS2,
    output logic [31:0] MemReadData,
    output logic        stall,

    // Wishbone master interface -> Wishbone_Interconnect
    output logic         wb_cyc_o,
    output logic         wb_stb_o,
    output logic         wb_we_o,
    output logic [31:0]  wb_adr_o,
    output logic [31:0]  wb_dat_o,
    input  logic [31:0]  wb_dat_i,
    input  logic         wb_ack_i
);

    logic mem_access;

    assign mem_access = MemWrite | MemRead;

    assign wb_cyc_o = mem_access;
    assign wb_stb_o = mem_access;
    assign wb_we_o  = MemWrite;
    assign wb_adr_o = ALUResult;
    assign wb_dat_o = RS2;

    assign MemReadData = wb_dat_i;

    // Freeze the CPU until the addressed slave acks. Instructions that
    // don't touch memory never assert mem_access, so they're unaffected;
    // lw/sw pay exactly as many wait-state cycles as the target slave
    // needs (1 for both peripherals today, generically however many for
    // whatever gets added later).
    assign stall = mem_access & ~wb_ack_i;

endmodule
