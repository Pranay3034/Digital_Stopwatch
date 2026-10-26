`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 01:42:03
// Design Name: 
// Module Name: tb_bcd_counter
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

module tb_bcd_counter;

    reg clk = 0;
    reg reset = 1;
    reg second_tick = 0;
    reg running = 1;

    wire [3:0] min_tens;
    wire [3:0] min_units;
    wire [3:0] sec_tens;
    wire [3:0] sec_units;

    integer i;

    bcd_counter dut (
        .clk(clk),
        .reset(reset),
        .second_tick(second_tick),
        .running(running),
        .min_tens(min_tens),
        .min_units(min_units),
        .sec_tens(sec_tens),
        .sec_units(sec_units)
    );

    always #5 clk = ~clk;

    // Generate one enable pulse per simulated second
    task tick_once;
        begin
            @(negedge clk);
            second_tick = 1;

            @(negedge clk);
            second_tick = 0;
            #1;
        end
    endtask

    initial begin
        $monitor(
            "Time=%0t Run=%b | Display=%d%d:%d%d",
            $time, running,
            min_tens, min_units, sec_tens, sec_units
        );

        repeat (2) @(negedge clk);
        reset = 0;

        // Test 00:00 -> 00:59
        for (i = 0; i < 59; i = i + 1)
            tick_once;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h0059)
            $fatal(1, "FAIL: Expected 00:59");

        $display("PASS: 00:59 reached");

        // Test 00:59 -> 01:00
        tick_once;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h0100)
            $fatal(1, "FAIL: Expected 01:00");

        $display("PASS: 00:59 -> 01:00");

        // Advance from 01:00 to 99:59
        for (i = 60; i < 5999; i = i + 1)
            tick_once;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h9959)
            $fatal(1, "FAIL: Expected 99:59");

        $display("PASS: 99:59 reached");

        // Test full rollover
        tick_once;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h0000)
            $fatal(1, "FAIL: Expected 00:00");

        $display("PASS: 99:59 -> 00:00");

        // Test pause
        running = 0;
        tick_once;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h0000)
            $fatal(1, "FAIL: Counter changed while paused");

        $display("PASS: Pause");

        // Test resume
        running = 1;
        tick_once;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h0001)
            $fatal(1, "FAIL: Resume failed");

        $display("PASS: Resume");

        // Test reset
        @(negedge clk);
        reset = 1;

        @(negedge clk);
        #1;

        if ({min_tens,min_units,sec_tens,sec_units}
            !== 16'h0000)
            $fatal(1, "FAIL: Reset failed");

        $display("PASS: Reset");
        $display("ALL BCD COUNTER TESTS PASSED");

        $finish;
    end

endmodule

