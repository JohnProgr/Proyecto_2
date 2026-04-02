module error_generator_8bit (
    input  [7:0] code_in,     // sale del codificador Hamming
    input  [2:0] error_pos,   // selecciona cuál bit cambiar
    input        error_enable,// 1 = meter error, 0 = dejar igual
    output [7:0] code_out     // salida final con o sin error
);

    reg [7:0] mask;

    always @(*) begin
        mask = 8'b00000000;

        if (error_enable) begin
            case (error_pos)
                3'b000: mask = 8'b00000001; // cambia bit 0
                3'b001: mask = 8'b00000010; // cambia bit 1
                3'b010: mask = 8'b00000100; // cambia bit 2
                3'b011: mask = 8'b00001000; // cambia bit 3
                3'b100: mask = 8'b00010000; // cambia bit 4
                3'b101: mask = 8'b00100000; // cambia bit 5
                3'b110: mask = 8'b01000000; // cambia bit 6
                3'b111: mask = 8'b10000000; // cambia bit 7
                default: mask = 8'b00000000;
            endcase
        end
    end

    assign code_out = code_in ^ mask;

endmodule