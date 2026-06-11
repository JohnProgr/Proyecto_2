module system_top (
    input  logic clk,
    input  logic rst_n,

    output logic [3:0] filas,
    input  logic [3:0] columnas,

    output logic [6:0] seven,
    output logic [3:0] anodo
);

    logic [3:0] key_value;
    logic       key_valid;

    logic [3:0] a3, a2, a1, a0;
    logic [3:0] b3, b2, b1, b0;

    logic [3:0] r3, r2, r1, r0;

    logic entering_B;
    logic show_result;

    logic [3:0] d3, d2, d1, d0;

    logic c0, c1, c2, c3;

    keypad_reader keypad_inst (
        .clk(clk),
        .rst_n(rst_n),
        .filas(filas),
        .columnas(columnas),
        .key_value(key_value),
        .key_valid(key_valid)
    );

    // SUMA BCD
    always_comb begin
        c0 = 0; c1 = 0; c2 = 0; c3 = 0;

        case (a0 + b0)
            5'd0:  begin r0 = 0; c0 = 0; end
            5'd1:  begin r0 = 1; c0 = 0; end
            5'd2:  begin r0 = 2; c0 = 0; end
            5'd3:  begin r0 = 3; c0 = 0; end
            5'd4:  begin r0 = 4; c0 = 0; end
            5'd5:  begin r0 = 5; c0 = 0; end
            5'd6:  begin r0 = 6; c0 = 0; end
            5'd7:  begin r0 = 7; c0 = 0; end
            5'd8:  begin r0 = 8; c0 = 0; end
            5'd9:  begin r0 = 9; c0 = 0; end
            5'd10: begin r0 = 0; c0 = 1; end
            5'd11: begin r0 = 1; c0 = 1; end
            5'd12: begin r0 = 2; c0 = 1; end
            5'd13: begin r0 = 3; c0 = 1; end
            5'd14: begin r0 = 4; c0 = 1; end
            5'd15: begin r0 = 5; c0 = 1; end
            5'd16: begin r0 = 6; c0 = 1; end
            5'd17: begin r0 = 7; c0 = 1; end
            5'd18: begin r0 = 8; c0 = 1; end
            default: begin r0 = 9; c0 = 1; end
        endcase

        case (a1 + b1 + c0)
            5'd0:  begin r1 = 0; c1 = 0; end
            5'd1:  begin r1 = 1; c1 = 0; end
            5'd2:  begin r1 = 2; c1 = 0; end
            5'd3:  begin r1 = 3; c1 = 0; end
            5'd4:  begin r1 = 4; c1 = 0; end
            5'd5:  begin r1 = 5; c1 = 0; end
            5'd6:  begin r1 = 6; c1 = 0; end
            5'd7:  begin r1 = 7; c1 = 0; end
            5'd8:  begin r1 = 8; c1 = 0; end
            5'd9:  begin r1 = 9; c1 = 0; end
            5'd10: begin r1 = 0; c1 = 1; end
            5'd11: begin r1 = 1; c1 = 1; end
            5'd12: begin r1 = 2; c1 = 1; end
            5'd13: begin r1 = 3; c1 = 1; end
            5'd14: begin r1 = 4; c1 = 1; end
            5'd15: begin r1 = 5; c1 = 1; end
            5'd16: begin r1 = 6; c1 = 1; end
            5'd17: begin r1 = 7; c1 = 1; end
            5'd18: begin r1 = 8; c1 = 1; end
            default: begin r1 = 9; c1 = 1; end
        endcase

        case (a2 + b2 + c1)
            5'd0:  begin r2 = 0; c2 = 0; end
            5'd1:  begin r2 = 1; c2 = 0; end
            5'd2:  begin r2 = 2; c2 = 0; end
            5'd3:  begin r2 = 3; c2 = 0; end
            5'd4:  begin r2 = 4; c2 = 0; end
            5'd5:  begin r2 = 5; c2 = 0; end
            5'd6:  begin r2 = 6; c2 = 0; end
            5'd7:  begin r2 = 7; c2 = 0; end
            5'd8:  begin r2 = 8; c2 = 0; end
            5'd9:  begin r2 = 9; c2 = 0; end
            5'd10: begin r2 = 0; c2 = 1; end
            5'd11: begin r2 = 1; c2 = 1; end
            5'd12: begin r2 = 2; c2 = 1; end
            5'd13: begin r2 = 3; c2 = 1; end
            5'd14: begin r2 = 4; c2 = 1; end
            5'd15: begin r2 = 5; c2 = 1; end
            5'd16: begin r2 = 6; c2 = 1; end
            5'd17: begin r2 = 7; c2 = 1; end
            5'd18: begin r2 = 8; c2 = 1; end
            default: begin r2 = 9; c2 = 1; end
        endcase

        case (a3 + b3 + c2)
            5'd0:  begin r3 = 0; c3 = 0; end
            5'd1:  begin r3 = 1; c3 = 0; end
            5'd2:  begin r3 = 2; c3 = 0; end
            5'd3:  begin r3 = 3; c3 = 0; end
            5'd4:  begin r3 = 4; c3 = 0; end
            5'd5:  begin r3 = 5; c3 = 0; end
            5'd6:  begin r3 = 6; c3 = 0; end
            5'd7:  begin r3 = 7; c3 = 0; end
            5'd8:  begin r3 = 8; c3 = 0; end
            5'd9:  begin r3 = 9; c3 = 0; end
            5'd10: begin r3 = 0; c3 = 1; end
            5'd11: begin r3 = 1; c3 = 1; end
            5'd12: begin r3 = 2; c3 = 1; end
            5'd13: begin r3 = 3; c3 = 1; end
            5'd14: begin r3 = 4; c3 = 1; end
            5'd15: begin r3 = 5; c3 = 1; end
            5'd16: begin r3 = 6; c3 = 1; end
            5'd17: begin r3 = 7; c3 = 1; end
            5'd18: begin r3 = 8; c3 = 1; end
            default: begin r3 = 9; c3 = 1; end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            entering_B  <= 1'b0;
            show_result <= 1'b0;

            a3 <= 0; a2 <= 0; a1 <= 0; a0 <= 0;
            b3 <= 0; b2 <= 0; b1 <= 0; b0 <= 0;
        end else if (key_valid) begin

            case (key_value)

                4'hE: begin // *
                    entering_B  <= 1'b1;
                    show_result <= 1'b0;

                    b3 <= 0;
                    b2 <= 0;
                    b1 <= 0;
                    b0 <= 0;
                end

                4'hF: begin // #
                    show_result <= 1'b1;
                end

                4'd0, 4'd1, 4'd2, 4'd3, 4'd4,
                4'd5, 4'd6, 4'd7, 4'd8, 4'd9: begin
                    show_result <= 1'b0;

                    if (!entering_B) begin
                        a3 <= a2;
                        a2 <= a1;
                        a1 <= a0;
                        a0 <= key_value;
                    end else begin
                        b3 <= b2;
                        b2 <= b1;
                        b1 <= b0;
                        b0 <= key_value;
                    end
                end

                default: begin
                    show_result <= show_result;
                end

            endcase
        end
    end

    always_comb begin
        if (show_result) begin
            d3 = r3;
            d2 = r2;
            d1 = r1;
            d0 = r0;
        end else if (!entering_B) begin
            d3 = a3;
            d2 = a2;
            d1 = a1;
            d0 = a0;
        end else begin
            d3 = b3;
            d2 = b2;
            d1 = b1;
            d0 = b0;
        end
    end

    display_mux4 display_inst (
        .clk(clk),
        .rst_n(rst_n),
        .d3(d3),
        .d2(d2),
        .d1(d1),
        .d0(d0),
        .seven(seven),
        .anodo(anodo)
    );

endmodule