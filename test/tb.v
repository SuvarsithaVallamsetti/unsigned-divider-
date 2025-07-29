`timescale 1ns/1ps

module tb_restoring_divider;

    reg [7:0] in;
    wire [7:0] out;

    // Instantiate the User Module Under Test (UUT)
    tt_um_restoring_divider uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("Time | Dividend | Divisor | Quotient | Remainder");
        $display("------------------------------------------------");

        // Test Case 1: 10 / 3
        in = {4'd10, 4'd3};
        #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, in[7:4], in[3:0], out[7:4], out[3:0]);

        // Test Case 2: 15 / 5
        in = {4'd15, 4'd5};
        #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, in[7:4], in[3:0], out[7:4], out[3:0]);

        // Test Case 3: 9 / 2
        in = {4'd9, 4'd2};
        #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, in[7:4], in[3:0], out[7:4], out[3:0]);

        // Test Case 4: 7 / 3
        in = {4'd7, 4'd3};
        #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, in[7:4], in[3:0], out[7:4], out[3:0]);

        // Test Case 5: 8 / 4
        in = {4'd8, 4'd4};
        #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, in[7:4], in[3:0], out[7:4], out[3:0]);

        $finish;
    end

endmodule
