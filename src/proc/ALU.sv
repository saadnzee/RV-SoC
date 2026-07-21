`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 05:29:02 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input  logic [31:0]  Rs1,
    input  logic [31:0]  Rs2,
    input  logic [2:0]   ALUControl,
    output logic [31:0]  ALUResult,
    output logic         zeroFlag
);

    always_comb begin
        case(ALUControl)
            3'b010: ALUResult = Rs1 & Rs2;
            3'b011: ALUResult = Rs1 | Rs2;
            3'b000: ALUResult = Rs1 + Rs2;
            3'b001: ALUResult = Rs1 - Rs2;
            3'b101: ALUResult = ($signed(Rs1) < $signed(Rs2)) ? 32'd1 : 32'd0;
            default: ALUResult = 0;
        endcase
    end
    
    assign zeroFlag = (Rs1 == Rs2) ? 1'b1 : 1'b0;

endmodule
