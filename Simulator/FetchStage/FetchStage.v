`include "FetchStage/InstructionMem.v"
`include "Muxes.v"
`include "FetchStage/PC_Module.v"
`include "FetchStage/Summ.v"
`include "Constants.v"

module FetchStage (
    input clk,              output [`INST_SIZE-1:0] InstrD,
    input rst,              output [`INST_SIZE-1:0] PC_DE,
    input PC_R,
    input [`INST_SIZE-1:0] PC_EX,
    input [`INST_SIZE-1:0] PC_DISP,
    input STALL,
    input FLUSH
);

    wire [`INST_SIZE-1:0] PC /*verilator public*/;
    wire [`INST_SIZE-1:0] PC_NEXT;

    wire [`INST_SIZE-1:0] PC_1, PC_2;
    wire [`INST_SIZE-1:0] InstrF;

    reg [`INST_SIZE-1:0] InstrF_r;
    reg [`INST_SIZE-1:0] PC_F_r;

    Mux2 PC1_MUX (
        .i0(PC),
        .i1(PC_EX),
        .sel(PC_R),
        .out(PC_1)
    );

    Mux2 PC2_MUX (
        .i0(`INCR_SIZE),
        .i1(PC_DISP),
        .sel(PC_R),
        .out(PC_2)
    );

    Summ PC_SUMM (
        .i0(PC_1),
        .i1(PC_2),
        .out(PC_NEXT)
    );

    PC_Module PC_MODULE (
        .clk(clk),
        .rst(rst),
        .PC_NEXT(PC_NEXT),
        .PC(PC)
    );

    InstructionMem IMEM(
        .rst(rst),
        .A(PC),
        .D(InstrF)
    );

    always @(posedge clk or negedge rst) begin
        if (rst |||FLUSH) begin
            InstrF_r <= `INST_SIZE_ZEROS;
            PC_F_r <= `INST_SIZE_ZEROS;
        end
        else if (STALL == 1'b0) begin
            InstrF_r <= InstrF;
            PC_F_r <= PC;
        end
    end

    assign InstrD = rst ? `INST_SIZE_ZEROS : InstrF_r;
    assign PC_DE = rst ? `INST_SIZE_ZEROS : PC_F_r;
endmodule