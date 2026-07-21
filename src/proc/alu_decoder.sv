`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 03:39:11 PM
// Design Name: 
// Module Name: alu_decoder
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


module alu_decoder(
    input  logic [1:0]  ALUop,
    input  logic        opcode_5,
    input  logic [2:0]  funct3,
    input  logic        funct7_5,
    output logic [2:0]  ALUControl
);

    logic [1:0] op5_funct7_5;
    
    assign op5_funct7_5 = {opcode_5, funct7_5};

    always_comb begin
        case(ALUop)
            // LW, SW
            2'b00: begin
                ALUControl = 3'b000;
            end
            // Branch
            2'b01: begin
                ALUControl = 3'b001;
            end
            // R/I-Type
            2'b10: begin
                if(funct3 == 3'b000) begin
                    if(op5_funct7_5 == 2'b11) ALUControl = 3'b001;
                    else ALUControl = 3'b000;
                end
                else if(funct3 == 3'b010) begin
                    ALUControl = 3'b101;
                end
                else if(funct3 == 3'b110) begin
                    ALUControl = 3'b011;
                end
                else if(funct3 == 3'b111) begin
                    ALUControl = 3'b010;
                end
            end
        endcase 
    end

endmodule

