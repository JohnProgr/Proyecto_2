module display_mux4 (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] d3,
    input  logic [3:0] d2,
    input  logic [3:0] d1,
    input  logic [3:0] d0,
    output logic [6:0] seven,
    output logic [3:0] anodo
);

    logic [15:0] refresh_count;
    logic [1:0]  sel;
    logic [3:0]  digit;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            refresh_count <= 16'd0;
        else
            refresh_count <= refresh_count + 16'd1;
    end

    assign sel = refresh_count[15:14];

    always_comb begin
        digit = 4'd0;
        anodo = 4'b1111;

       case (sel)
    2'b00: begin
        digit = d3;
        anodo = 4'b1110;
    end

    2'b01: begin
        digit = d2;
        anodo = 4'b1101;
    end

    2'b10: begin
        digit = d1;
        anodo = 4'b1011;
    end

    2'b11: begin
        digit = d0;
        anodo = 4'b0111;
    end

    default: begin
        digit = 4'd0;
        anodo = 4'b1111;
    end
endcase
    end

    display_hex_decoder decoder_inst (
        .hex(digit),
        .seg(seven)
    );

endmodule