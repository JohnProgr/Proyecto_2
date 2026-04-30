module bin_to_bcd4 (
    input  logic [13:0] bin,

    output logic [3:0] thousands,
    output logic [3:0] hundreds,
    output logic [3:0] tens,
    output logic [3:0] ones
);

    always_comb begin
        thousands = 4'd0;
        hundreds  = 4'd0;
        tens      = 4'd0;
        ones      = 4'd0;

        case (bin)
            14'd0:  begin tens = 4'd0; ones = 4'd0; end
            14'd1:  begin tens = 4'd0; ones = 4'd1; end
            14'd2:  begin tens = 4'd0; ones = 4'd2; end
            14'd3:  begin tens = 4'd0; ones = 4'd3; end
            14'd4:  begin tens = 4'd0; ones = 4'd4; end
            14'd5:  begin tens = 4'd0; ones = 4'd5; end
            14'd6:  begin tens = 4'd0; ones = 4'd6; end
            14'd7:  begin tens = 4'd0; ones = 4'd7; end
            14'd8:  begin tens = 4'd0; ones = 4'd8; end
            14'd9:  begin tens = 4'd0; ones = 4'd9; end
            14'd10: begin tens = 4'd1; ones = 4'd0; end
            14'd11: begin tens = 4'd1; ones = 4'd1; end
            14'd12: begin tens = 4'd1; ones = 4'd2; end
            14'd13: begin tens = 4'd1; ones = 4'd3; end
            14'd14: begin tens = 4'd1; ones = 4'd4; end
            14'd15: begin tens = 4'd1; ones = 4'd5; end

            default: begin
                thousands = 4'd0;
                hundreds  = 4'd0;
                tens      = 4'd0;
                ones      = 4'd0;
            end
        endcase
    end

endmodule