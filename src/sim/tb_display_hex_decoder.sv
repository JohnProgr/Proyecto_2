`timescale 1ns/1ps

module tb_display_hex_decoder;

    logic [3:0] hex;
    logic [6:0] seg;

    display_hex_decoder dut (
        .hex(hex),
        .seg(seg)
    );

    task automatic check_case(
        input logic [3:0] value,
        input logic [6:0] expected
    );
        begin
            hex = value;
            #10;

            if (seg !== expected) begin
                $display("ERROR: hex=%h -> seg=%b | esperado=%b", hex, seg, expected);
            end else begin
                $display("OK: hex=%h -> seg=%b", hex, seg);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_display_hex_decoder.vcd");
        $dumpvars(0, tb_display_hex_decoder);

        check_case(4'h0, 7'b1111110);
        check_case(4'h1, 7'b0110000);
        check_case(4'h2, 7'b1101101);
        check_case(4'h3, 7'b1111001);
        check_case(4'h4, 7'b0110011);
        check_case(4'h5, 7'b1011011);
        check_case(4'h6, 7'b1011111);
        check_case(4'h7, 7'b1110000);
        check_case(4'h8, 7'b1111111);
        check_case(4'h9, 7'b1111011);

        $display("Simulacion de display_hex_decoder finalizada.");
        $finish;
    end

endmodule