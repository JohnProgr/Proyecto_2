module bin_to_bcd4 (
    input  logic [13:0] bin,

    output logic [3:0] thousands,
    output logic [3:0] hundreds,
    output logic [3:0] tens,
    output logic [3:0] ones
);

    integer i;
    logic [29:0] shift;

    always_comb begin
        shift = 30'd0;
        shift[13:0] = bin;

        for (i = 0; i < 14; i = i + 1) begin
            if (shift[17:14] >= 5)
                shift[17:14] = shift[17:14] + 3;

            if (shift[21:18] >= 5)
                shift[21:18] = shift[21:18] + 3;

            if (shift[25:22] >= 5)
                shift[25:22] = shift[25:22] + 3;

            if (shift[29:26] >= 5)
                shift[29:26] = shift[29:26] + 3;

            shift = shift << 1;
        end

        ones      = shift[17:14];
        tens      = shift[21:18];
        hundreds  = shift[25:22];
        thousands = shift[29:26];
    end

endmodule