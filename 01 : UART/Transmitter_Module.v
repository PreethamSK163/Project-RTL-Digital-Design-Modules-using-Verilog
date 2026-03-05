module uart_tx #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire data_ready,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg tx_serial
);

    reg [2:0] state;
    reg [DATA_WIDTH-1:0] data_reg;
    reg [3:0] bit_counter;
    reg parity;

    localparam IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, PARITY_BIT = 3'b011, STOP_BIT = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else if (baud_tick)
            case (state)
                IDLE: if (data_ready) state <= START_BIT;
                START_BIT: state <= DATA_BITS;
                DATA_BITS: if (bit_counter == DATA_WIDTH - 1) state <= PARITY_BIT;
                PARITY_BIT: state <= STOP_BIT;
                STOP_BIT: state <= IDLE;
            endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_serial <= 1;
            bit_counter <= 0;
            data_reg <= 0;
            parity <= 0;
        end else if (baud_tick) begin
            case (state)
                IDLE: tx_serial <= 1;
                START_BIT: begin
                    tx_serial <= 0;
                    data_reg <= data_in;
                    parity <= ^data_in;
                    bit_counter <= 0;
                end
                DATA_BITS: begin
                    tx_serial <= data_reg[bit_counter];
                    bit_counter <= bit_counter + 1;
                end
                PARITY_BIT: tx_serial <= parity;
                STOP_BIT: tx_serial <= 1;
            endcase
        end
    end

endmodule
