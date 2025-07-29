module tt_um_unsigned_divider (
    input  [7:0] ui_in,    // ui_in[7:4] = dividend, ui_in[3:0] = divisor
    output [7:0] uo_out,   // uo_out[7:4] = quotient, uo_out[3:0] = remainder
    input  [7:0] uio_in,   // unused
    output [7:0] uio_out,  // unused
    output [7:0] uio_oe,   // unused
    input clk,             // unused
    input rst_n,           // unused
    input ena              // unused
);

    // Unused signals
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire [3:0] dividend = ui_in[7:4];
    wire [3:0] divisor  = ui_in[3:0];

    reg  [3:0] quotient;
    reg  [3:0] remainder;
    reg  [4:0] A;  // One extra bit for restoring
    integer i;

    always @(*) begin
        quotient = 0;
        A = 0;

        if (divisor == 0) begin
            quotient  = 4'b1111; // Handle divide by zero case (optional)
            remainder = 4'b1111;
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                A = {A[3:0], dividend[3 - i]};
                A = A - divisor;

                if (A[4] == 1'b1) begin
                    A = A + divisor;
                    quotient = quotient << 1;
                end else begin
                    quotient = (quotient << 1) | 1'b1;
                end
            end
            remainder = A[3:0];
        end
    end

    assign uo_out = {quotient, remainder};

endmodule
