`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 04:06:14 PM
// Design Name: 
// Module Name: top_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Exposed memory-request interface (MemWrite/MemRead/
//                 ALUResult/RS2/MemReadData) as ports, and added a
//                 `stall` input that freezes the PC and blocks the
//                 register-file write, so an external (Wishbone) memory
//                 with non-zero access latency can be attached without
//                 changing anything else in the datapath.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rv32i(
    input  logic        clk,
    input  logic        rst,
    output logic [31:0] pc_out,

    // -- External memory-request interface (was internal-only before;
    //    data_mem used to live inside this module, now it doesn't) --
    output logic         MemWrite,
    output logic         MemRead,
    output logic [31:0]  ALUResult,
    output logic [31:0]  RS2,
    input  logic [31:0]  MemReadData,

    // -- Stall: freeze PC and register writeback while a load/store is
    //    waiting on an external memory that isn't zero-latency --
    input  logic         stall
);

    // -- PC Signals -- 
    logic [31:0] pc_in;         // input to program_counter (either PCPlus4 or PCTarget)
    logic [31:0] pc_in_held;    // pc_in, but held at pc_out while stalling
    logic [31:0] PCTarget;      // branch/jump address
    logic [31:0] PCPlus4;       // normal pc + 4
    
    // -- Instruction Memory Signals -- 
    logic [31:0] instruction;   // output of inst memory
    
    // -- Instruction Decoder Signals -- 
    logic [6:0]  opcode;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    
    // Signal for BEQ instruction
    logic        zeroFlag;      // comes from ALU
    
    // Main Decoder's Control Signals
    logic        RegWrite;
    logic        RegWrite_gated; // RegWrite, blocked while stall is high
    logic [1:0]  ImmSrc;
    logic        ALUSrc;
    logic        PCSrc;
    logic [1:0]  ResultSrc;
    logic        Branch;
    logic        Jump;
    logic [1:0]  ALUop;         // Input to ALU Decoder
    
    // ALU Decoder Signals
    logic [2:0]  ALUControl;    // tells ALU what operation to perform
    
    // Input to ALU (I-Type/S-Type)
    logic [31:0] imm;
    
    // Register File Signals
    logic [31:0] RD_Mux;
    logic [31:0] RS1;           // what goes into ALU
    logic [31:0] RS2_Mux;       // what goes into ALU (either RS2 or Imm)
    
    // Control Signals that goes into the PC Mux (Decides whether input to PC is PCPlus4 or PCTarget)
    assign PCSrc = (Branch == 1'b1 && zeroFlag == 1'b1) || Jump == 1'b1;

    // PC Mux
    mux_2x1 pc_mux(
        .a(PCPlus4),
        .b(PCTarget),
        .sel(PCSrc),
        .out(pc_in)
    );

    // Freeze the PC while stalling: feed pc_out back into itself instead
    // of advancing, so the same (memory) instruction stays fetched and
    // decoded until MemReadData/ack are actually valid.
    mux_2x1 pc_freeze_mux(
        .a(pc_in),
        .b(pc_out),
        .sel(stall),
        .out(pc_in_held)
    );

    program_counter prog_counter(
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in_held),
        .pc_out(pc_out)
    );
    
    inst_mem instruction_memory (
        .pc(pc_out),
        .instruction(instruction)
    );
    
    // PC + 4 == Adder
    adder32 adder0(
        .a(pc_out),
        .b(32'd4),
        .s(PCPlus4)
    );
    
    // Branch Target Calculator - PC+ Imm
    adder32 adder1(
        .a(pc_out),
        .b(imm),
        .s(PCTarget)
    );
    
    inst_decode i_decoder (
        .instruction(instruction),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7)
    );
    
    main_decoder m_decoder (
        .opcode(opcode),
        .zeroFlag(zeroFlag),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUop(ALUop)
    );   
    
    alu_decoder a_decoder (
        .ALUop(ALUop),
        .opcode_5(opcode[5]),
        .funct3(funct3),
        .funct7_5(funct7[5]),
        .ALUControl(ALUControl)
    );
    
    imm_gen immediate_generator (
        .instruction(instruction),
        .ImmSrc(ImmSrc), 
        .imm(imm)
    );

    // Decides what is written into Register File
    mux_3x1 reg_file_mux(
        .a(ALUResult),
        .b(MemReadData),
        .c(PCPlus4),
        .sel(ResultSrc),
        .out(RD_Mux)
    );   

    // Block the register write while stalling: a `lw` must not commit to
    // the register file until MemReadData is actually valid (i.e. until
    // stall drops on the ack cycle). Every other instruction is
    // unaffected since stall is only ever high during a memory wait.
    assign RegWrite_gated = RegWrite & ~stall;

    reg_file register_file (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite_gated),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .RD(RD_Mux),
        .RS1(RS1),
        .RS2(RS2)
    );
    
    // ALU Src B Mux
    mux_2x1 alu_srcb_mux(
        .a(RS2),
        .b(imm),
        .sel(ALUSrc),
        .out(RS2_Mux)
    );
    
    ALU alu (
        .Rs1(RS1),
        .Rs2(RS2_Mux),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .zeroFlag(zeroFlag)
    );

endmodule