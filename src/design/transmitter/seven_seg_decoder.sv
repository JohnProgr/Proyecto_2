module seven_seg_decoder (
    input  [3:0] data_in,
    output reg [7:0] display
);

always @(*) begin
    case (data_in)
        4'h0: display = 8'b11111100;
        4'h1: display = 8'b01100000;
        4'h2: display = 8'b11011010;
        4'h3: display = 8'b11110010;
        4'h4: display = 8'b01100110;
        4'h5: display = 8'b10110110;
        4'h6: display = 8'b10111110;
        4'h7: display = 8'b11100000;
        4'h8: display = 8'b11111110;
        4'h9: display = 8'b11110110;
        4'hA: display = 8'b11101110;
        4'hB: display = 8'b00111110;
        4'hC: display = 8'b10011100;
        4'hD: display = 8'b01111010;
        4'hE: display = 8'b10011110;
        4'hF: display = 8'b10001110;
        default: display = 8'b00000000;
    endcase
end

endmodule

