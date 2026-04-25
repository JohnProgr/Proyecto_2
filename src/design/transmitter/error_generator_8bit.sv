module error_generator_8bit (
    input  [7:0] code_in,
    input  [2:0] error_pos1,
    input  [2:0] error_pos2,
    input  [1:0] num_errors,   // 00: ninguno, 01: uno, 10: dos
    output [7:0] code_out
);

    reg [7:0] mask;

    always @(*) begin
        mask = 8'b00000000;

        case (num_errors)
            2'b00: begin
                mask = 8'b00000000;
            end

            2'b01: begin
                mask = (8'b00000001 << error_pos1);
            end

            2'b10: begin
                mask = (8'b00000001 << error_pos1) |
                       (8'b00000001 << error_pos2);
            end

            default: begin
                mask = 8'b00000000;
            end
        endcase
    end

    assign code_out = code_in ^ mask;

endmodule