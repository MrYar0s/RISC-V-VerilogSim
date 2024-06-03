`include "ControlUnit/ControlUnit.v"
`include "RegFile.v"

module DecodeStage (
    input clk,                      output [2:0] ALU_CONTROL,
    input rst,                      output [1:0] ALU_SRC2,
    input [`INST_SIZE-1:0] InstrD,  output BRN_COND,
    input [`INST_SIZE-1:0] PC_DE,   output MEM_WE,
    input WB_WE,                    output DE_WE,
    input [`REG_NUM_SIZE-1:0] WB_A, output MEM_REG,
    input [`INST_SIZE-1:0] WB_D,    output [`INST_SIZE-1:0] D1,
                                    output [`INST_SIZE-1:0] D2,
                                    output [24:0] Imm,
                                    output [`INST_SIZE-1:0] PC_EX
);

    wire [2:0] ALU_CONTROL_D;
    wire [1:0] ALU_SRC2_D;
    wire BRN_COND_D, MEM_WE_D, DE_WE_D, MEM_REG_D;
    wire [`INST_SIZE-1:0] D1_D, D2_D;

    reg [2:0] ALU_CONTROL_D_r;
    reg [1:0] ALU_SRC2_D_r;
    reg BRN_COND_D_r, MEM_WE_D_r, DE_WE_D_r, MEM_REG_D_r;
    reg [`INST_SIZE-1:0] D1_D_r, D2_D_r, PC_EX_r;
    reg [24:0] Imm_r;

    RegFile REG_FILE(
        .clk(clk),
        .rst(rst),
        .WE3(WB_WE),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(WB_A),
        .D3(WB_D),
        .D1(D1_D),
        .D2(D2_D)
    );

    ControlUnit CONTROL_UNIT(
        .InstrD(InstrD),
        .ALU_CONTROL(ALU_CONTROL_D),
        .ALU_SRC2(ALU_SRC2_D),
        .BRN_COND(BRN_COND_D),
        .MEM_WE(MEM_WE_D),
        .DE_WE(DE_WE_D),
        .MEM_REG(MEM_REG_D)
    );

    always @(posedge clk or negedge rst) begin
        if(rst) begin
            ALU_CONTROL_D_r <=  3'b000;
            ALU_SRC2_D_r <=     2'b00;
            BRN_COND_D_r <=     1'b0;
            MEM_WE_D_r <=       1'b0;
            DE_WE_D_r <=        1'b0;
            MEM_REG_D_r <=      1'b0;
            D1_D_r <=           `INST_SIZE_ZEROS;
            D2_D_r <=           `INST_SIZE_ZEROS;
            PC_EX_r <=          `INST_SIZE_ZEROS;
            Imm_r <=            24'h000000;
        end
        else begin
            ALU_CONTROL_D_r <= ALU_CONTROL_D; 
            ALU_SRC2_D_r <= ALU_SRC2_D;
            BRN_COND_D_r <= BRN_COND_D;
            MEM_WE_D_r <= MEM_WE_D;
            DE_WE_D_r <= DE_WE_D;
            MEM_REG_D_r <= MEM_REG_D;
            D1_D_r <= D1_D;
            D2_D_r <= D2_D;
            PC_EX_r <= PC_EX;
            Imm_r <= InstrD[31:7];
        end
    end

    assign ALU_CONTROL = ALU_CONTROL_D_r;
    assign ALU_SRC2 = ALU_SRC2_D_r;
    assign BRN_COND = BRN_COND_D_r;
    assign MEM_WE = MEM_WE_D_r;
    assign DE_WE = DE_WE_D_r;
    assign MEM_REG = MEM_REG_D_r;
    assign D1 = D1_D_r;
    assign D2 = D2_D_r;
    assign PC_EX = PC_EX_r;
    assign Imm = Imm_r;

endmodule