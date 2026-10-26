`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 02:57:23
// Design Name: 
// Module Name: tb_display_scanner
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

module tb_display_scanner;

    reg clk = 0;
    reg reset = 1;
    reg scan_tick = 0;

    reg [3:0] min_tens  = 4'd1;
    reg [3:0] min_units = 4'd2;
    reg [3:0] sec_tens  = 4'd3;
    reg [3:0] sec_units = 4'd4;

    wire [3:0] an;
    wire [6:0] seg;
    wire dp;

    display_scanner dut (
        .clk(clk),
        .reset(reset),
        .scan_tick(scan_tick),
        .min_tens(min_tens),
        .min_units(min_units),
        .sec_tens(sec_tens),
        .sec_units(sec_units),
        .an(an),
        .seg(seg),
        .dp(dp)
    );

    always #5 clk = ~clk;

    task advance_scan;
        begin
            @(negedge clk);
            scan_tick = 1;

            @(negedge clk);
            scan_tick = 0;

            #1;
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        reset = 0;

        // Display should cycle through 4, 3, 2, 1
        // from rightmost digit to leftmost digit.
        advance_scan;
        advance_scan;
        advance_scan;
        advance_scan;

        // Verify that the scan returns to digit 0
        if (an !== 4'b1110 || seg !== 7'b0011001)
            $fatal(1, "FAIL: Rightmost digit should show 4");

        $display("PASS: Scanner completed one full cycle");

        if (dp !== 1'b1)
            $fatal(1, "FAIL: Decimal point should be OFF");

        $display("PASS: Decimal point OFF");

        $finish;
    end

    initial begin
        $monitor(
            "Time=%0t an=%b seg=%b dp=%b",
            $time, an, seg, dp
        );
    end

endmodule
