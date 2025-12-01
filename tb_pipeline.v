// tb_pipeline.v
`timescale 1ns/1ps
module tb_pipeline;
    reg clk;
    reg reset;

    // DUT
    top_pipeline uut(.clk(clk), .reset(reset));

    initial begin
        $dumpfile("pipeline.vcd");
        $dumpvars(0, uut);

        clk = 0;
        reset = 1;
        #20;
        reset = 0;

        // run for a while
        #2000;
        $display("Simulation finished");
        $finish;
    end

    always #5 clk = ~clk;
endmodule
