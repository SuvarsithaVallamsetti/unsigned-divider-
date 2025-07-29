module tt_um_restoring_divider (
    input  [7:0] in,   // in[7:4]=dividend (4-bit), in[3:0]=divisor (4-bit)
    output [7:0] out   // out[7:4]=quotient (4-bit), out[3:0]=remainder (4-bit)
);

    wire [3:0] dividend = in[7:4];
    wire [3:0] divisor = in[3:0];

    reg [3:0] quotient;
    reg [3:0] remainder;

    integer i;
    reg [4:0] A;
    reg [3:0] M;

    always @(*) begin
        A = 0;
        M = divisor;
        quotient = 0;

        for (i = 0; i < 4; i = i + 1) begin
            A = {A[3:0], dividend[3 - i]};
            A = A - M;

            if (A[4] == 1'b1) begin
                A = A + M;
                quotient = quotient << 1;
            end else begin
                quotient = (quotient << 1) | 1'b1;
            end
        end
        remainder = A[3:0];
    end

    assign out = {quotient, remainder};

endmodule
