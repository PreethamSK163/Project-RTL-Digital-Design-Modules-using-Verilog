`timescale 1ns/1ps
module washing_machine_tb;

  // Testbench Inputs
  reg clk, reset, start;
  reg water_level_full, drain_empty;

  // DUT Outputs
  wire fill_valve_on, drain_valve_on;
  wire motor_cw, motor_off;

  // DUT Instantiation
  washing_machine dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .water_level_full(water_level_full),
    .drain_empty(drain_empty),
    .fill_valve_on(fill_valve_on),
    .drain_valve_on(drain_valve_on),
    .motor_cw(motor_cw),
    .motor_off(motor_off)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    start = 0;
    water_level_full = 0;
    drain_empty = 0;

    // Initial reset
    #20 reset = 0;

    // Start signal
    #10 start = 1;
    #10 start = 0;

    // Simulate water filled after some time
    #100 water_level_full = 1;

    // Allow WASH cycle to complete
    #2000 water_level_full = 0;

    // Simulate drain empty after DRAIN state
    #100 drain_empty = 1;

    // Allow RINSE cycle to complete
    #1500 drain_empty = 0;

    // Allow SPIN cycle to complete
    #3000;

    // Transition to END and back to IDLE
    #100;

    $display("Testbench completed.");
    $finish;
  end

  // Console monitoring of outputs
  initial begin
    $monitor("Time=%0t | Fill=%b Drain=%b MotorCW=%b MotorOff=%b | WaterFull=%b DrainEmpty=%b",
              $time, fill_valve_on, drain_valve_on, motor_cw, motor_off,
              water_level_full, drain_empty);
  end

  // Dump file for waveform analysis
  initial begin
    $dumpfile("washing_machine_tb.vcd");
    $dumpvars(0, washing_machine_tb);
  end

endmodule
