`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 02:14:53 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] pc_in,
    output logic [31:0] pc_out
);

always_ff@(posedge clk or posedge rst) begin
    if(rst) pc_out <= 'd0;
    else pc_out <= pc_in;
end

endmodule
