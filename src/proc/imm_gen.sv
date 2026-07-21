`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 02:36:23 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input  logic [31:0] instruction,
    input  logic [1:0]  ImmSrc, 
    output logic [31:0] imm
);

    // S-Type Immediate
    logic [4:0] imm_4_0;
    logic [6:0] imm_11_5;
    
    // B-Type Immediate
    logic imm_11;
    logic [3:0] imm_4_1;
    logic [5:0] imm_10_5;
    logic imm_12;
    
    // J-Type Immediate
    logic [7:0] j_imm_19_12;    
    logic j_imm_11;
    logic [9:0] j_imm_10_1;
    logic j_imm_20;
    
    // I-Type, S-Type and B-Type Immediate
    logic [11:0] imm_11_0;  // 12-bit - I-Type   
    logic [11:0] s_imm;     // 12-bit
    logic [12:0] b_imm;     // 13-bit
    logic [20:0] j_imm;     // 21-bit
    
    
    always_comb begin
        // --- I-Type ---
        imm_11_0 = instruction[31:20];
        // --- S-Type ---
        imm_4_0 = instruction[11:7];
        imm_11_5 = instruction[31:25];
        // --- B-Type ---
        imm_11 = instruction[7];
        imm_4_1 = instruction[11:8];
        imm_10_5 = instruction[30:25];
        imm_12 = instruction[31];
        // --- J-Type ---
        j_imm_19_12 = instruction[19:12];
        j_imm_11 = instruction[20];
        j_imm_10_1 = instruction[30:21];
        j_imm_20 = instruction[31];
    end
    
    always_comb begin
        s_imm = {imm_11_5, imm_4_0};
        b_imm = {imm_12, imm_11, imm_10_5, imm_4_1, 1'b0};
//        j_imm = {j_imm_20, j_imm_10_1, j_imm_11, j_imm_19_12, 1'b0};
        j_imm = {j_imm_20, j_imm_19_12, j_imm_11, j_imm_10_1, 1'b0};
    end
    
    always_comb begin
        case(ImmSrc)
            2'b00:   imm = {{20{imm_11_0[11]}}, imm_11_0};  // I-Type
            2'b01:   imm = {{20{s_imm[11]}}, s_imm};        // S-Type
            2'b10:   imm = {{19{b_imm[12]}}, b_imm};        // B-Type
            2'b11:   imm = {{11{j_imm[20]}}, j_imm};        // J-Type
            default: imm = 'd0;
        endcase 
    end      

endmodule
