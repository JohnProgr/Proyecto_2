module keyboard_scanner #(
    parameter CLK_HZ = 27_000_000
)(
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] rows,
    output logic [3:0] cols,
    output logic       key_valid,
    output logic [3:0] key_value
);

localparam SCAN_DIV = CLK_HZ / 4;
localparam DIV_BITS = $clog2(SCAN_DIV + 1);

logic [DIV_BITS-1:0] div_cnt;
logic                scan_tick;

// Divisor de frecuencia
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        div_cnt   <= 0;
        scan_tick <= 0;
    end else if (div_cnt == SCAN_DIV - 1) begin
        div_cnt   <= 0;
        scan_tick <= 1;
    end else begin
        div_cnt   <= div_cnt + 1;
        scan_tick <= 0;
    end
end

// Contador de columna
logic [1:0] col_idx;

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        col_idx <= 0;
    else if (scan_tick)
        col_idx <= col_idx + 1;
end

// Decodificacion de columna activa (activo bajo)
always_comb begin
    case (col_idx)
        2'd0: cols = 4'b1110;
        2'd1: cols = 4'b1101;
        2'd2: cols = 4'b1011;
        2'd3: cols = 4'b0111;
        default: cols = 4'b1111;
    endcase
end

// Deteccion de tecla
logic key_detected;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        key_valid    <= 0;
        key_value    <= 0;
        key_detected <= 0;
    end else begin
        key_valid <= 0;

        if (scan_tick) begin
            if (rows != 4'b1111 && !key_detected) begin
                key_detected <= 1;
                key_valid    <= 1;

                case ({rows, col_idx})
                    // Columna 0
                    {4'b1110, 2'd0}: key_value <= 4'd1;
                    {4'b1101, 2'd0}: key_value <= 4'd4;
                    {4'b1011, 2'd0}: key_value <= 4'd7;
                    {4'b0111, 2'd0}: key_value <= 4'hF; // *
                    // Columna 1
                    {4'b1110, 2'd1}: key_value <= 4'd2;
                    {4'b1101, 2'd1}: key_value <= 4'd5;
                    {4'b1011, 2'd1}: key_value <= 4'd8;
                    {4'b0111, 2'd1}: key_value <= 4'd0;
                    // Columna 2
                    {4'b1110, 2'd2}: key_value <= 4'd3;
                    {4'b1101, 2'd2}: key_value <= 4'd6;
                    {4'b1011, 2'd2}: key_value <= 4'd9;
                    {4'b0111, 2'd2}: key_value <= 4'hA; // #
                    // Columna 3
                    {4'b1110, 2'd3}: key_value <= 4'hA; // A
                    {4'b1101, 2'd3}: key_value <= 4'hB; // B
                    {4'b1011, 2'd3}: key_value <= 4'hC; // C
                    {4'b0111, 2'd3}: key_value <= 4'hD; // D
                    default:         key_value <= 4'hF;
                endcase

            end else if (rows == 4'b1111) begin
                key_detected <= 0;
            end
        end
    end
end

endmodule