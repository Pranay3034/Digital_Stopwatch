`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 03:00:55
// Design Name: 
// Module Name: digital_stopwatch_top
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




module digital_stopwatch_top #(
    parameter integer CLK_HZ  = 100_000_000,
    parameter integer SCAN_HZ = 4_000
)(
    input  wire clk,
    input  wire btnC,
    input  wire btnU,
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0] an
);


    wire second_tick;
    wire scan_tick;

    wire [3:0] min_tens;
    wire [3:0] min_units;
    wire [3:0] sec_tens;
    wire [3:0] sec_units;

    reg running = 1'b0;

    // Synchronize the start/pause button
    reg btnU_sync1 = 1'b0;
    reg btnU_sync2 = 1'b0;
    reg btnU_prev  = 1'b0;

    wire start_pause_pulse;

    assign start_pause_pulse =
        btnU_sync2 & ~btnU_prev;

    // Button synchronization and start/pause toggle
    always @(posedge clk) begin
        btnU_sync1 <= btnU;
        btnU_sync2 <= btnU_sync1;
        btnU_prev  <= btnU_sync2;

        if (btnC)
            running <= 1'b0;
        else if (start_pause_pulse)
            running <= ~running;
    end

    
    timing_generator #(
        .CLK_HZ(CLK_HZ),
        .SCAN_HZ(SCAN_HZ)
    ) timing_inst (
        .clk(clk),
        .reset(btnC),
        .second_tick(second_tick),
        .scan_tick(scan_tick)
    );


    bcd_counter counter_inst (
        .clk(clk),
        .reset(btnC),
        .second_tick(second_tick),
        .running(running),
        .min_tens(min_tens),
        .min_units(min_units),
        .sec_tens(sec_tens),
        .sec_units(sec_units)
    );

    display_scanner scanner_inst (
        .clk(clk),
        .reset(btnC),
        .scan_tick(scan_tick),
        .min_tens(min_tens),
        .min_units(min_units),
        .sec_tens(sec_tens),
        .sec_units(sec_units),
        .an(an),
        .seg(seg),
        .dp(dp)
    );

endmodule
