`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2026 10:06:21 AM
// Design Name: 
// Module Name: tb_rv32i_soc_top
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


module tb_rv32i_soc_top;

    logic clk;
    logic rst;
    logic led_out;

    rv32i_soc_top dut (
        .clk     (clk),
        .rst     (rst),
        .led_out (led_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10;
        rst = 0;
    end

    // End simulation
    initial begin
        #100;
        $finish;
    end

endmodule