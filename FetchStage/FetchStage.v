`include "InstructionMem.v"
`include "Mux.v"
`include "PC_Module.v"
`include "Summ.v"

module FetchStage (
    input clk,              output [31:0] InstrD,
    input rst,              output [31:0] PC_DE,
    input PC_R,
    input [31:0] PC_EX,
    input [31:0] PC_DISP
);

    wire [31:0] PC, PC_NEXT;

    wire [31:0] PC_1, PC_2;
    wire [31:0] InstrF;

    reg [31:0] InstrF_r;
    reg [31:0] PC_F_r;

    Mux PC1_MUX (
        .i0(PC),
        .i1(PC_EX),
        .sel(PC_R),
        .out(PC_1)
    );

    Mux PC2_MUX (
        .i0(32'h00000004),
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
        if (rst == 1'b1) begin
            InstrF_r <= 32'h00000000;
            PC_F_r <= 32'h00000000;
        end
        else begin
            InstrF_r <= InstrF;
            PC_F_r <= PC;
        end
    end

    assign InstrD = (rst == 1'b1) ? 32'h00000000 : InstrF_r;
    assign PC_DE = (rst == 1'b1) ? 32'h00000000 : PC_F_r;
endmodule