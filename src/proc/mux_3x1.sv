`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2026 06:14:59 AM
// Design Name: 
// Module Name: mux_3x1
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


module mux_3x1(
    input  logic [31:0]  a,
    input  logic [31:0]  b,
    input  logic [31:0]  c,
    input  logic [1:0]   sel,
    output logic [31:0]  out
);

    always_comb begin
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = 'd0;
            default: out = 'd0; 
        endcase
    end
    
endmodule
