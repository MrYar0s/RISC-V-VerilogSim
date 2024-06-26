`include "ExecuteStage/Alu.v"
`include "ExecuteStage/CondControl.v"
`include "ExecuteStage/ImmDecoder.v"

module ExecuteStage (
    input [2:0] ALU_CONTROL,        output [`INST_SIZE-1:0] ALU_OUT,
    input [1:0] ALU_SRC2,           output PC_R,
    input BRN_COND,                 output [4:0] RD,
    input MEM_WE,                   output MEM_WE_ME,
    input DE_WE,                    output ME_WE,
    input MEM_REG,                  output MEM_REG_ME,
    input [`INST_SIZE-1:0] D1,      output [`INST_SIZE-1:0] PC_DISP,
    input [`INST_SIZE-1:0] D2,      output [`INST_SIZE-1:0] WD_ME,
    input [24:0] Imm,
    input [`INST_SIZE-1:0] PC_EX,
    input [1:0] HU_RS1,
    input [1:0] HU_RS2,
    input [`INST_SIZE-1:0] BP_MEM,
    input [`INST_SIZE-1:0] BP_WB,
    input clk,
    input rst,
    input STALL,
    input FLUSH
);

    wire [`INST_SIZE-1:0] RS1_VAR, RS2_VAR, RS2_CHS;

    wire [`INST_SIZE-1:0] ALU_OUT_M;

    reg MEM_WE_M_r, ME_WE_M_r, MEM_REG_M_r;
    reg [`INST_SIZE-1:0] ALU_OUT_M_r, WD_ME_M_r;
    reg [4:0] RD_M_r;

    CondControl COND_CONTROL(
        .RS1V(RS1_VAR),
        .OUT(PC_R),
        .RS2V(RS2_VAR),
        .OP(Imm[7:5]),
        .BRN_COND(BRN_COND)
    );

    wire [`INST_SIZE-1:0] ImmI;
    wire [`INST_SIZE-1:0] ImmS;
    wire [`INST_SIZE-1:0] ImmB;

    ImmDecoder IMM_DECODER(
        .Imm(Imm),
        .IMM_I(ImmI),
        .IMM_S(ImmS),
        .IMM_B(ImmB)
    );

    Mux3 RS1_MUX (
        .i0(D1),
        .i1(BP_MEM),
        .i2(BP_WB),
        .sel(HU_RS1),
        .out(RS1_VAR)
    );

    Mux3 RS2_MUX (
        .i0(D2),
        .i1(BP_MEM),
        .i2(BP_WB),
        .sel(HU_RS2),
        .out(RS2_VAR)
    );

    Alu ALU(
        .A(RS1_VAR),
        .B(RS2_CHS),
        .ALU_CONTROL(ALU_CONTROL),
        .OUT(ALU_OUT_M)
    );

    Mux4 IMM_MUX (
        .i0(RS2_VAR),
        .i1(ImmI),
        .i2(ImmS),
        .i3(ImmB),
        .sel(ALU_SRC2),
        .out(RS2_CHS)
    );

    always @(posedge clk or negedge rst) begin
        if(rst || FLUSH) begin
            MEM_WE_M_r      <= 1'b0;
            ME_WE_M_r       <= 1'b0;
            MEM_REG_M_r     <= 1'b0;
            ALU_OUT_M_r     <= `INST_SIZE_ZEROS;
            WD_ME_M_r       <= `INST_SIZE_ZEROS;
            RD_M_r          <= 5'b00000;
        end
        else if (STALL == 1'b0) begin
            MEM_WE_M_r      <= MEM_WE;
            ME_WE_M_r       <= DE_WE;
            MEM_REG_M_r     <= MEM_REG;
            ALU_OUT_M_r     <= ALU_OUT_M;
            WD_ME_M_r       <= RS2_VAR;
            RD_M_r          <= Imm[4:0];
        end
    end

    assign ALU_OUT = ALU_OUT_M_r;
    assign RD = RD_M_r;
    assign WD_ME = WD_ME_M_r;
    assign MEM_WE_ME = MEM_WE_M_r;
    assign ME_WE = ME_WE_M_r;
    assign MEM_REG_ME = MEM_REG_M_r;
    assign PC_DISP = ImmB;

endmodule