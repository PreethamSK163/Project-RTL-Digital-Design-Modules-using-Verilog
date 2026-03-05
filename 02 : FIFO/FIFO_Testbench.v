module fifo_tb;

    reg clk;
    reg reset_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full, empty;

    fifo #(8, 8, 3) uut (
        .clk(clk),
        .reset_n(reset_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Time\tWr_en\tRd_en\tDataIn\tDataOut\tFull\tEmpty");
        clk = 0;
        reset_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #20;
        reset_n = 1;

        // Write 5 values
        @(posedge clk); wr_en = 1; data_in = 8'h11; rd_en = 0; // A0 = 0x11
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); wr_en = 1; data_in = 8'h22; 
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); wr_en = 1; data_in = 8'h33;
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); wr_en = 1; data_in = 8'h44;
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); wr_en = 1; data_in = 8'h55;
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);

        @(posedge clk); wr_en = 0;

        // Read 5 values
        @(posedge clk); rd_en = 1; 
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); 
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); 
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); 
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);
        @(posedge clk); 
        $display("%0t\t%b\t%b\t%h\t%h\t%b\t%b", $time, wr_en, rd_en, data_in, data_out, full, empty);

        @(posedge clk); rd_en = 0;

        #20;
        $finish;
    end

endmodule

