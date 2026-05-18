`timescale 1ns/1ps

module tb_fsm_top;

    logic clk;
    logic rst_n;

    logic [3:0] filas;
    logic [3:0] columnas;

    logic [6:0] seven;
    logic [3:0] anodo;

    fsm_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .filas(filas),
        .columnas(columnas),
        .seven(seven),
        .anodo(anodo)
    );

    // Acelerar simulación
    defparam dut.keypad_inst.SCAN_DELAY = 10;
    defparam dut.keypad_inst.RELEASE_DELAY = 20;

    // Clock 27 MHz aproximado
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_fsm_top.vcd");
        $dumpvars(0, tb_fsm_top);

        columnas = 4'hF;
        rst_n = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;

        repeat (20) @(posedge clk);

        // Prueba 1: 1234 + 456 = 1690
        press_key(4'h1);
        press_key(4'h2);
        press_key(4'h3);
        press_key(4'h4);
        press_key(4'hE); // *
        press_key(4'h4);
        press_key(4'h5);
        press_key(4'h6);
        press_key(4'hF); // #

        repeat (50) @(posedge clk);

        if ({dut.d3, dut.d2, dut.d1, dut.d0} == 16'h1690)
            $display("TEST 1 OK: 1234 + 456 = 1690");
        else
            $display("TEST 1 ERROR: resultado = %h%h%h%h",
                     dut.d3, dut.d2, dut.d1, dut.d0);

        // Reset para segunda prueba
        rst_n = 0;
        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (20) @(posedge clk);

        // Prueba 2: 999 + 999 = 1998
        press_key(4'h9);
        press_key(4'h9);
        press_key(4'h9);
        press_key(4'hE); // *
        press_key(4'h9);
        press_key(4'h9);
        press_key(4'h9);
        press_key(4'hF); // #

        repeat (50) @(posedge clk);

        if ({dut.d3, dut.d2, dut.d1, dut.d0} == 16'h1998)
            $display("TEST 2 OK: 999 + 999 = 1998");
        else
            $display("TEST 2 ERROR: resultado = %h%h%h%h",
                     dut.d3, dut.d2, dut.d1, dut.d0);

        $finish;
    end

    task press_key(input logic [3:0] key);
        logic [3:0] target_row;
        logic [3:0] target_col;
        begin
            key_to_row_col(key, target_row, target_col);

            wait (filas == target_row);

            columnas = target_col;
            repeat (40) @(posedge clk);

            columnas = 4'hF;
            repeat (80) @(posedge clk);
        end
    endtask

    task key_to_row_col(
        input  logic [3:0] key,
        output logic [3:0] row,
        output logic [3:0] col
    );
        begin
            row = 4'b1111;
            col = 4'hF;

            case (key)
                4'h1: begin row = 4'b0111; col = 4'hE; end
                4'h2: begin row = 4'b0111; col = 4'hD; end
                4'h3: begin row = 4'b0111; col = 4'hB; end
                4'hA: begin row = 4'b0111; col = 4'h7; end

                4'h4: begin row = 4'b1011; col = 4'hE; end
                4'h5: begin row = 4'b1011; col = 4'hD; end
                4'h6: begin row = 4'b1011; col = 4'hB; end
                4'hB: begin row = 4'b1011; col = 4'h7; end

                4'h7: begin row = 4'b1101; col = 4'hE; end
                4'h8: begin row = 4'b1101; col = 4'hD; end
                4'h9: begin row = 4'b1101; col = 4'hB; end
                4'hC: begin row = 4'b1101; col = 4'h7; end

                4'hE: begin row = 4'b1110; col = 4'hE; end // *
                4'h0: begin row = 4'b1110; col = 4'hD; end
                4'hF: begin row = 4'b1110; col = 4'hB; end // #
                4'hD: begin row = 4'b1110; col = 4'h7; end
            endcase
        end
    endtask

endmodule