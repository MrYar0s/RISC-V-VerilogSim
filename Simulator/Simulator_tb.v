module tb ();
    // Declare I/O
    reg clk = 1, rst = 0;

    // Declare the design under test
    Simulator sim (
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
        #200;
        rst <= 1'b0;
        #1000;
        $finish;
    end

    // Generating of VCD file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
endmodule