module PC_Module (
    input [31:0] PC_NEXT, output reg[31:0] PC,
    input clk,
    input rst
);

    always @(posedge clk) begin
        if (rst == 1'b1)
            PC <= {32{1'b0}};
        else
            PC <= PC_NEXT;
    end
endmodule