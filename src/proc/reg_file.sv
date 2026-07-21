`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 02:45:19 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input  logic        clk,
    input  logic        rst,
    input  logic        RegWrite,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] RD,
    output logic [31:0] RS1,
    output logic [31:0] RS2
);

    logic [31:0] register_file [0:31];
    
    always_ff@(posedge clk or posedge rst) begin
        if(rst) begin
            for(int i = 0; i < 32; i++) begin
                register_file[i] = i;
            end
        end
        else begin
           if(RegWrite && rd != 5'd0) register_file[rd] <= RD; 
        end
    end
    
    always_comb begin
        if(rst) begin
            RS1 = 'd0;
            RS2 = 'd0;
        end
        else begin
            RS1 = register_file[rs1];
            RS2 = register_file[rs2];
        end
    end

endmodule
