`include "../Constants.v"

module Summ (
    input [`INST_SIZE-1:0] i0, output [`INST_SIZE-1:0] out,
    input [`INST_SIZE-1:0] i1
);

    assign out = i0 + i1;

endmodule