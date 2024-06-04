`include "../Constants.v"

module MainController (
    input [6:0] opcode, output[1:0] ALU_OP,
                        output[1:0] ALU_SRC2,
                        output BRN_COND,
                        output MEM_WE,
                        output DE_WE,
                        output MEM_REG
);
    assign ALU_OP = (opcode == `OPCODE_ARITHM_REG) ? `ALU_OP_ARITHM_REG :
                    `ALU_OP_ARITHM_IMM;
    assign ALU_SRC2 = (opcode == `OPCODE_ARITHM_REG) ? `ALU_SRC1 :
                      (opcode == `OPCODE_ARITHM_IMM | opcode == `OPCODE_LOAD) ? `ALU_SRC2 :
                      (opcode == `OPCODE_STORE) ? `ALU_SRC3 :
                      `ALU_SRC4; // OPCODE_BRANCH
    assign BRN_COND = (opcode == `OPCODE_BRANCH) ? 1'b1 : 1'b0;
    assign MEM_WE = (opcode == `OPCODE_STORE) ? 1'b1 : 1'b0;
    assign DE_WE = (opcode == `OPCODE_LOAD | opcode == `OPCODE_ARITHM_REG | opcode == `OPCODE_ARITHM_IMM) ? 1'b1 : 1'b0;
    assign MEM_REG = (opcode == `OPCODE_LOAD) ? 1'b1 : 1'b0;
endmodule