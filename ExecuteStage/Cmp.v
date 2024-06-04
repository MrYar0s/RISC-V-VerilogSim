`include "../Constants.v"
module Cmp (
    input [`INST_SIZE-1:0] RS1V,    output OUT,
    input [`INST_SIZE-1:0] RS2V,
    input [2:0] OP
);

    assign OUT = (OP == 3'b000) ? RS1V == RS2V :
                 (OP == 3'b001) ? RS1V != RS2V :
                 (OP == 3'b100) ? RS1V < RS2V :
                 (OP == 3'b101) ? RS1V >= RS2V :
                 1'b0;

endmodule