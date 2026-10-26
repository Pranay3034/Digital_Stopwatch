`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 02:55:35
// Design Name: 
// Module Name: display_scanner
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



module display_scanner (
    input  wire clk,
    input  wire reset,
    input  wire scan_tick,

    input  wire [3:0] min_tens,
    input  wire [3:0] min_units,
    input  wire [3:0] sec_tens,
    input  wire [3:0] sec_units,

    output reg  [3:0] an,
    output wire [6:0] seg,
    output wire dp
);

    reg [1:0] digit_select;
    reg [3:0] current_digit;

    // Basys 3 decimal point stays OFF (active-low)
    assign dp = 1'b1;

    // Advance the active digit on each scan enable
    always @(posedge clk) begin
        if (reset)
            digit_select <= 2'd0;
        else if (scan_tick)
            digit_select <= digit_select + 1'b1;
    end

    // Choose the BCD value for the selected digit
    always @(*) begin
        case (digit_select)
            2'd0: current_digit = sec_units;
            2'd1: current_digit = sec_tens;
            2'd2: current_digit = min_units;
            2'd3: current_digit = min_tens;
            default: current_digit = 4'd0;
        endcase
    end

    // Basys 3 digit enables are active-low
    always @(*) begin
        case (digit_select)
            2'd0: an = 4'b1110;
            2'd1: an = 4'b1101;
            2'd2: an = 4'b1011;
            2'd3: an = 4'b0111;
            default: an = 4'b1111;
        endcase
    end

    seven_segment_decoder decoder (
        .digit(current_digit),
        .seg(seg)
    );

endmodule
