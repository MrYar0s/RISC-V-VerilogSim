`include "ControlUnit/ALUDecoder.v"
`include "ControlUnit/MainController.v"

module ControlUnit (
    input [`INST_SIZE-1:0] InstrD,  output [2:0] ALU_CONTROL,
                                    output [1:0] ALU_SRC2,
                                    output BRN_COND,
                                    output MEM_WE,
                                    output DE_WE,
                                    output MEM_REG
);

    wire[1:0] ALU_OP;

    MainController MAIN_CONTROLLER(
        .opcode(InstrD[6:0]),
        .ALU_OP(ALU_OP),
        .ALU_SRC2(ALU_SRC2),
        .BRN_COND(BRN_COND),
        .MEM_WE(MEM_WE),
        .DE_WE(DE_WE),
        .MEM_REG(MEM_REG)
    );

    ALUDecoder ALU_DECODER(
        .ALU_OP(ALU_OP),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .ALU_CONTROL(ALU_CONTROL)
    );
endmodule