`include "Constants.v"

module RegFile (
    input clk,  output [`INST_SIZE-1:0] D1,
    input rst,  output [`INST_SIZE-1:0] D2,
    input WE3,
    input [`REG_NUM_SIZE-1:0] A1,
    input [`REG_NUM_SIZE-1:0] A2,
    input [`REG_NUM_SIZE-1:0] A3,
    input [`INST_SIZE-1:0] D3
);

    reg [`REG_FILE_SIZE-1:0] Registers [`INST_SIZE-1:0] /*verilator public*/;

    always @(negedge clk) begin
        if (WE3)
            Registers[A3] <= D3;
    end

    assign D1 = rst ? `INST_SIZE_ZEROS : Registers[A1];
    assign D2 = rst ? `INST_SIZE_ZEROS : Registers[A2];

    initial begin
        Registers[0] = `INST_SIZE_ZEROS;
    end

endmodule