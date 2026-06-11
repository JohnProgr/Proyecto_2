`timescale 1ns/1ps

module tb_divider_stage;

    localparam int WIDTH = 4;

    logic [WIDTH-1:0] r_i;
    logic [WIDTH-1:0] b_i;

    logic [WIDTH-1:0] diff_o;
    logic [WIDTH-1:0] r_next_o;
    logic             q_bit_o;
    logic             cout_o;

    divider_stage #(
        .WIDTH(WIDTH)
    ) dut (
        .r_i      (r_i),
        .b_i      (b_i),
        .diff_o   (diff_o),
        .r_next_o (r_next_o),
        .q_bit_o  (q_bit_o),
        .cout_o   (cout_o)
    );

    task automatic check_case(
        input logic [WIDTH-1:0] r,
        input logic [WIDTH-1:0] b,
        input logic [WIDTH-1:0] exp_diff,
        input logic [WIDTH-1:0] exp_r_next,
        input logic             exp_q_bit,
        input logic             exp_cout
    );
        begin
            r_i = r;
            b_i = b;
            #10;

            if (
                diff_o   !== exp_diff   ||
                r_next_o !== exp_r_next ||
                q_bit_o  !== exp_q_bit  ||
                cout_o   !== exp_cout
            ) begin
                $display("ERROR: r=%h b=%h -> diff=%h r_next=%h q_bit=%b cout=%b | esperado diff=%h r_next=%h q_bit=%b cout=%b",
                    r_i, b_i, diff_o, r_next_o, q_bit_o, cout_o,
                    exp_diff, exp_r_next, exp_q_bit, exp_cout
                );
            end else begin
                $display("OK: r=%h b=%h -> diff=%h r_next=%h q_bit=%b cout=%b",
                    r_i, b_i, diff_o, r_next_o, q_bit_o, cout_o
                );
            end
        end
    endtask

    initial begin
        $dumpfile("tb_divider_stage.vcd");
        $dumpvars(0, tb_divider_stage);

        // Resta válida: 7 - 3 = 4
        // Se acepta diff_o y q_bit_o = 1.
        check_case(4'h7, 4'h3, 4'h4, 4'h4, 1'b1, 1'b1);

        // Resta válida: 5 - 2 = 3
        check_case(4'h5, 4'h2, 4'h3, 4'h3, 1'b1, 1'b1);

        // Resta inválida: 3 - 5 = -2 = E en 4 bits.
        // Como no alcanza, r_next_o conserva r_i = 3 y q_bit_o = 0.
        check_case(4'h3, 4'h5, 4'hE, 4'h3, 1'b0, 1'b0);

        // Resta válida exacta: F - F = 0
        check_case(4'hF, 4'hF, 4'h0, 4'h0, 1'b1, 1'b1);

        // Resta válida: 8 - 1 = 7
        check_case(4'h8, 4'h1, 4'h7, 4'h7, 1'b1, 1'b1);

        // Resta inválida: 0 - 1 = -1 = F en 4 bits.
        // Se conserva r_i = 0.
        check_case(4'h0, 4'h1, 4'hF, 4'h0, 1'b0, 1'b0);

        $display("Simulacion de divider_stage finalizada.");
        $finish;
    end

endmodule