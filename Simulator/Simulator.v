`include "FetchStage/FetchStage.v"
`include "DecodeStage/DecodeStage.v"
`include "ExecuteStage/ExecuteStage.v"
`include "MemoryStage/MemoryStage.v"
`include "HazardUnit.v"
`include "Constants.v"

module Simulator (input clk, input rst);

    wire [`INST_SIZE-1:0] PC_EX, PC_DISP, InstrD, PC_DE, WB_D, D1, D2, BP_MEM, ALU_OUT, WD_ME;
    wire PC_R, WB_WE, BRN_COND, MEM_WE, DE_WE, MEM_REG, MEM_REG_ME, MEM_WE_ME, ME_WE, STALL_EX, STALL_FE, STALL_DE, FLUSH;
    wire [`REG_NUM_SIZE-1:0] WB_A;
    wire [2:0] ALU_CONTROL;
    wire [1:0] ALU_SRC2, HU_RS1, HU_RS2;
    wire [24:0] Imm;
    wire [4:0] RD, RS1_EX, RS2_EX;

    FetchStage FETCH_STAGE(
        // Inputs
        .clk(clk),
        .rst(rst),
        .PC_R(PC_R),
        .PC_EX(PC_EX),
        .PC_DISP(PC_DISP),
        .FLUSH(FLUSH),
        .STALL(STALL_FE),
        // Outputs
        .InstrD(InstrD),
        .PC_DE(PC_DE)
    );

    DecodeStage DECODE_STAGE(
        // Inputs
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PC_DE(PC_DE),
        .WB_WE(WB_WE),
        .WB_A(WB_A),
        .WB_D(WB_D),
        .FLUSH(FLUSH),
        .STALL(STALL_DE),
        // Outputs
        .ALU_CONTROL(ALU_CONTROL),
        .ALU_SRC2(ALU_SRC2),
        .BRN_COND(BRN_COND),
        .MEM_WE(MEM_WE),
        .DE_WE(DE_WE),
        .MEM_REG(MEM_REG),
        .D1(D1),
        .D2(D2),
        .Imm(Imm),
        .PC_EX(PC_EX),
        .RS1_EX(RS1_EX),
        .RS2_EX(RS2_EX)
    );

    ExecuteStage EXECUTE_STAGE(
        // Inputs
        .clk(clk),
        .rst(rst),
        .ALU_CONTROL(ALU_CONTROL),
        .ALU_SRC2(ALU_SRC2),
        .BRN_COND(BRN_COND),
        .MEM_WE(MEM_WE),
        .DE_WE(DE_WE),
        .MEM_REG(MEM_REG),
        .D1(D1),
        .D2(D2),
        .Imm(Imm),
        .PC_EX(PC_EX),
        .HU_RS1(HU_RS1),
        .HU_RS2(HU_RS2),
        .BP_MEM(BP_MEM),
        .BP_WB(WB_D),
        .FLUSH(FLUSH),
        .STALL(STALL_EX),
        // Outputs
        .ALU_OUT(ALU_OUT),
        .PC_R(PC_R),
        .RD(RD),
        .MEM_WE_ME(MEM_WE_ME),
        .ME_WE(ME_WE),
        .MEM_REG_ME(MEM_REG_ME),
        .PC_DISP(PC_DISP),
        .WD_ME(WD_ME)
    );

    MemoryStage MEMORY_STAGE(
        // Inputs
        .clk(clk),
        .rst(rst),
        .ALU_OUT(ALU_OUT),
        .RD(RD),
        .MEM_WE(MEM_WE_ME),
        .ME_WE(ME_WE),
        .MEM_REG(MEM_REG_ME),
        .WD_ME(WD_ME),
        // Outputs
        .WB_D(WB_D),
        .WB_A(WB_A),
        .WB_WE(WB_WE),
        .BP_MEM(BP_MEM)
    );

    HazardUnit HAZARD_UNIT(
        // Inputs
        .rst(rst),
        .REG_WRITE_ME(ME_WE),
        .REG_WRITE_WB(WB_WE),
        .MEM_READ_ME(MEM_REG_ME),
        .RD_ME(RD),
        .RD_WB(WB_A),
        .RS1_EX(RS1_EX),
        .RS2_EX(RS2_EX),
        .PC_R(PC_R),
        // Outputs
        .HU_RS1(HU_RS1),
        .HU_RS2(HU_RS2),
        .STALL_FE(STALL_FE),
        .STALL_DE(STALL_DE),
        .STALL_EX(STALL_EX),
        .FLUSH(FLUSH)
    );

endmodule