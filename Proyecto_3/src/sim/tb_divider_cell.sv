`timescale 1ns/1ps

module tb_divider_cell;

    logic r_i;
    logic b_i;
    logic cin_i;
    logic accept_i;

    logic diff_o;
    logic cout_o;
    logic r_next_o;

    divider_cell dut (
        .r_i      (r_i),
        .b_i      (b_i),
        .cin_i    (cin_i),
        .accept_i (accept_i),
        .diff_o   (diff_o),
        .cout_o   (cout_o),
        .r_next_o (r_next_o)
    );

    initial begin
        $dumpfile("tb_divider_cell.vcd");
        $dumpvars(0, tb_divider_cell);

        // Caso 1: r=0, b=0, cin=1
        // 0 + ~0 + 1 = 0 + 1 + 1 = 2 -> diff=0, cout=1
        r_i = 0;
        b_i = 0;
        cin_i = 1;
        accept_i = 1;
        #10;

        // Caso 2: r=1, b=0, cin=1
        // 1 + ~0 + 1 = 1 + 1 + 1 = 3 -> diff=1, cout=1
        r_i = 1;
        b_i = 0;
        cin_i = 1;
        accept_i = 1;
        #10;

        // Caso 3: r=0, b=1, cin=1
        // 0 + ~1 + 1 = 0 + 0 + 1 = 1 -> diff=1, cout=0
        r_i = 0;
        b_i = 1;
        cin_i = 1;
        accept_i = 1;
        #10;

        // Caso 4: r=1, b=1, cin=1
        // 1 + ~1 + 1 = 1 + 0 + 1 = 2 -> diff=0, cout=1
        r_i = 1;
        b_i = 1;
        cin_i = 1;
        accept_i = 1;
        #10;

        // Caso 5: accept_i = 0, debe conservar r_i
        r_i = 1;
        b_i = 1;
        cin_i = 1;
        accept_i = 0;
        #10;

        // Caso 6: accept_i = 0, debe conservar r_i aunque diff cambie
        r_i = 0;
        b_i = 1;
        cin_i = 1;
        accept_i = 0;
        #10;

        $display("Simulacion de divider_cell finalizada.");
        $finish;
    end

endmodule