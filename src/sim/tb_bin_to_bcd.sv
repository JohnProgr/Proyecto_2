`timescale 1ns/1ps

module tb_bin_to_bcd;

    logic [5:0] bin_i;
    logic [3:0] tens_o;
    logic [3:0] ones_o;

    bin_to_bcd dut (
        .bin_i  (bin_i),
        .tens_o (tens_o),
        .ones_o (ones_o)
    );

    task automatic check_case(
        input logic [5:0] value,
        input logic [3:0] exp_tens,
        input logic [3:0] exp_ones
    );
        begin
            bin_i = value;
            #10;

            if (tens_o !== exp_tens || ones_o !== exp_ones) begin
                $display("ERROR: bin=%0d -> tens=%0d ones=%0d | esperado tens=%0d ones=%0d",
                    bin_i, tens_o, ones_o, exp_tens, exp_ones
                );
            end else begin
                $display("OK: bin=%0d -> tens=%0d ones=%0d",
                    bin_i, tens_o, ones_o
                );
            end
        end
    endtask

    initial begin
        $dumpfile("tb_bin_to_bcd.vcd");
        $dumpvars(0, tb_bin_to_bcd);

        check_case(6'd0,  4'd0, 4'd0);
        check_case(6'd1,  4'd0, 4'd1);
        check_case(6'd9,  4'd0, 4'd9);
        check_case(6'd10, 4'd1, 4'd0);
        check_case(6'd14, 4'd1, 4'd4);
        check_case(6'd15, 4'd1, 4'd5);
        check_case(6'd63, 4'd6, 4'd3);

        $display("Simulacion de bin_to_bcd finalizada.");
        $finish;
    end

endmodule