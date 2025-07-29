module tt_um_unsigned_divider (
    input  [7:0] ui_in,      // dividend
    input  [7:0] uio_in,     // divisor
    output [7:0] uo_out,     // quotient
    output [7:0] uio_out,    // remainder
    output [7:0] uio_oe,     // output enable
    input clk,               // unused
    input rst_n,             // unused
    input ena                // unused
);

    // Enable all bits of uio as output
    assign uio_oe = 8'hFF;

    wire [7:0] dividend = ui_in;
    wire [7:0] divisor  = uio_in;

    reg [7:0] quotient;
    reg [7:0] remainder;

    reg [15:0] A;  // holds intermediate subtraction results
    integer i;

    always @(*) begin
        quotient = 0;
        A = 0;

        if (divisor == 0) begin
            quotient  = 8'hFF; // Divide-by-zero signal
            remainder = 8'hFF;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                A = {A[14:0], dividend[7 - i]};  // Shift left and insert next dividend bit

                if (A >= divisor) begin
                    A = A - divisor;
                    quotient = (quotient << 1) | 1;
                end else begin
                    quotient = quotient << 1;
                end
            end
            remainder = A[7:0];
        end
    end

    assign uo_out  = quotient;
    assign uio_out = remainder;

endmodule
