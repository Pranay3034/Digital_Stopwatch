`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 01:40:44
// Design Name: 
// Module Name: bcd_counter
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



module bcd_counter (
    input  wire clk,
    input  wire reset,
    input  wire second_tick,
    input  wire running,

    output reg [3:0] min_tens,
    output reg [3:0] min_units,
    output reg [3:0] sec_tens,
    output reg [3:0] sec_units
);

    always @(posedge clk) begin
        if (reset) begin
            min_tens  <= 4'd0;
            min_units <= 4'd0;
            sec_tens  <= 4'd0;
            sec_units <= 4'd0;
        end
        else if (running && second_tick) begin

            // Seconds units: 0 to 9
            if (sec_units == 4'd9) begin
                sec_units <= 4'd0;

                // Seconds tens: 0 to 5
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;

                    // Minutes units: 0 to 9
                    if (min_units == 4'd9) begin
                        min_units <= 4'd0;

                        // Minutes tens: 0 to 9
                        if (min_tens == 4'd9)
                            min_tens <= 4'd0;
                        else
                            min_tens <= min_tens + 1'b1;
                    end
                    else begin
                        min_units <= min_units + 1'b1;
                    end
                end
                else begin
                    sec_tens <= sec_tens + 1'b1;
                end
            end
            else begin
                sec_units <= sec_units + 1'b1;
            end
        end
    end

endmodule
