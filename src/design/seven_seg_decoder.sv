module seven_seg_decoder (
    input  [3:0] data_in,
    output reg [7:0] display
);

always @(*) begin
    case (data_in)
        4'd0: display = 8'b11111100;
        4'd1: display = 8'b01100000;
        4'd2: display = 8'b11011010;
        4'd3: display = 8'b11110010;
        4'd4: display = 8'b01100110;
        4'd5: display = 8'b10110110;
        4'd6: display = 8'b10111110;
        4'd7: display = 8'b11100000;
        4'd8: display = 8'b11111110;
        4'd9: display = 8'b11110110;
        default: display = 8'b00000000;
    endcase
end

endmodule 

