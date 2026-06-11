`timescale 1ns/1ps

module tb_divider_comb;

    logic [5:0] dividend_i;
    logic [3:0] divisor_i;

    logic [5:0] quotient_o;
    logic [3:0] remainder_o;
    logic       div_zero_o;

    divider_comb dut (
        .dividend_i  (dividend_i),
        .divisor_i   (divisor_i),
        .quotient_o  (quotient_o),
        .remainder_o (remainder_o),
        .div_zero_o  (div_zero_o)
    );

    task automatic check_case(
        input logic [5:0] dividend,
        input logic [3:0] divisor,
        input logic [5:0] exp_quotient,
        input logic [3:0] exp_remainder,
        input logic       exp_div_zero
    );
        begin
            dividend_i = dividend;
            divisor_i  = divisor;
            #10;

            if (
                quotient_o  !== exp_quotient  ||
                remainder_o !== exp_remainder ||
                div_zero_o  !== exp_div_zero
            ) begin
                $display("ERROR: %0d / %0d -> q=%0d r=%0d div0=%b | esperado q=%0d r=%0d div0=%b",
                    dividend_i, divisor_i,
                    quotient_o, remainder_o, div_zero_o,
                    exp_quotient, exp_remainder, exp_div_zero
                );
            end else begin
                $display("OK: %0d / %0d -> q=%0d r=%0d div0=%b",
                    dividend_i, divisor_i,
                    quotient_o, remainder_o, div_zero_o
                );
            end
        end
    endtask

    initial begin
        $dumpfile("tb_divider_comb.vcd");
        $dumpvars(0, tb_divider_comb);

        check_case(6'd10, 4'd2,  6'd5,  4'd0, 1'b0);
        check_case(6'd15, 4'd4,  6'd3,  4'd3, 1'b0);
        check_case(6'd63, 4'd15, 6'd4,  4'd3, 1'b0);
        check_case(6'd7,  4'd3,  6'd2,  4'd1, 1'b0);
        check_case(6'd8,  4'd1,  6'd8,  4'd0, 1'b0);
        check_case(6'd0,  4'd5,  6'd0,  4'd0, 1'b0);
        check_case(6'd5,  4'd8,  6'd0,  4'd5, 1'b0);

        // División entre cero: salida protegida.
        check_case(6'd12, 4'd0,  6'd0,  4'd0, 1'b1);

        $display("Simulacion de divider_comb finalizada.");
        $finish;
    end

endmodule