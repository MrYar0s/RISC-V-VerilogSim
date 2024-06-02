module InstructionMem (
    input rst,          output [31:0] D,
    input [31:0] A
);

    reg [31:0] Memory[65535:0];

    assign D = (rst == 1'b1) ? {32{1'b0}} : Memory[A[17:2]];

    // initial begin
    //     $readmemh("memfile.hex", Memory);
    // end

endmodule