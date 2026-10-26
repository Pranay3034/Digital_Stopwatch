`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 01:36:24
// Design Name: 
// Module Name: tb_timing_generator
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

module tb_timing_generator;

    reg clk = 0;
    reg reset = 1;

    wire second_tick;
    wire scan_tick;

    timing_generator #(
        .CLK_HZ(100),
        .SCAN_HZ(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .second_tick(second_tick),
        .scan_tick(scan_tick)
    );

    always #5 clk = ~clk;

    initial begin
        repeat (3) @(posedge clk);
        @(negedge clk);
        reset = 0;

        repeat (220) @(posedge clk);
        @(negedge clk);
        $finish;
    end

endmodule
