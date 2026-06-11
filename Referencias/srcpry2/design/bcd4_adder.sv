module bcd4_adder (
    input  logic [3:0] a3, a2, a1, a0,
    input  logic [3:0] b3, b2, b1, b0,
    output logic [3:0] r3, r2, r1, r0,
    output logic       overflow
);

    logic c0, c1, c2, c3;

    function automatic logic [4:0] add_bcd_digit;
        input logic [4:0] value;
        begin
            case (value)
                5'd0:  add_bcd_digit = {1'b0, 4'd0};
                5'd1:  add_bcd_digit = {1'b0, 4'd1};
                5'd2:  add_bcd_digit = {1'b0, 4'd2};
                5'd3:  add_bcd_digit = {1'b0, 4'd3};
                5'd4:  add_bcd_digit = {1'b0, 4'd4};
                5'd5:  add_bcd_digit = {1'b0, 4'd5};
                5'd6:  add_bcd_digit = {1'b0, 4'd6};
                5'd7:  add_bcd_digit = {1'b0, 4'd7};
                5'd8:  add_bcd_digit = {1'b0, 4'd8};
                5'd9:  add_bcd_digit = {1'b0, 4'd9};
                5'd10: add_bcd_digit = {1'b1, 4'd0};
                5'd11: add_bcd_digit = {1'b1, 4'd1};
                5'd12: add_bcd_digit = {1'b1, 4'd2};
                5'd13: add_bcd_digit = {1'b1, 4'd3};
                5'd14: add_bcd_digit = {1'b1, 4'd4};
                5'd15: add_bcd_digit = {1'b1, 4'd5};
                5'd16: add_bcd_digit = {1'b1, 4'd6};
                5'd17: add_bcd_digit = {1'b1, 4'd7};
                5'd18: add_bcd_digit = {1'b1, 4'd8};
                default: add_bcd_digit = {1'b1, 4'd9};
            endcase
        end
    endfunction

    always_comb begin
        {c0, r0} = add_bcd_digit({1'b0, a0} + {1'b0, b0});
        {c1, r1} = add_bcd_digit({1'b0, a1} + {1'b0, b1} + {4'd0, c0});
        {c2, r2} = add_bcd_digit({1'b0, a2} + {1'b0, b2} + {4'd0, c1});
        {c3, r3} = add_bcd_digit({1'b0, a3} + {1'b0, b3} + {4'd0, c2});

        overflow = c3;
    end

endmodule