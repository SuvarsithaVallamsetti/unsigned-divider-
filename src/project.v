module tt_um_unsigned_divider (
    input  [7:0] ui_in,    // dividend
    input  [7:0] uio_in,   // divisor

    output [7:0] uo_out,   // quotient
    output [7:0] uio_out,  // remainder
    output [7:0] uio_oe,   // output enable

    input clk,             // unused
    input rst_n,           // unused
    input ena              // unused
);

    // Enable all bits of uio as output
    assign uio_oe = 8'hFF;

    // Simple unsigned division with divide-by-zero protection
    assign uo_out  = (uio_in != 0) ? (ui_in / uio_in) : 8'hFF;
    assign uio_out = (uio_in != 0) ? (ui_in % uio_in) : 8'hFF;

endmodule
