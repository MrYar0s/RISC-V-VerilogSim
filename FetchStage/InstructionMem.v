`include "../Constants.v"

module InstructionMem (
    input rst,          output [`INST_SIZE-1:0] D,
    input [`INST_SIZE-1:0] A
);

    reg [`INST_SIZE-1:0] Memory[`MEM_SIZE-1:0];

    assign D = rst ? {32{1'b0}} : Memory[A[17:2]];

    initial begin
        $readmemh("memfile.hex", Memory);
    end

endmodule