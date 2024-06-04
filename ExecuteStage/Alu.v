`include "Constants.v"

module Alu (
    input [`INST_SIZE-1:0] A,   output [`INST_SIZE-1:0] OUT,
    input [`INST_SIZE-1:0] B,
    input [2:0] ALU_CONTROL
);
    assign OUT = (ALU_CONTROL == `ALU_ADD) ? A + B :
                 (ALU_CONTROL == `ALU_SUB) ? A - B :
                 (ALU_CONTROL == `ALU_AND) ? A & B :
                 (ALU_CONTROL == `ALU_OR)  ? A | B :
                 (ALU_CONTROL == `ALU_XOR) ? A ^ B :
                 `INST_SIZE_ZEROS;
endmodule