`timescale 1ns / 1ps

module tb;

    reg  [7:0] ui_in;
    reg  [7:0] uio_in = 8'b0;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg ena = 1'b1;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

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

    always #5 clk = ~clk;  // 100MHz Clock

    initial begin
        #10 rst_n = 1;  // De-assert reset after 10ns
    end

endmodule
