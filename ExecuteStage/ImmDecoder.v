module ImmDecoder (
    input [24:0] Imm,   output [`INST_SIZE-1:0] IMM_I,
                        output [`INST_SIZE-1:0] IMM_S,
                        output [`INST_SIZE-1:0] IMM_B
);
    assign IMM_I = { {20{Imm[24]}}, Imm[24:13] };
    assign IMM_S = { {20{Imm[24]}}, Imm[24:18], Imm[4:0]};
    assign IMM_B = { {20{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0 };

endmodule