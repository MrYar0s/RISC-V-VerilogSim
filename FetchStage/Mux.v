`include "../Constants.v"

module Mux (
    input [`INST_SIZE-1:0] i0,   output [`INST_SIZE-1:0] out,
    input [`INST_SIZE-1:0] i1,
    input sel
);

    assign out = (~sel) ? i0 : i1;

endmodule