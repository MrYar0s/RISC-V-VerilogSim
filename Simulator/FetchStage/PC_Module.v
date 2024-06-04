`include "Constants.v"

module PC_Module (
    input [`INST_SIZE-1:0] PC_NEXT, output reg[`INST_SIZE-1:0] PC,
    input clk,
    input rst
);

    always @(posedge clk) begin
        if (rst)
            PC <= `INST_SIZE_ZEROS;
        else
            PC <= PC_NEXT;
    end
endmodule