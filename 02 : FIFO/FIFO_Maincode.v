module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 8,
    parameter PTR_WIDTH = 3
)(
    input clk,
    input reset_n,
    input wr_en,
    input rd_en,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output full,
    output empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0] wr_ptr, rd_ptr;
    reg [PTR_WIDTH:0] count;

    // Write Logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            wr_ptr <= 0;
        else if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read Logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            rd_ptr <= 0;
        else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Counter Logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count <= 0;
        else if (wr_en && !full && !(rd_en && !empty))
            count <= count + 1;
        else if (rd_en && !empty && !(wr_en && !full))
            count <= count - 1;
    end

    assign full = (count == DEPTH);
    assign empty = (count == 0);

endmodule

