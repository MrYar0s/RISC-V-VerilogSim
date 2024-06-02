module Summ (
    input [31:0] i0, output [31:0] out,
    input [31:0] i1
);

    assign out = i0 + i1;

endmodule