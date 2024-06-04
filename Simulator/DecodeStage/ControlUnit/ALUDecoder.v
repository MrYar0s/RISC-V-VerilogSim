`include "Constants.v"

module ALUDecoder (
    input [1:0] ALU_OP,     output [2:0] ALU_CONTROL,
    input [6:0] funct7,
    input [2:0] funct3
);

    assign ALU_CONTROL = ((ALU_OP == `ALU_OP_ARITHM_IMM) & (funct3 == 3'b000)) ? `ALU_ADD :                                 // ADDI
                         ((ALU_OP == `ALU_OP_ARITHM_REG) & (funct3 == 3'b000) & (funct7 == 7'b0100000)) ? `ALU_SUB :          // SUB
                         ((ALU_OP == `ALU_OP_ARITHM_REG) & (funct3 == 3'b000) & (funct7 == 7'b0000000)) ? `ALU_ADD :          // ADD
                         ((ALU_OP == `ALU_OP_ARITHM_REG) & (funct3 == 3'b010)) ? `ALU_ADD :                                 // LW, SW
                         (((ALU_OP == `ALU_OP_ARITHM_IMM) | (ALU_OP == `ALU_OP_ARITHM_REG)) & (funct3 == 3'b000)) ? `ALU_AND :  // AND, ANDI
                         (((ALU_OP == `ALU_OP_ARITHM_IMM) | (ALU_OP == `ALU_OP_ARITHM_REG)) & (funct3 == 3'b110)) ? `ALU_OR :   // OR, ORI
                         (((ALU_OP == `ALU_OP_ARITHM_IMM) | (ALU_OP == `ALU_OP_ARITHM_REG)) & (funct3 == 3'b100)) ? `ALU_XOR :   // XOR, XORI
                        `ALU_ADD;
endmodule