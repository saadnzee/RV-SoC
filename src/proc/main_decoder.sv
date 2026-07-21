`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 03:32:17 PM
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(
    input  logic [6:0]  opcode,
    input  logic        zeroFlag,
    output logic        RegWrite,
    output logic [1:0]  ImmSrc,
    output logic        ALUSrc,
    output logic        MemWrite,
    output logic        MemRead,
    output logic [1:0]  ResultSrc,
    output logic        Branch,
    output logic        Jump,
    output logic [1:0]  ALUop
);

    // Opcodes
    localparam R_Type = 'b0110011,
               L_Type = 'b0000011,
               I_Type = 'b0010011,
               S_Type = 'b0100011,
               B_Type = 'b1100011,
               J_Type = 'b1101111;

    always_comb begin
        case(opcode)
            R_Type: begin
                RegWrite = 'b1;
                ImmSrc = 'b0;         // dont-care
                ALUSrc = 'b0;
                MemWrite = 'b0;
                MemRead = 'b0;
                ResultSrc = 'b00;
                Branch = 'b0;
                Jump = 'b0;
                ALUop = 'b10;
            end
            L_Type: begin
                RegWrite = 'b1;
                ImmSrc = 'b00;
                ALUSrc = 'b1;
                MemWrite = 'b0;
                MemRead = 'b1;
                ResultSrc = 'b01;
                Branch = 'b0;
                Jump = 'b0;
                ALUop = 'b00;
            end
            I_Type: begin
                RegWrite = 'b1;
                ImmSrc = 'b00;
                ALUSrc = 'b1;
                MemWrite = 'b0;
                MemRead = 'b0;
                ResultSrc = 'b00;
                Branch = 'b0;
                Jump = 'b0;
                ALUop = 'b10;
            end
            S_Type: begin
                RegWrite = 'b0;
                ImmSrc = 'b01;
                ALUSrc = 'b1;
                MemWrite = 'b1;
                MemRead = 'b0;
                ResultSrc = 'b0;       // dont-care
                Branch = 'b0;
                Jump = 'b0;
                ALUop = 'b00;
            end
            B_Type: begin
                RegWrite = 'b0;
                ImmSrc = 'b10;
                ALUSrc = 'b0;
                MemWrite = 'b0;
                MemRead = 'b0;
                ResultSrc = 'b0;       // dont-care
                Branch = 'b1;
                Jump = 'b0;
                ALUop = 'b01;
            end
            J_Type: begin
                RegWrite = 'b1;
                ImmSrc = 'b11;
                ALUSrc = 'b0;          // dont-care
                MemWrite = 'b0;
                MemRead = 'b0;
                ResultSrc = 'b10;       
                Branch = 'b0;
                Jump = 'b1;
                ALUop = 'b00;          // dont-care 
            end
            // default case
            default: begin
                RegWrite = 'b0;
                ImmSrc = 'b00;
                ALUSrc = 'b0;
                MemWrite = 'b0;
                ResultSrc = 'b00;
                Branch = 'b0;
                Jump = 'b0;
                ALUop = 'b00;
            end
        endcase 
    end

endmodule
