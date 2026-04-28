`timescale 1ns/1ps

module tb_fsm;

    logic clk;
    logic reset;
    logic key_valid;
    logic [3:0] key_value;

    logic load_num1;
    logic load_num2;
    logic do_sum;
    logic clear;

    // Instancia de la FSM
    fsm_control uut (
        .clk(clk),
        .reset(reset),
        .key_valid(key_valid),
        .key_value(key_value),
        .load_num1(load_num1),
        .load_num2(load_num2),
        .do_sum(do_sum),
        .clear(clear)
    );

    // Clock 10ns (100 MHz para sim)
    always #5 clk = ~clk;

    // Task para simular tecla
    task press_key(input [3:0] key);
    begin
        key_value = key;
        key_valid = 1;
        #10;
        key_valid = 0;
        #20;
    end
    endtask

    initial begin
        $dumpfile("tb_fsm.vcd");
        $dumpvars(0, tb_fsm);

        clk = 0;
        reset = 1;
        key_valid = 0;
        key_value = 0;

        // Reset
        #20;
        reset = 0;

        // =========================
        // INGRESO NUM1
        // =========================
        press_key(4'd1);
        press_key(4'd2);
        press_key(4'd3);

        // Confirmar (# = A)
        press_key(4'hA);

        // =========================
        // INGRESO NUM2
        // =========================
        press_key(4'd4);
        press_key(4'd5);

        // Confirmar (#)
        press_key(4'hA);

        // Esperar cálculo
        #50;

        // Nueva entrada → volver a IDLE
        press_key(4'd7);

        #100;

        $finish;
    end

endmodule