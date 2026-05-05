`timescale 1ns/1ps

module tb_display_mux4;

    logic clk;
    logic rst_n;

    logic [3:0] d3, d2, d1, d0;

    logic [6:0] seven;
    logic [3:0] anodo;

    display_mux4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .d3(d3),
        .d2(d2),
        .d1(d1),
        .d0(d0),
        .seven(seven),
        .anodo(anodo)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_display_mux4.vcd");
        $dumpvars(0, tb_display_mux4);

        rst_n = 0;
        d3 = 4'd1;
        d2 = 4'd2;
        d1 = 4'd3;
        d0 = 4'd4;

        repeat (10) @(posedge clk);
        rst_n = 1;

        // Dejar correr el multiplexado
        repeat (200) @(posedge clk);

        // Cambiar valores
        d3 = 4'd9;
        d2 = 4'd8;
        d1 = 4'd7;
        d0 = 4'd6;

        repeat (200) @(posedge clk);

        $display("FIN tb_display_mux4");
        $finish;
    end

endmodule