`timescale 1ns / 1ps

module tb;

    // Inputs
    reg  [7:0] ui_in;
    reg  [7:0] uio_in = 8'b0;
    reg clk    = 1'b0;
    reg rst_n  = 1'b1;
    reg ena    = 1'b1;

    // Outputs
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate your divider module
    tt_um_unsigned_divider uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation (Optional, since your design is combinational)
    always #5 clk = ~clk;

    initial begin
        $display("Time | Dividend | Divisor | Quotient | Remainder");
        $display("------------------------------------------------");

        // Test Case 1: 10 / 3
        ui_in = {4'd10, 4'd3}; #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, ui_in[7:4], ui_in[3:0], uo_out[7:4], uo_out[3:0]);

        // Test Case 2: 15 / 5
        ui_in = {4'd15, 4'd5}; #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, ui_in[7:4], ui_in[3:0], uo_out[7:4], uo_out[3:0]);

        // Test Case 3: 9 / 2
        ui_in = {4'd9, 4'd2}; #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, ui_in[7:4], ui_in[3:0], uo_out[7:4], uo_out[3:0]);

        // Test Case 4: 7 / 3
        ui_in = {4'd7, 4'd3}; #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, ui_in[7:4], ui_in[3:0], uo_out[7:4], uo_out[3:0]);

        // Test Case 5: 8 / 4
        ui_in = {4'd8, 4'd4}; #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, ui_in[7:4], ui_in[3:0], uo_out[7:4], uo_out[3:0]);

        // Test Case 6: Divide by Zero Test (Dividend=5, Divisor=0)
        ui_in = {4'd5, 4'd0}; #10;
        $display("%4t |    %2d    |   %2d    |    %2d    |     %2d", $time, ui_in[7:4], ui_in[3:0], uo_out[7:4], uo_out[3:0]);

        $finish;
    end

endmodule
