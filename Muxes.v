`include "../Constants.v"

module Mux2 (
    input [`INST_SIZE-1:0] i0,   output [`INST_SIZE-1:0] out,
    input [`INST_SIZE-1:0] i1,
    input sel
);

    assign out = (~sel) ? i0 : i1;

endmodule

module Mux3 (
    input [`INST_SIZE-1:0] i0,   output [`INST_SIZE-1:0] out,
    input [`INST_SIZE-1:0] i1,
    input [`INST_SIZE-1:0] i2,
    input [1:0] sel
);

    assign out = (sel == 2'b00) ? i0 :
                 (sel == 2'b01) ? i1 : i2;

endmodule

module Mux4 (
    input [`INST_SIZE-1:0] i0,   output [`INST_SIZE-1:0] out,
    input [`INST_SIZE-1:0] i1,
    input [`INST_SIZE-1:0] i2,
    input [`INST_SIZE-1:0] i3,
    input [1:0] sel
);

    assign out = (sel == 2'b00) ? i0 :
                 (sel == 2'b01) ? i1 :
                 (sel == 2'b10) ? i2 : i3;

endmodule
