module seven_seg_decoder (
    input  [3:0] data_in,
    output reg [7:0] code_out
);

always @(*) begin
    case (data_in)
        4'd0: code_out = 8'b11111100;
        4'd1: code_out = 8'b01100000;
        4'd2: code_out = 8'b11011010;
        4'd3: code_out = 8'b11110010;
        4'd4: code_out = 8'b01100110;
        4'd5: code_out = 8'b10110110;
        4'd6: code_out = 8'b10111110;
        4'd7: code_out = 8'b11100000;
        4'd8: code_out = 8'b11111110;
        4'd9: code_out = 8'b11110110;
        default: code_out = 8'b00000000;
    endcase
end

endmodule 

