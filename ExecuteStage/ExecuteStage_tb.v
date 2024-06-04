module tb ();
    // Declare I/O
    reg clk = 1, rst, BRN_COND, MEM_WE, DE_WE, MEM_REG;
    reg [31:0] D1, D2, PC_EX, BP_MEM, BP_WB;
    reg [1:0] ALU_SRC2, HU_RS1, HU_RS2;
    reg [2:0] ALU_CONTROL;
    reg [24:0] Imm;
    wire [31:0] ALU_OUT, PC_DISP;
    wire PC_R, MEM_WE_ME, ME_WE, MEM_REG_ME;
    wire [4:0] RD;

    // Declare the design under test
    ExecuteStage executor (
        .ALU_CONTROL(ALU_CONTROL),
        .ALU_OUT(ALU_OUT),
        .ALU_SRC2(ALU_SRC2),
        .PC_R(PC_R),
        .BRN_COND(BRN_COND),
        .RD(RD),
        .MEM_WE(MEM_WE),
        .MEM_WE_ME(MEM_WE_ME),
        .DE_WE(DE_WE),
        .ME_WE(ME_WE),
        .MEM_REG(MEM_REG),
        .MEM_REG_ME(MEM_REG_ME),
        .D1(D1),
        .PC_DISP(PC_DISP),
        .D2(D2),
        .Imm(Imm),
        .PC_EX(PC_EX),
        .HU_RS1(HU_RS1),
        .HU_RS2(HU_RS2),
        .BP_MEM(BP_MEM),
        .BP_WB(BP_WB),
        .clk(clk),
        .rst(rst)
    );

    // Generating of clock
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b1;
        BRN_COND <= 1'b0;
        MEM_WE <= 1'b0;
        DE_WE <= 1'b0;
        MEM_REG <= 1'b0;
        D1 <= 32'h00000000;
        D2 <= 32'h00000000;
        PC_EX <= 32'h00000000;
        BP_MEM <= 32'h00000000;
        BP_WB <= 32'h00000000;
        ALU_SRC2 <= 2'b00;
        HU_RS1 <= 2'b00;
        HU_RS2 <= 2'b00;
        ALU_CONTROL <= 3'b000;
        Imm <= 25'b0000000000000000000000000;
        #200;
        rst <= 1'b0;
        #250;
        Imm <= 25'b0000000001010000000000101;
        DE_WE <= 1'b1;
        ALU_SRC2 <= 2'b01;
        #100
        DE_WE <= 1'b0;
        ALU_SRC2 <= 2'b00;
        Imm <= 25'b0000000000000000000000000;
        #500;
        $finish;
    end

    // Generating of VCD file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
endmodule