`include "ExecuteStage/Cmp.v"

module CondControl (
    input [`INST_SIZE-1:0] RS1V,    output OUT,
    input [`INST_SIZE-1:0] RS2V,
    input [2:0] OP,
    input BRN_COND
);
    wire RES;
    Cmp CMP(
        .RS1V(RS1V),
        .RS2V(RS2V),
        .OP(OP),
        .OUT(RES)
    );
    assign OUT = BRN_COND & RES;

endmodule