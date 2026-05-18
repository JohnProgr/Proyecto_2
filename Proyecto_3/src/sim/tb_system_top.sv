`timescale 1ns/1ps

module tb_system_top;

    logic clk;
    logic rst_n;

    logic [3:0] filas;
    logic [3:0] columnas;

    logic select_i;

    logic [6:0] seven;
    logic [3:0] anodo;

    logic done_o;
    logic div_zero_o;

    // Señales para simular una tecla física presionada.
    logic       key_is_pressed;
    logic [3:0] pressed_fila;
    logic [3:0] pressed_col;

    system_top #(
        .KEYPAD_SCAN_DELAY(50),
        .KEYPAD_RELEASE_DELAY(30)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .filas      (filas),
        .columnas   (columnas),
        .select_i   (select_i),
        .seven      (seven),
        .anodo      (anodo),
        .done_o     (done_o),
        .div_zero_o (div_zero_o)
    );

    always #5 clk = ~clk;

    // Simulación realista del teclado:
    // La columna solo baja cuando la fila activa corresponde a la tecla presionada.
    always_comb begin
        if (key_is_pressed && filas == pressed_fila) begin
            columnas = pressed_col;
        end else begin
            columnas = 4'hF;
        end
    end

    task automatic press_key(input logic [3:0] key);
        begin
            pressed_fila = 4'b1111;
            pressed_col  = 4'hF;

            case (key)
                // Fila 3: 1 2 3 A
                4'h1: begin pressed_fila = 4'b0111; pressed_col = 4'hE; end
                4'h2: begin pressed_fila = 4'b0111; pressed_col = 4'hD; end
                4'h3: begin pressed_fila = 4'b0111; pressed_col = 4'hB; end
                4'hA: begin pressed_fila = 4'b0111; pressed_col = 4'h7; end

                // Fila 2: 4 5 6 B
                4'h4: begin pressed_fila = 4'b1011; pressed_col = 4'hE; end
                4'h5: begin pressed_fila = 4'b1011; pressed_col = 4'hD; end
                4'h6: begin pressed_fila = 4'b1011; pressed_col = 4'hB; end
                4'hB: begin pressed_fila = 4'b1011; pressed_col = 4'h7; end

                // Fila 1: 7 8 9 C
                4'h7: begin pressed_fila = 4'b1101; pressed_col = 4'hE; end
                4'h8: begin pressed_fila = 4'b1101; pressed_col = 4'hD; end
                4'h9: begin pressed_fila = 4'b1101; pressed_col = 4'hB; end
                4'hC: begin pressed_fila = 4'b1101; pressed_col = 4'h7; end

                // Fila 0: * 0 # D
                4'hE: begin pressed_fila = 4'b1110; pressed_col = 4'hE; end // *
                4'h0: begin pressed_fila = 4'b1110; pressed_col = 4'hD; end
                4'hF: begin pressed_fila = 4'b1110; pressed_col = 4'hB; end // #
                4'hD: begin pressed_fila = 4'b1110; pressed_col = 4'h7; end

                default: begin pressed_fila = 4'b1111; pressed_col = 4'hF; end
            endcase

            $display("Presionando tecla %h", key);

            key_is_pressed = 1'b1;

            // Espera hasta que keypad_reader detecte la tecla.
            wait(dut.key_valid == 1'b1);
            #1;

            $display("Detectada tecla %h", dut.key_value);

            if (dut.key_value !== key) begin
                $display("ERROR: se esperaba tecla %h pero se detecto %h", key, dut.key_value);
            end

            // Mantener la tecla un poco más para que el escaneo sea estable.
            repeat (10) @(negedge clk);
            key_is_pressed = 1'b0;

            // Esperar a que se libere el bloqueo interno del keypad_reader.
            repeat (80) @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("tb_system_top.vcd");
        $dumpvars(0, tb_system_top);

        clk            = 1'b0;
        rst_n          = 1'b0;
        select_i       = 1'b0; // 0 = mostrar cociente
        key_is_pressed = 1'b0;
        pressed_fila   = 4'b1111;
        pressed_col    = 4'hF;

        repeat (5) @(negedge clk);
        rst_n = 1'b1;

        $display("Inicio de simulacion system_top con teclado");

        // Operación: 63 / 15
        // Secuencia: 6, 3, #, 1, 5, #
        press_key(4'd6);
        press_key(4'd3);
        press_key(4'hF); // #
        press_key(4'd1);
        press_key(4'd5);
        press_key(4'hF); // #

        $display("Teclas ingresadas, esperando resultado estable");

        // Esperar unos ciclos después de la última tecla.
        // El done_o puede ser un pulso corto y ya haber pasado.
        repeat (20) @(negedge clk);

        if (dut.quotient !== 6'd4 || dut.remainder !== 4'd3 || div_zero_o !== 1'b0) begin
            $display("ERROR: 63 / 15 -> q=%0d r=%0d div0=%b | esperado q=4 r=3 div0=0",
                dut.quotient, dut.remainder, div_zero_o);
        end else begin
            $display("OK: 63 / 15 -> q=%0d r=%0d div0=%b",
                dut.quotient, dut.remainder, div_zero_o);
        end

        // Cambiar a mostrar residuo.
        select_i = 1'b1;
        #2000;

        $display("Simulacion de system_top con teclado finalizada.");
        $finish;
    end

endmodule