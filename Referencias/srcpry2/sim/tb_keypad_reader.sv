`timescale 1ns/1ps

module tb_keypad_reader;

    logic clk;
    logic rst_n;

    logic [3:0] filas;
    logic [3:0] columnas;

    logic [3:0] key_value;
    logic       key_valid;

    keypad_reader dut (
        .clk(clk),
        .rst_n(rst_n),
        .filas(filas),
        .columnas(columnas),
        .key_value(key_value),
        .key_valid(key_valid)
    );

    defparam dut.SCAN_DELAY = 10;
    defparam dut.RELEASE_DELAY = 20;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_keypad_reader.vcd");
        $dumpvars(0, tb_keypad_reader);

        columnas = 4'hF;
        rst_n = 0;

        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (20) @(posedge clk);

        test_key(4'h1);
        test_key(4'h2);
        test_key(4'h3);
        test_key(4'h4);
        test_key(4'h5);
        test_key(4'h6);
        test_key(4'h7);
        test_key(4'h8);
        test_key(4'h9);
        test_key(4'h0);
        test_key(4'hA);
        test_key(4'hB);
        test_key(4'hC);
        test_key(4'hD);
        test_key(4'hE); // *
        test_key(4'hF); // #

        $display("FIN tb_keypad_reader");
        $finish;
    end

    task test_key(input logic [3:0] key);
        logic [3:0] target_row;
        logic [3:0] target_col;
        logic detected_ok;
        begin
            key_to_row_col(key, target_row, target_col);
            detected_ok = 1'b0;

            wait (filas == target_row);

            columnas = target_col;

            repeat (80) begin
                @(posedge clk);
                if (key_valid && key_value == key)
                    detected_ok = 1'b1;
            end

            columnas = 4'hF;
            repeat (80) @(posedge clk);

            if (detected_ok)
                $display("OK tecla %h detectada correctamente", key);
            else
                $display("ERROR tecla %h no detectada correctamente. key_value=%h key_valid=%b",
                         key, key_value, key_valid);
        end
    endtask

    task key_to_row_col(
        input  logic [3:0] key,
        output logic [3:0] row,
        output logic [3:0] col
    );
        begin
            row = 4'hF;
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