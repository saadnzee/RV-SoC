`timescale 1ns / 1ps


module uart_rx #(
    parameter integer OVERSAMPLE = 16
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        sample_tick,
    input  wire        rx,

    output reg [7:0]   data_out,
    output reg         data_valid,
    output reg         framing_error
);

    localparam ST_IDLE  = 2'd0;
    localparam ST_START = 2'd1;
    localparam ST_DATA  = 2'd2;
    localparam ST_STOP  = 2'd3;

    reg [1:0] state;
    reg [3:0] sample_count;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    // Synchronizer Registers
    reg rx_meta;
    reg rx_sync;

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            rx_sync <= 1'b1; 
            rx_meta <= 1'b1;
        end
        else begin
            rx_meta <= rx;
            rx_sync <= rx_meta;
        end
    end

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            state         <= ST_IDLE;
            bit_index     <= 3'd0;
            shift_reg     <= 8'd0;
            sample_count  <= 4'd0;
            data_out      <= 8'd0;
            data_valid    <= 1'b0;
            framing_error <= 1'b0;
        end
        else begin

            data_valid    <= 1'b0;
            framing_error <= 1'b0;

            if(sample_tick) begin
                
                case(state)

                ST_IDLE: begin
                    sample_count <= 4'd0;
                    bit_index    <= 3'd0;
                    if (~rx_sync) begin
                        state <= ST_START;
                    end
                end

                ST_START: begin
                    sample_count <= sample_count + 1'b1;

                    if (sample_count == 4'd7) begin
                        if (rx_sync) begin
                            state        <= ST_IDLE;
                            sample_count <= 4'd0;
                        end
                    end
                    
                    if (sample_count == 4'd15) begin
                        sample_count <= 4'd0;
                        state        <= ST_DATA;
                    end
                end

                ST_DATA: begin
                    sample_count <= sample_count + 1'b1;
                    if (sample_count == 4'd7) begin
                        shift_reg[bit_index] <= rx_sync; 
                    end
                    
                    if (sample_count == 4'd15) begin
                        sample_count <= 4'd0;
                        if (bit_index == 3'd7) begin
                            bit_index <= 3'd0;
                            state     <= ST_STOP;
                        end 
                        else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                ST_STOP: begin
                    sample_count <= sample_count + 1'b1;
                    if (sample_count == 4'd7) begin 
                        if (rx_sync) begin 
                            data_valid <= 1'b1;
                            data_out   <= shift_reg;
                        end 
                        else begin
                            framing_error <= 1'b1;
                        end
                    end
                    
                    if (sample_count == 4'd15) begin
                        sample_count <= 4'd0;
                        state        <= ST_IDLE;
                    end
                end

                default: state <= ST_IDLE;

                endcase
            end
        end
    end

endmodule