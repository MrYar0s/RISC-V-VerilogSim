`define REG_NUM_SIZE    5
`define REG_FILE_SIZE   (1 << `REG_NUM_SIZE)
`define INST_SIZE       32
`define MEM_SIZE        65536
`define INCR_SIZE       32'h00000004
`define INST_SIZE_ZEROS 32'h00000000

// Constants for decoding
`define OPCODE_ARITHM_REG   7'b0110011
`define OPCODE_ARITHM_IMM   7'b0010011
`define OPCODE_LOAD         7'b0000011
`define OPCODE_STORE        7'b0100011
`define OPCODE_BRANCH       7'b1100011

`define ALU_SRC1            2'b00
`define ALU_SRC2            2'b01
`define ALU_SRC3            2'b10
`define ALU_SRC4            2'b11

// ALU Controls (+,- and so on)
`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_AND 3'b010
`define ALU_OR  3'b011
`define ALU_XOR 3'b100

// ALU operations
`define ALU_OP_ARITHM_REG   2'b00
`define ALU_OP_ARITHM_IMM   2'b01
