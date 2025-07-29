module tt_um_unsigned_divider (
    input  [7:0] ui_in,      // ui_in = dividend
    output [7:0] uo_out,     // uo_out = quotient
    input  [7:0] uio_in,     // uio_in = divisor
    output [7:0] uio_out,    // uio_out = remainder
    output [7:0] uio_oe,     // uio_oe = output enable (all 1s)
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

    reg [15:0] A;  // Holds intermediate subtraction results
    integer i;

    always @(*) begin
        quotient = 0;
        A = 0;

        if (divisor == 0) begin
            quotient  = 8'hFF; // Divide-by-zero indication
            remainder = 8'hFF;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                A = {A[14:0], dividend[7 - i]};  // Shift left and bring in MSB of dividend

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
