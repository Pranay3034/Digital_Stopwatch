`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 01:35:13
// Design Name: 
// Module Name: timing_generator
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



module timing_generator #(
    parameter integer CLK_HZ  = 100_000_000,
    parameter integer SCAN_HZ = 4_000
)(
    input  wire clk,
    input  wire reset,

    output reg second_tick,
    output reg scan_tick
);

    reg [26:0] second_count;
    reg [14:0] scan_count;

    always @(posedge clk) begin
        if (reset) begin
            second_count <= 0;
            scan_count   <= 0;
            second_tick  <= 0;
            scan_tick    <= 0;
        end
        else begin
            second_tick <= 0;
            scan_tick   <= 0;

            if (second_count == CLK_HZ - 1) begin
                second_count <= 0;
                second_tick  <= 1;
            end
            else begin
                second_count <= second_count + 1'b1;
            end

            if (scan_count == (CLK_HZ / SCAN_HZ) - 1) begin
                scan_count <= 0;
                scan_tick  <= 1;
            end
            else begin
                scan_count <= scan_count + 1'b1;
            end
        end
    end

endmodule
