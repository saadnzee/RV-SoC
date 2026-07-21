`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 05:49:28 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input  logic        clk,
    input  logic        rst,
    input  logic        MemWrite,
    input  logic        MemRead,
    input  logic [31:0] Rs2,
    input  logic [31:0] ALUResult,
    output logic [31:0] MemReadData
);

    // each location is 8-bit wide (byte-addressable)
    logic [7:0] data_memory [0:39];
        
    initial begin
    
        // word 0: A col0
        data_memory[0] = 'd1;
        data_memory[1] = 'd4;
        data_memory[2] = 'd7;
        data_memory[3] = 'd0;
        
        // word 1: A col1
        data_memory[4] = 'd2;
        data_memory[5] = 'd5;
        data_memory[6] = 'd8;
        data_memory[7] = 'd0;
        
        // word 2: A col2
        data_memory[8]  = 'd3;
        data_memory[9]  = 'd6;
        data_memory[10] = 'd9;
        data_memory[11] = 'd0;
        
        // word 3: B row0
        data_memory[12] = 'd9;
        data_memory[13] = 'd8;
        data_memory[14] = 'd7;
        data_memory[15] = 'd0;
        
        // word 4: B row1
        data_memory[16] = 'd6;
        data_memory[17] = 'd5;
        data_memory[18] = 'd4;
        data_memory[19] = 'd0;
        
        // word 5: B row2
        data_memory[20] = 'd3;
        data_memory[21] = 'd2;
        data_memory[22] = 'd1;
        data_memory[23] = 'd0;

        data_memory[24] = 'd0;
        data_memory[25] = 'd0;
        data_memory[26] = 'd0;
        data_memory[27] = 'd0;
        data_memory[28] = 'd0;
        data_memory[29] = 'd0;
        data_memory[30] = 'd0;
        data_memory[31] = 'd0;
        data_memory[32] = 'd0;
        data_memory[33] = 'd0;
        data_memory[34] = 'd0;
        data_memory[35] = 'd0;
        data_memory[36] = 'd0;
        data_memory[37] = 'd0;
        data_memory[38] = 'd0;
        data_memory[39] = 'd0;
        
    end
    
    always_ff@(posedge clk) begin
        if(MemWrite) {data_memory[ALUResult+3], data_memory[ALUResult+2], data_memory[ALUResult+1], data_memory[ALUResult]} <= Rs2;
    end
    
    always_comb begin
        if(MemRead) MemReadData = {data_memory[ALUResult+3], data_memory[ALUResult+2], data_memory[ALUResult+1], data_memory[ALUResult]};
    end

endmodule