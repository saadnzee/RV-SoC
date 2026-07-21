`timescale 1ns / 1ps
// ===============================================
//   Memory Map (word-aligned, byte-addressable)
//
//   0x00   TX_DATA  [7:0]  WO   Write byte -> starts transmission
//                               (write is ignored while tx_busy=1;
//                               poll STATUS.tx_busy before writing)
//   0x04   RX_DATA  [7:0]  RO   Latest received byte; reading clears
//                               rx_valid and rx_overrun
//   0x08   STATUS   [3:0]  RO   {rx_overrun, framing_err, rx_valid, tx_busy}
//   0x0C - 0x0FFF  reserved for future use
//
//   RX overrun behavior (no hardware flow control is implemented, so the
//   receiver can never ask the sender to wait):
//   the newest received byte always overwrites rx_data_latch, even if
//   the previous byte was never read. rx_overrun latches in that case so
//   software can detect the loss; it does not, and cannot, prevent it.
//   If real back-pressure is ever needed, that requires an RX FIFO or
//   RTS/CTS flow control - neither is in scope for this module.
//
//   Reset: wb_rst_i is asynchronous active-high, matching every other
//   WBS module in this SoC. The UART cores underneath expect an
//   active-low reset, so it's inverted once at the boundary (rst_n).
// ===============================================

module WBS_uart #(
    parameter integer CLOCK_FREQ_HZ = 50_000_000,  
    parameter integer BAUD_RATE     = 9600
)(
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
    output logic        wb_ack_o,

    // physical UART pins
    input  logic        uart_rx_i,
    output logic        uart_tx_o
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

    // ------------------------------------------------------------------
    // Local register decode (3 registers: TX_DATA, RX_DATA, STATUS)
    // ------------------------------------------------------------------
    localparam [2:0] IDX_TX     = 3'd0;  // 0x00
    localparam [2:0] IDX_RX     = 3'd1;  // 0x04
    localparam [2:0] IDX_STATUS = 3'd2;  // 0x08

    logic [2:0] word_idx;
    assign word_idx = wb_adr_i[4:2];

    logic sel_tx, sel_rx, sel_status;
    assign sel_tx     = (word_idx == IDX_TX);
    assign sel_rx     = (word_idx == IDX_RX);
    assign sel_status = (word_idx == IDX_STATUS);

    logic  tx_data_write, rx_data_read;
    assign tx_data_write = drive & wb_we_i  & sel_tx;
    assign rx_data_read  = drive & ~wb_we_i & sel_rx;

    // ------------------------------------------------------------------
    // UART cores (active-low reset)
    // ------------------------------------------------------------------
    logic rst_n;
    assign rst_n = ~wb_rst_i;

    logic tx_tick, rx_sample_tick;

    baud_rate_generator #(
        .CLOCK_FREQ_HZ(CLOCK_FREQ_HZ),
        .TICK_RATE_HZ (BAUD_RATE)
    ) u_tx_baud (
        .clk   (wb_clk_i),
        .rst_n (rst_n),
        .tick  (tx_tick)
    );

    baud_rate_generator #(
        .CLOCK_FREQ_HZ(CLOCK_FREQ_HZ),
        .TICK_RATE_HZ (BAUD_RATE * 16)
    ) u_rx_baud (
        .clk   (wb_clk_i),
        .rst_n (rst_n),
        .tick  (rx_sample_tick)
    );

    logic       tx_start, tx_busy, tx_done;
    logic [7:0] tx_data_reg;
    
    // tx_done is deliberately unused: for a polling-only design,
    // tx_busy dropping to 0 carries the same information a done pulse
    // would, so there's no need to latch it as a separate status bit.

    // Only start a new transmission if the transmitter isn't already
    // busy - a write to TX_DATA while tx_busy=1 is silently ignored
    // rather than corrupting the byte currently going out. Software
    // should poll STATUS.tx_busy before writing.
    
    assign tx_start = tx_data_write & ~tx_busy;

    always_ff @(posedge wb_clk_i or posedge wb_rst_i) begin
        if (wb_rst_i) tx_data_reg <= 8'h00;
        else if (tx_start) tx_data_reg <= wb_dat_i[7:0];
    end

    uart_tx u_tx (
        .clk       (wb_clk_i),
        .rst_n     (rst_n),
        .baud_tick (tx_tick),
        .start     (tx_start),
        .data_in   (tx_data_reg),
        .tx        (uart_tx_o),
        .busy      (tx_busy),
        .done      (tx_done)
    );

    logic [7:0] rx_data_raw;
    logic       rx_valid_pulse, framing_error;

    uart_rx #(.OVERSAMPLE(16)) u_rx (
        .clk          (wb_clk_i),
        .rst_n        (rst_n),
        .sample_tick  (rx_sample_tick),
        .rx           (uart_rx_i),
        .data_out     (rx_data_raw),
        .data_valid   (rx_valid_pulse),
        .framing_error(framing_error)
    );

    // ------------------------------------------------------------------
    // RX capture: newest byte always wins; rx_overrun flags data loss
    // (see header comment - this can't be prevented without flow
    // control, only reported).
    // ------------------------------------------------------------------
    logic [7:0] rx_data_latch;
    logic       rx_valid_latch;
    logic       rx_overrun;
    logic       framing_err_latch;

    always_ff @(posedge wb_clk_i or posedge wb_rst_i) begin
        if (wb_rst_i) begin
            rx_data_latch     <= 8'h00;
            rx_valid_latch    <= 1'b0;
            rx_overrun        <= 1'b0;
            framing_err_latch <= 1'b0;
        end 
        else begin
            if (rx_valid_pulse) begin
                rx_data_latch     <= rx_data_raw;
                framing_err_latch <= framing_error;
                if (rx_valid_latch) rx_overrun <= 1'b1; // previous byte was never read
                rx_valid_latch <= 1'b1;
            end
            if (rx_data_read) begin
                rx_valid_latch <= 1'b0;
                rx_overrun     <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------------
    // Read data mux
    // ------------------------------------------------------------------
    always_comb begin
        wb_dat_o = 32'd0;
        if (sel_rx) wb_dat_o = {24'd0, rx_data_latch};
        else if (sel_status) wb_dat_o = {28'd0, rx_overrun, framing_err_latch, rx_valid_latch, tx_busy};
    end

endmodule