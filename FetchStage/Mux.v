module Mux (
    input [31:0] i0,   output [31:0] out,
    input [31:0] i1,
    input sel
);

    assign out = (~sel) ? i0 : i1;

endmodule