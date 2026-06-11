`timescale 1ns/1ps

module tb_result_selector;

    logic [5:0] quotient_i;
    logic [3:0] remainder_i;
    logic       select_i;

    logic [5:0] selected_result_o;

    result_selector dut (
        .quotient_i        (quotient_i),
        .remainder_i       (remainder_i),
        .select_i          (select_i),
        .selected_result_o (selected_result_o)
    );

    task automatic check_case(
        input logic [5:0] quotient,
        input logic [3:0] remainder,
        input logic       select,
        input logic [5:0] expected
    );
        begin
            quotient_i  = quotient;
            remainder_i = remainder;
            select_i    = select;
            #10;

            if (selected_result_o !== expected) begin
                $display("ERROR: quotient=%0d remainder=%0d select=%b -> selected=%0d | esperado=%0d",
                    quotient_i, remainder_i, select_i, selected_result_o, expected);
            end else begin
                $display("OK: quotient=%0d remainder=%0d select=%b -> selected=%0d",
                    quotient_i, remainder_i, select_i, selected_result_o);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_result_selector.vcd");
        $dumpvars(0, tb_result_selector);

        // select_i = 0: mostrar cociente
        check_case(6'd5,  4'd0, 1'b0, 6'd5);
        check_case(6'd3,  4'd3, 1'b0, 6'd3);
        check_case(6'd63, 4'd2, 1'b0, 6'd63);

        // select_i = 1: mostrar residuo
        check_case(6'd5,  4'd0, 1'b1, 6'd0);
        check_case(6'd3,  4'd3, 1'b1, 6'd3);
        check_case(6'd10, 4'd14, 1'b1, 6'd14);

        $display("Simulacion de result_selector finalizada.");
        $finish;
    end

endmodule