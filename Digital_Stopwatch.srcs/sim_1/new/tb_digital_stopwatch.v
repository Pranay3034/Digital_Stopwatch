`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 03:04:52
// Design Name: 
// Module Name: tb_digital_stopwatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




`timescale 1ns / 1ps

module tb_digital_stopwatch;

    reg clk = 0;
    reg btnC = 1;
    reg btnU = 0;

    wire [6:0] seg;
    wire dp;
    wire [3:0] an;

    // Accelerated timing parameters for simulation
    digital_stopwatch_top #(
        .CLK_HZ(100),
        .SCAN_HZ(4)
    ) dut (
        .clk(clk),
        .btnC(btnC),
        .btnU(btnU),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

    // 100 MHz simulation clock: 10 ns period
    always #5 clk = ~clk;

    // Generate a start/pause button press
    task press_start_pause;
        begin
            @(negedge clk);
            btnU = 1'b1;

            repeat (5) @(negedge clk);
            btnU = 1'b0;

            // Allow synchronized button signals to settle
            repeat (5) @(negedge clk);
        end
    endtask

    initial begin
        $monitor(
            "Time=%0t running=%b display=%d%d:%d%d",
            $time, dut.running,
            dut.min_tens, dut.min_units,
            dut.sec_tens, dut.sec_units
        );

        // -------------------------
        // 1. Reset
        // -------------------------
        repeat (3) @(negedge clk);
        btnC = 1'b0;

        // -------------------------
        // 2. Start stopwatch
        // -------------------------
        press_start_pause;

        if (dut.running !== 1'b1)
            $fatal(1, "FAIL: Stopwatch did not start");

        // Wait for the timing pulse and allow
        // the BCD counter to consume it.
        @(posedge dut.second_tick);
        @(posedge clk);
        #1;

        if ({dut.min_tens, dut.min_units,
             dut.sec_tens, dut.sec_units} !== 16'h0001)
            $fatal(1, "FAIL: Expected 00:01");

        $display("PASS: Start and count to 00:01");

        // -------------------------
        // 3. Pause stopwatch
        // -------------------------
        press_start_pause;

        if (dut.running !== 1'b0)
            $fatal(1, "FAIL: Stopwatch did not pause");

        @(posedge dut.second_tick);
        @(posedge clk);
        #1;

        if ({dut.min_tens, dut.min_units,
             dut.sec_tens, dut.sec_units} !== 16'h0001)
            $fatal(1, "FAIL: Counter changed while paused");

        $display("PASS: Pause");

        // -------------------------
        // 4. Resume stopwatch
        // -------------------------
        press_start_pause;

        if (dut.running !== 1'b1)
            $fatal(1, "FAIL: Stopwatch did not resume");

        @(posedge dut.second_tick);
        @(posedge clk);
        #1;

        if ({dut.min_tens, dut.min_units,
             dut.sec_tens, dut.sec_units} !== 16'h0002)
            $fatal(1, "FAIL: Expected 00:02 after resume");

        $display("PASS: Resume and count to 00:02");

        // -------------------------
        // 5. Reset while running
        // -------------------------
        @(negedge clk);
        btnC = 1'b1;

        repeat (3) @(negedge clk);
        #1;

        if ({dut.min_tens, dut.min_units,
             dut.sec_tens, dut.sec_units} !== 16'h0000)
            $fatal(1, "FAIL: Reset did not clear digits");

        if (dut.running !== 1'b0)
            $fatal(1, "FAIL: Reset did not stop stopwatch");

        $display("PASS: Reset");

        $display("==================================");
        $display("ALL STOPWATCH INTEGRATION TESTS PASSED");
        $display("==================================");

        $finish;
    end

endmodule

