`include "MemoryStage/DataMemory.v"

module MemoryStage (
    input [`INST_SIZE-1:0] ALU_OUT, output [`INST_SIZE-1:0] WB_D,
    input [4:0] RD,                 output [4:0] WB_A,
    input MEM_WE,                   output WB_WE,
    input ME_WE,                    output [`INST_SIZE-1:0] BP_MEM,
    input MEM_REG,
    input [`INST_SIZE-1:0] WD_ME,
    input clk,
    input rst
);
    wire [`INST_SIZE-1:0] WB_D_M;

    reg WB_WE_M_r;
    reg [`INST_SIZE-1:0] WB_D_M_r;
    reg [4:0] WB_A_M_r;

    wire [`INST_SIZE-1:0] MEM_RD;

    DataMemory DATA_MEMORY(
        .WE(MEM_WE),
        .RD(MEM_RD),
        .WD(WD_ME),
        .A(ALU_OUT),
        .clk(clk),
        .rst(rst)
    );

    Mux2 MEM_MUX(
        .i0(ALU_OUT),
        .i1(MEM_RD),
        .sel(MEM_REG),
        .out(WB_D_M)
    );

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            WB_WE_M_r <= 1'b0;
            WB_A_M_r <= 5'b00000;
            WB_D_M_r <= 32'h00000000;
        end
        else begin
            WB_WE_M_r <= ME_WE;
            WB_A_M_r <= RD;
            WB_D_M_r <= WB_D_M;
        end
    end

    assign WB_D = WB_D_M_r;
    assign WB_A = WB_A_M_r;
    assign WB_WE = WB_WE_M_r;
    assign BP_MEM = ALU_OUT;

endmodule
