`timescale 1ns/1ps

module tb_keypad_reader;

    logic clk;
    logic rst_n;
    logic [3:0] filas;
    logic [3:0] columnas;
    logic [3:0] key_value;
    logic       key_valid;

    keypad_reader #(
        .SCAN_DELAY(4),
        .RELEASE_DELAY(8)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .filas     (filas),
        .columnas  (columnas),
        .key_value (key_value),
        .key_valid (key_valid)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_keypad_reader.vcd");
        $dumpvars(0, tb_keypad_reader);

        clk = 1'b0;
        rst_n = 1'b0;
        columnas = 4'hF; // ninguna tecla presionada

        #30;
        rst_n = 1'b1;

        // Esperar a que el escaneo llegue a fila 3:
        // fila 3 corresponde a 1 2 3 A
        wait(filas == 4'b0111);
        #10;

        // Simular tecla 2:
        // En fila 3, columna 4'hD corresponde a tecla 2.
        columnas = 4'hD;

        wait(key_valid == 1'b1);
        #1;

        if (key_value == 4'h2)
            $display("OK: tecla 2 detectada");
        else
            $display("ERROR: se esperaba tecla 2, se detecto %h", key_value);

        // Soltar tecla
        columnas = 4'hF;
        #200;

        // Esperar fila 0:
        // fila 0 corresponde a * 0 # D
        wait(filas == 4'b1110);
        #10;

        // Simular tecla #:
        // En fila 0, columna 4'hB corresponde a # = F.
        columnas = 4'hB;

        wait(key_valid == 1'b1);
        #1;

        if (key_value == 4'hF)
            $display("OK: tecla # detectada");
        else
            $display("ERROR: se esperaba tecla #, se detecto %h", key_value);

        columnas = 4'hF;
        #200;

        $display("Simulacion de keypad_reader finalizada.");
        $finish;
    end

endmodule