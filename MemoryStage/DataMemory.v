`include "../Muxes.v"
`include "../Constants.v"

module DataMemory (
    input WE,                   output [`INST_SIZE-1:0] RD,
    input [`INST_SIZE-1:0] WD,
    input [`INST_SIZE-1:0] A,
    input clk,
    input rst
);

    reg[`INST_SIZE-1:0] Memory [`MEM_SIZE-1:0];

    always @(posedge clk) begin
        if (WE) begin
            Memory[A] <= WD;
        end
    end

    assign RD = rst ? 32'd0 : Memory[A];

endmodule
