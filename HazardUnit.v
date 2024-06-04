`include "Constants.v"

module HazardUnit(input rst,            output[1:0] HU_RS1,
                  input REG_WRITE_ME,   output[1:0] HU_RS2,
                  input REG_WRITE_WB,   output STALL_FE,
                  input MEM_READ_ME,    output STALL_DE,
                  input[4:0] RD_ME,     output STALL_EX,
                  input[4:0] RD_WB,     output FLUSH,
                  input[4:0] RS1_EX,
                  input[4:0] RS2_EX,
                  input PC_R
                  );

    assign HU_RS1 = rst ? 2'b00 :
                       ((REG_WRITE_WB == 1'b1) & (RD_WB != 5'h00) & (RD_WB == RS1_EX)) ? `HU_SRC_WB :
                       ((REG_WRITE_ME == 1'b1) & (RD_ME != 5'h00) & (RD_ME == RS1_EX)) ? `HU_SRC_MEM : `HU_SRC_REG;

    assign HU_RS2 = rst ? 2'b00 :
                       ((REG_WRITE_WB == 1'b1) & (RD_WB != 5'h00) & (RD_WB == RS2_EX)) ? `HU_SRC_WB :
                       ((REG_WRITE_ME == 1'b1) & (RD_ME != 5'h00) & (RD_ME == RS2_EX)) ? `HU_SRC_MEM : `HU_SRC_REG;

    assign STALL_EX = rst ? 1'b0 :
                    ((MEM_READ_ME == 1'b1) & (RD_ME != 5'h00) & ((RD_ME == RS1_EX) | (RD_ME == RS2_EX))) ? 1'b1 : 1'b0;

    assign STALL_DE = STALL_EX;
    assign STALL_FE = STALL_DE;

    assign FLUSH = PC_R;

endmodule