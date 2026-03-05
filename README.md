# RTL Digital Design Modules using Verilog
> A Collection of 5 FSM-Based RTL Digital Design Modules Implemented in Verilog and Verified using ModelSim

![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Language](https://img.shields.io/badge/Language-Verilog%20HDL-blue)
![Tool](https://img.shields.io/badge/Tool-ModelSim-blue)
![Design](https://img.shields.io/badge/Design-FSM%20Based-orange)

<h2>🔍 Overview</h2>

- Designed and implemented 5 RTL digital design modules in Verilog — covering communication protocols, memory design, control systems, and sequential logic — each built using **FSM-based architecture** with parameterized design, clean state transition logic, and dedicated testbenches for functional verification.

- All modules verified using **ModelSim** waveform simulation — with `$monitor`, `$display`, and VCD dump for signal tracing — and documented with **draw.io block diagrams**, FSM state transition diagrams, and state transition tables.

<h2>🛠️ Tools & Technology Stack</h2>

| Category | Tool / Technology |
|:---|:---|
| HDL | Verilog |
| Simulation | ModelSim |
| Diagram Design | draw.io |
| Design Style | FSM-Based RTL Design |
| Encoding | One-Hot, Binary State Encoding |
| OS | Windows |

<h2>📦 Modules Overview</h2>

| Module | Type | States / Architecture | Key Feature |
|:---|:---|:---|:---|
| UART | Communication Protocol | FSM — IDLE, START, DATA, PARITY, STOP | Parity checking, parameterized baud rate |
| FIFO | Memory Design | Circular buffer — Read/Write pointers | Parameterized WIDTH, DEPTH, full/empty flags |
| Traffic Light Controller | Control System | FSM — MAIN_GREEN, MAIN_YELLOW, SIDE_GREEN, SIDE_YELLOW | Sensor-driven priority, timer-based transitions |
| Automatic Temperature Control | Control System | FSM — IDLE, HEATING, COOLING | One-hot encoding, environment simulation testbench |
| Washing Machine Controller | Sequential Logic | FSM — IDLE, FILL, WASH, DRAIN, RINSE, SPIN, END | 7-state FSM, timer-driven cycle control |

<h2>📁 Repository Structure</h2>

```
📁 Project-RTL-Digital-Design-Modules-using-Verilog
│
├── 📁 01 : UART
│   ├── Baud_Rate_Generator.v
│   ├── Transmitter_Module.v
│   ├── Receiver_Module.v
│   ├── UART_Testbench.v
│   ├── diagrams/
│   └── README.md
│
├── 📁 02 : FIFO
│   ├── FIFO_Maincode.v
│   ├── FIFO_Testbench.v
│   ├── diagrams/
│   └── README.md
│
├── 📁 03 : Traffic Light Controller
│   ├── Traffic_Light_Controller_maincode.v
│   ├── Traffic_Light_Controller_testbench.v
│   ├── diagrams/
│   └── README.md
│
├── 📁 04 : Automatic Temperature Control
│   ├── Automatic_Temperature_Control.v
│   ├── Automatic_Temperature_Controller_Testbench.v
│   ├── diagrams/
│   └── README.md
│
├── 📁 05 : Washing Machine Controller
│   ├── Washing_machine_maincode.v
│   ├── Washing_Machine_testbench.v
│   ├── diagrams/
│   └── README.md
│
└── 📄 README.md
```

<h2>📝 Module Details</h2>

**01 — UART** &nbsp;|&nbsp; `Baud Rate Generator` `Transmitter` `Receiver` `Parity Check`

Implemented a complete UART communication system with 3 separate modules — Baud Rate Generator (parameterized CLK_FREQ/BAUD_RATE), Transmitter (FSM: IDLE → START_BIT → DATA_BITS → PARITY_BIT → STOP_BIT), and Receiver (mirror FSM with parity verification). Testbench transmits 5 data bytes (0x43, 0x72, 0xA5, 0xE7, 0xF4) in loopback mode and verifies received data against expected values.

> 📁 [View Module Details](./01%20:%20UART/README.md)

---

**02 — FIFO** &nbsp;|&nbsp; `Circular Buffer` `Read/Write Pointers` `Full/Empty Flags`

Implemented a parameterized synchronous FIFO with configurable WIDTH (8-bit), DEPTH (8 entries), and PTR_WIDTH (3-bit pointers). Features separate write and read pointer logic, counter-based full/empty flag generation, and active-low reset. Testbench writes 5 values (0x11–0x55) and reads them back verifying FIFO ordering.

> 📁 [View Module Details](./02%20:%20FIFO/README.md)

---

**03 — Traffic Light Controller** &nbsp;|&nbsp; `Sensor-Driven` `Timer-Based` `Priority Logic`

Implemented a 4-state FSM traffic light controller with sensor-driven priority and timer-based transitions at 100 MHz clock — MAIN_GREEN (1s), MAIN_YELLOW (200ms), SIDE_GREEN (500ms), SIDE_YELLOW (200ms). Side road sensor triggers early transition after minimum main road hold time (300ms). Testbench verifies 3 scenarios — main only, side road vehicle, and back to main.

> 📁 [View Module Details](./03%20:%20Traffic%20Light%20Controller/README.md)

---

**04 — Automatic Temperature Control** &nbsp;|&nbsp; `One-Hot FSM` `Environment Simulation` `Auto Test Cases`

Implemented a 3-state one-hot FSM temperature controller (IDLE, HEATING, COOLING) with 8-bit current/desired temperature inputs and 4-bit tolerance. Testbench simulates real environment behavior — heater increments temperature by 2°C every 10 cycles, cooler decrements by 3°C every 5 cycles. Automated test cases validate 4 scenarios (heating up, cooling down, cold winter, hot summer) with pass/fail display.

> 📁 [View Module Details](./04%20:%20Automatic%20Temperature%20Control/README.md)

---

**05 — Washing Machine Controller** &nbsp;|&nbsp; `7-State FSM` `Timer-Driven` `Full Wash Cycle`

Implemented a 7-state FSM washing machine controller (IDLE → FILL → WASH → DRAIN → RINSE → SPIN → END) with timer-driven state transitions — WASH (200 cycles), RINSE (150 cycles), SPIN (300 cycles) — and sensor-driven transitions for water level and drain status. Testbench simulates a complete wash cycle with console monitoring of all valve and motor outputs.

> 📁 [View Module Details](./05%20:%20Washing%20Machine%20Controller/README.md)

---

<h2>🤝 Connect</h2>

| **Author** | Preetham SK |
|:---|:---|
| **Program** | Skilldzire |
| **LinkedIn** | [linkedin.com/in/preethamsk16](https://www.linkedin.com/in/preethamsk16) |
| **GitHub** | [github.com/PreethamSK163](https://github.com/PreethamSK163) |
| **Email** | preethamsk163@gmail.com |
