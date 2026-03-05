`timescale 1ns / 1ps

module tb_traffic_light_controller;

    reg clk;
    reg reset_n;
    reg main_road_sensor;
    reg side_road_sensor;
    wire [1:0] main_road_light;
    wire [1:0] side_road_light;

    // Instantiate DUT
    traffic_light_controller dut (
        .clk(clk),
        .reset_n(reset_n),
        .main_road_sensor(main_road_sensor),
        .side_road_sensor(side_road_sensor),
        .main_road_light(main_road_light),
        .side_road_light(side_road_light)
    );

    // Generate clock (10 ns period = 100 MHz)
    always #5 clk = ~clk;

    // Function to decode light value
    function [55:0] decode_light;
        input [1:0] light;
        case (light)
            2'b11: decode_light = "GREEN  ";
            2'b01: decode_light = "YELLOW ";
            2'b00: decode_light = "RED    ";
            default: decode_light = "UNKNOWN";
        endcase
    endfunction

    initial begin
        clk              = 0;
        reset_n          = 0;
        main_road_sensor = 0;
        side_road_sensor = 0;
        #20; reset_n = 1;

        // Scenario 1: Only main road traffic — wait for MAIN_GREEN timer to expire
        $display("\n--- Scenario 1: Main road only ---");
        main_road_sensor = 1; side_road_sensor = 0;
        #1500;

        // Scenario 2: Side road vehicle detected — early transition
        $display("\n--- Scenario 2: Side road vehicle ---");
        main_road_sensor = 1; side_road_sensor = 1;
        #800;

        // Scenario 3: Main road priority — SIDE_GREEN exits early
        $display("\n--- Scenario 3: Main road priority ---");
        main_road_sensor = 1; side_road_sensor = 0;
        #800;

        // Scenario 4: No traffic — timer only
        $display("\n--- Scenario 4: No traffic ---");
        main_road_sensor = 0; side_road_sensor = 0;
        #2000;

        $display("\n--- Simulation Complete ---");
        $stop;
    end

    // Print only on light signal changes
    initial begin
        $monitor("Time: %0t ns | Main: %s | Side: %s | MainSensor: %b | SideSensor: %b",
                 $time,
                 decode_light(main_road_light),
                 decode_light(side_road_light),
                 main_road_sensor,
                 side_road_sensor);
    end

    initial begin
        $dumpfile("tlc_tb.vcd");
        $dumpvars(0, tb_traffic_light_controller);
    end

endmodule