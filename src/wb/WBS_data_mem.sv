`timescale 1ns / 1ps

// ===============================================
//   Memory Map (word-aligned, byte-addressable)
//   0x0000  word 0
//   0x0004  word 1
//   0x0008  word 2
//   0x000C  word 3
//   0x0010  word 4
//   0x0014  word 5
//   0x0018  word 6
//   0x001C  word 7
//   0x0020  word 8
//   0x0024  word 9
//   0x0028 - 0x0FFF reserved for future use
// ===============================================

module WBS_Data_Mem (
    // master-side
    input  logic        wb_clk_i,
    input  logic        wb_rst_i,

    input  logic        wb_cyc_i,
    input  logic        wb_stb_i,
    input  logic        wb_we_i,
    input  logic [31:0] wb_adr_i,
    input  logic [31:0] wb_dat_i,
    
    // slave-side
    output logic [31:0] wb_dat_o,
    output logic        wb_ack_o
);

    // ------------------------------------------------------------------
    // Wishbone classic handshake FSM 
    // ------------------------------------------------------------------
    typedef enum logic {
        WB_IDLE, 
        WB_ACK
    } wb_state_t;
    wb_state_t state, next_state;

    logic access;
    logic drive;
    
    always_comb begin
        access = wb_cyc_i & wb_stb_i;
        drive  = (state == WB_IDLE) && access;
    end

    always_ff @(posedge wb_clk_i or posedge wb_rst_i) begin
        if (wb_rst_i) state <= WB_IDLE;
        else          state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            WB_IDLE: 
                if (access) next_state = WB_ACK; 
                else next_state = WB_IDLE;
            WB_ACK:  next_state = WB_IDLE;
            default: next_state = WB_IDLE;
        endcase
    end

    assign wb_ack_o = (state == WB_ACK);

    logic        MemWrite, MemRead;
    logic [31:0] MemReadData;
    logic [31:0] local_addr;

    assign local_addr = {27'd0, wb_adr_i[4:0]}; 
    assign MemWrite   = drive & wb_we_i;
    assign MemRead    = drive & ~wb_we_i;

    data_mem dmem (
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Rs2(wb_dat_i),
        .ALUResult(local_addr),
        .MemReadData(MemReadData)
    );

    assign wb_dat_o = MemReadData;

endmodule