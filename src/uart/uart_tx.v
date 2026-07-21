`timescale 1ns / 1ps


module uart_tx(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       baud_tick,
    input  wire       start,
    input  wire [7:0] data_in,
    output reg        tx,
    output reg        busy,
    output reg        done
);

    //====================================================
    // State Encoding
    //====================================================
    localparam ST_IDLE  = 2'd0;
    localparam ST_START = 2'd1;
    localparam ST_DATA  = 2'd2;
    localparam ST_STOP  = 2'd3;

    //====================================================
    // Internal Registers
    //====================================================
    reg [1:0] state;

    reg [2:0] bit_index;

    reg [7:0] shift_reg;  

    //====================================================
    // UART Transmitter State Machine
    //====================================================
    always @(posedge clk or negedge rst_n)
    begin

        if(!rst_n) begin
            state     <=  ST_IDLE;
            shift_reg <= 'd0;
            tx        <= 'd1;
            busy      <= 'd0;
            done      <= 'd0;
        end
        
        else begin
            done <= 'd0;
            case(state)
            ST_IDLE: begin
                tx        <= 'd1;
                busy      <= 'b0;
                
                if (start) begin
                    shift_reg <= data_in;
                    busy      <= 'd1;
                    state     <= ST_START;
                end
            end
            
            ST_START: begin
                tx   <= 1'b0; 
                busy <= 1'b1;
                
                if (baud_tick) begin
                    tx    <= shift_reg[0]; 
                    state <= ST_DATA;
                end
            end

            ST_DATA: begin
                busy <= 1'b1;
   
                if (baud_tick) begin
                    if (bit_index == 3'd7) begin
                        tx    <= 1'b1; 
                        state <= ST_STOP;
                    end else begin
                        tx    <= shift_reg[bit_index + 1'b1];
                    end
                end
            end

            ST_STOP: begin
                tx   <= 1'b1;
                busy <= 1'b1;     
                if (baud_tick) begin
                    busy  <= 1'b0;
                    done  <= 1'b1; 
                    state <= ST_IDLE;
                end
            end

            default: begin
                state <= ST_IDLE;
            end
            endcase
        end
    end
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) bit_index <= 'd0;
        else if(state == ST_DATA && baud_tick) bit_index <= bit_index + 'd1;
    end

endmodule