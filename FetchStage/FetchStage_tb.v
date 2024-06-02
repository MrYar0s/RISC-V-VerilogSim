module tb ();
    // Declare I/O
    reg clk = 1, rst, PC_R;
    reg [31:0] PC_EX, PC_DISP;
    wire [31:0] InstrD, PC_DE;

    // Declare the design under test
    FetchStage fetcher (
        .clk(clk),
        .rst(rst),
        .PC_R(PC_R),
        .PC_EX(PC_EX),
        .PC_DISP(PC_DISP),
        .PC_DE(PC_DE),
        .InstrD(InstrD)
    );

    // Generating of clock
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b1;
        PC_R <= 1'b0;
        PC_EX <= 1'b0;
        PC_DISP <= 1'b0;
        #200;
        rst <= 1'b0;
        #500;
        $finish;
    end

    // Generating of VCD file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
endmodule