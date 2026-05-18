`timescale 1ns/1ps

module tb_display_mux4;

    logic clk;
    logic rst_n;

    logic [3:0] d3;
    logic [3:0] d2;
    logic [3:0] d1;
    logic [3:0] d0;

    logic [6:0] seven;
    logic [3:0] anodo;

    display_mux4 dut (
        .clk   (clk),
        .rst_n (rst_n),
        .d3    (d3),
        .d2    (d2),
        .d1    (d1),
        .d0    (d0),
        .seven (seven),
        .anodo (anodo)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_display_mux4.vcd");
        $dumpvars(0, tb_display_mux4);

        clk = 1'b0;
        rst_n = 1'b0;

        d3 = 4'd1;
        d2 = 4'd2;
        d1 = 4'd3;
        d0 = 4'd4;

        #20;
        rst_n = 1'b1;

        // Espera suficiente para observar cambios en refresh_count[15:14].
        #700000;

        $display("Simulacion de display_mux4 finalizada.");
        $finish;
    end

endmodule