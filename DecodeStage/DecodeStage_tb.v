module tb ();
    // Declare I/O
    reg clk = 1, rst, WB_WE;
    reg [31:0] PC_DE, WB_D, InstrD;
    reg [4:0] WB_A;
    wire [2:0] ALU_CONTROL;
    wire [1:0] ALU_SRC2;
    wire [31:0] D1, D2, PC_EX;
    wire [24:0] Imm;
    wire BRN_COND, MEM_WE, DE_WE, MEM_REG;

    // Declare the design under test
    DecodeStage decoder (
        .clk(clk),
        .rst(rst),
        .ALU_CONTROL(ALU_CONTROL),
        .ALU_SRC2(ALU_SRC2),
        .InstrD(InstrD),
        .BRN_COND(BRN_COND),
        .PC_DE(PC_DE),
        .MEM_WE(MEM_WE),
        .WB_WE(WB_WE),
        .DE_WE(DE_WE),
        .WB_A(WB_A),
        .MEM_REG(MEM_REG),
        .WB_D(WB_D),
        .D1(D1),
        .D2(D2),
        .Imm(Imm),
        .PC_EX(PC_EX)
    );

    // Generating of clock
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b1;
        WB_WE <= 1'b0;
        PC_DE <= 32'h00000000;
        WB_D <= 32'h00000000;
        InstrD <= 32'h00000000;
        WB_A <= 5'b00000;
        #200;
        rst <= 1'b0;
        #250;
        InstrD <= 32'h00500293;
        #100
        InstrD <= 32'h00000000;
        #500;
        $finish;
    end

    // Generating of VCD file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
endmodule