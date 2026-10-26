`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2026 02:52:33
// Design Name: 
// Module Name: tb_seven_segment_decoder
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

module tb_seven_segment_decoder;

    reg  [3:0] digit;
    wire [6:0] seg;

    seven_segment_decoder dut (
        .digit(digit),
        .seg(seg)
    );

    task check_digit;
        input [3:0] test_digit;
        input [6:0] expected_seg;
        begin
            digit = test_digit;
            #10;

            if (seg !== expected_seg) begin
                $display(
                    "FAIL: digit=%d expected=%b actual=%b",
                    digit, expected_seg, seg
                );
                $fatal(1, "Decoder test failed");
            end
            else begin
                $display(
                    "PASS: digit=%d seg=%b",
                    digit, seg
                );
            end
        end
    endtask

    initial begin
        check_digit(4'd0, 7'b1000000);
        check_digit(4'd1, 7'b1111001);
        check_digit(4'd2, 7'b0100100);
        check_digit(4'd3, 7'b0110000);
        check_digit(4'd4, 7'b0011001);
        check_digit(4'd5, 7'b0010010);
        check_digit(4'd6, 7'b0000010);
        check_digit(4'd7, 7'b1111000);
        check_digit(4'd8, 7'b0000000);
        check_digit(4'd9, 7'b0010000);

        // Test invalid BCD input
        check_digit(4'd10, 7'b1111111);

        $display("ALL DECODER TESTS PASSED");
        $finish;
    end

endmodule

