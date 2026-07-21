`timescale 1ns / 1ps


module baud_rate_generator #(
    parameter integer CLOCK_FREQ_HZ = 100_000_000,  // 100MHz
    parameter integer TICK_RATE_HZ  = 9600          // 9600bps
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);

    localparam integer DIVIDER = CLOCK_FREQ_HZ / TICK_RATE_HZ;
    
    reg [31:0] count;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 'd0;
            tick  <= 'd0;

        end
        else begin
            if( count == DIVIDER-1 ) begin
                count <= 'd0;
                tick  <= ~tick;
            end
            else begin
                count <= count + 'd1;
                tick  <= 'd0;
            end
        end
    end

endmodule