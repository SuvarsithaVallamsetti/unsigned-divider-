module tt_um_unsigned_divider (
    input  [7:0] ui_in,    // upper 4 bits: dividend, lower 4 bits: divisor
    output reg [7:0] uo_out,   // Output as reg type
    input  [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input clk,
    input rst_n,
    input ena
);

    reg [3:0] dividend, divisor;
    reg [3:0] quotient, remainder;

    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dividend  <= 4'd0;
            divisor   <= 4'd0;
            quotient  <= 4'd0;
            remainder <= 4'd0;
            uo_out    <= 8'd0;
        end else if (ena) begin
            dividend  <= ui_in[7:4];
            divisor   <= ui_in[3:0];

            if (ui_in[3:0] == 4'd0) begin
                // Divide-by-zero condition
                quotient  <= 4'hF;
                remainder <= 4'hF;
            end else begin
                quotient  <= ui_in[7:4] / ui_in[3:0];
                remainder <= ui_in[7:4] % ui_in[3:0];
            end
        end
    end

    // Pack quotient and remainder to uo_out AFTER quotient/remainder update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else if (ena) begin
            uo_out <= {quotient, remainder};
        end
    end

endmodule
