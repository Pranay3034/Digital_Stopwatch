# ⏱️ FPGA-Based Digital Stopwatch using Verilog HDL

<p align="center">
  <strong>A modular digital stopwatch implemented on the Basys 3 FPGA using Verilog HDL and Xilinx Vivado.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge&logo=amd" alt="Verilog HDL"/>
  <img src="https://img.shields.io/badge/FPGA-Basys%203-orange?style=for-the-badge" alt="Basys 3 FPGA"/>
  <img src="https://img.shields.io/badge/Tool-Xilinx%20Vivado-red?style=for-the-badge" alt="Xilinx Vivado"/>
  <img src="https://img.shields.io/badge/Status-Successfully%20Tested-brightgreen?style=for-the-badge" alt="Successfully Tested"/>
</p>

## 📌 Overview

This project implements a **digital stopwatch on the Digilent Basys 3 FPGA board** using Verilog HDL and Xilinx Vivado.

The stopwatch displays elapsed time in **MM:SS format** on the board's four-digit, multiplexed seven-segment display. It supports start, pause, resume, and reset operations using onboard push buttons.

The design follows a modular RTL architecture, separating timing generation, BCD counting, seven-segment decoding, display multiplexing, and top-level control. Each module can be simulated and verified independently before integration.

The design was synthesized, implemented, and successfully tested on the physical Basys 3 FPGA board.

## ✨ Features

- ⏱️ Stopwatch display in **MM:SS format**
- ▶️ Start the stopwatch using an onboard push button
- ⏸️ Pause and resume without losing the elapsed time
- 🔄 Reset the stopwatch to `00:00`
- 🔢 Four-digit seven-segment display with time-multiplexing
- 🧮 BCD-based time counting with correct digit rollover
- 🧩 Modular and reusable Verilog RTL design
- 🧪 Individual module testbenches and an integration testbench
- 📐 FPGA pin assignments and clock constraints using an XDC file
- ⚡ Timing analysis and successful bitstream generation
- 🔌 Verified operation on physical Basys 3 hardware

## 🛠️ Hardware and Software Requirements

| Component | Specification |
|---|---|
| FPGA development board | Digilent Basys 3 |
| FPGA device | Artix-7 XC7A35T |
| Hardware description language | Verilog HDL |
| FPGA development tool | Xilinx Vivado |
| System clock | 100 MHz |
| Display | Four-digit multiplexed seven-segment display |
| User input | Onboard push buttons |

## 🏗️ System Architecture

The stopwatch is divided into five main RTL modules.

```text
                  ┌─────────────────────┐
                  │  Basys 3 Clock 100MHz│
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │   Timing Generator  │
                  │  1-second tick      │
                  │  Display scan tick  │
                  └──────────┬──────────┘
                             │
                 ┌───────────▼───────────┐
                 │      BCD Counter      │
                 │  Minutes and Seconds  │
                 └───────────┬───────────┘
                             │
                    Four BCD digits
                             │
                 ┌───────────▼───────────┐
                 │   Display Scanner     │
                 │ Digit selection and   │
                 │ seven-segment decoding│
                 └───────────┬───────────┘
                             │
                 ┌───────────▼───────────┐
                 │ Four-Digit 7-Segment  │
                 │     Display MM:SS     │
                 └───────────────────────┘

       Center Button ──► Reset Control
       Up Button     ──► Start / Pause Control
```

### 1. Timing Generator — `timing_generator.v`

Generates timing-enable pulses from the 100 MHz system clock.

- Generates a one-second tick for stopwatch counting.
- Generates a display-scan tick for multiplexing.
- Uses parameterized clock and scan frequencies.

### 2. BCD Counter — `bcd_counter.v`

Maintains the elapsed time using four BCD digits.

- Seconds units: `0–9`
- Seconds tens: `0–5`
- Minutes units: `0–9`
- Minutes tens: `0–9`
- Rolls over from `59` seconds to the next minute.
- Wraps from `99:59` to `00:00`.

Counting occurs only when the stopwatch is running and a one-second enable pulse is received.

### 3. Seven-Segment Decoder — `seven_segment_decoder.v`

Converts a four-bit BCD digit into the corresponding seven-segment pattern. The decoder uses active-low segment outputs suitable for the Basys 3 display.

### 4. Display Scanner — `display_scanner.v`

Multiplexes the four digits so that all four time digits appear simultaneously to the observer.

- Selects one display digit at a time.
- Drives the active-low digit-select signals.
- Uses the seven-segment decoder to generate segment patterns.
- Keeps the decimal point off.

### 5. Top-Level Controller — `digital_stopwatch_top.v`

Integrates the timing generator, BCD counter, display scanner, and push-button control logic.

The UP button toggles between running and paused states. The CENTER button resets the stopwatch and stops counting.

## 📁 Project Structure

```text
Digital_Stopwatch/
│
├── design/
│   ├── timing_generator.v
│   ├── bcd_counter.v
│   ├── seven_segment_decoder.v
│   ├── display_scanner.v
│   └── digital_stopwatch_top.v
│
├── simulation/
│   ├── tb_timing_generator.v
│   ├── tb_bcd_counter.v
│   ├── tb_seven_segment_decoder.v
│   ├── tb_display_scanner.v
│   └── tb_digital_stopwatch.v
│
├── constraints/
│   └── Basys-3-Master.xdc
│
└── README.md
```

*The tree above describes the intended source layout. Adjust the paths if your repository uses a different folder structure.*

## 🎮 Controls

| Basys 3 control | FPGA port | Function |
|---|---|---|
| Center push button | `btnC` | Reset and stop |
| Up push button | `btnU` | Start, pause, or resume |

### Operating sequence

1. After reset, the display shows `00:00`.
2. Press the UP button to start counting.
3. Press the UP button again to pause the stopwatch.
4. Press the UP button again to resume from the stored time.
5. Press the CENTER button to reset the display to `00:00` and stop counting.

## 🔌 FPGA Pin Constraints

The design uses the Basys 3 master XDC file, with constraints enabled for the ports used by the stopwatch.

| Signal | Basys 3 FPGA pin |
|---|---|
| `clk` | W5 |
| `btnC` | U18 |
| `btnU` | T18 |
| `seg[0]` — segment A | W7 |
| `seg[1]` — segment B | W6 |
| `seg[2]` — segment C | U8 |
| `seg[3]` — segment D | V8 |
| `seg[4]` — segment E | U5 |
| `seg[5]` — segment F | V5 |
| `seg[6]` — segment G | U7 |
| `dp` | V7 |
| `an[0]` | U2 |
| `an[1]` | U4 |
| `an[2]` | V4 |
| `an[3]` | W4 |

The system clock is constrained to a **10 ns period (100 MHz)**, and the relevant I/O pins use `LVCMOS33`.

## 🧪 Simulation and Verification

The project includes dedicated testbenches for the timing generator, BCD counter, seven-segment decoder, display scanner, and complete stopwatch.

The integration testbench checks the following behaviors:

- Reset initializes the elapsed time to `00:00`.
- Start enables stopwatch counting.
- Pause preserves the elapsed time.
- Resume continues counting from the paused value.
- Reset clears the elapsed time and stops the stopwatch.

The integration simulation completed successfully, with all stopwatch integration tests passing.

## ⚙️ Implementation Results

The design was synthesized, placed, routed, and converted into a bitstream using Xilinx Vivado.

| Verification item | Result |
|---|---|
| RTL integration simulation | Passed |
| Synthesis | Completed successfully |
| Design Rule Check | Zero errors in the reported checks |
| Routing | Completed successfully |
| Worst Negative Slack (WNS) | +6.221 ns in the reported timing summary |
| Worst Hold Slack (WHS) | +0.147 ns in the reported timing summary |
| Bitstream generation | Completed successfully |
| Physical FPGA testing | Successfully tested on Basys 3 |

**Timing note:** The reported setup and hold slack values are positive, and the timing summary reported no failing endpoints. The report also identified missing external input/output delay constraints, which should be considered if the design is extended or its timing requirements change.

## 🚀 How to Run the Project

### Step 1: Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_REPOSITORY_FOLDER>
```

Replace the placeholders with your actual GitHub repository URL and folder name.

### Step 2: Open Vivado

Launch Xilinx Vivado and create or open a project targeting the **Basys 3 / Artix-7 XC7A35T FPGA**.

### Step 3: Add the RTL files

Add all five Verilog design files from the `design/` directory as design sources.

### Step 4: Add simulation sources

Add the testbenches from `simulation/` as simulation sources. Select the appropriate testbench as the simulation top module when running a test.

### Step 5: Add constraints

Add `constraints/Basys-3-Master.xdc` and ensure the required stopwatch pin assignments and 100 MHz clock constraint are enabled.

### Step 6: Run the design flow

Execute the following Vivado steps:

1. Run **Behavioral Simulation**.
2. Run **Synthesis**.
3. Run **Implementation**.
4. Review the timing summary and design rule checks.
5. Generate the **Bitstream**.

### Step 7: Program the FPGA

Connect and power the Basys 3 board, open **Hardware Manager**, connect to the target, and program the FPGA using the generated `.bit` file.

Test the start, pause, resume, and reset controls on the physical board.

## 🧠 Key Learning Outcomes

This project provided practical experience with:

- RTL design and modular Verilog development.
- Clock division and clock-enable pulse generation.
- BCD arithmetic and cascading counters.
- Seven-segment decoding and display multiplexing.
- Synchronous control logic and push-button input handling.
- Writing and debugging Verilog testbenches.
- FPGA synthesis, placement, routing, and timing analysis.
- XDC pin mapping and physical FPGA programming.
- Hardware validation using a real FPGA development board.

## 🔮 Future Improvements

Potential extensions include:

- Add a lap-time or split-time feature.
- Implement button debouncing and more robust reset synchronization.
- Add a countdown mode with an audible alarm.
- Extend the display to support hours, minutes, and seconds.
- Add configurable timer presets.
- Improve display switching to reduce potential ghosting.

## 👨‍💻 Author

**Pranay Gedam**

M.Tech — Embedded Systems

Interested in FPGA design, digital systems, Verilog HDL, and embedded hardware development.

## ⭐ Support

If you find this project useful for learning FPGA design and Verilog HDL, consider giving the repository a ⭐ on GitHub.

---

*Built with Verilog HDL, implemented using Xilinx Vivado, and validated on the Digilent Basys 3 FPGA board.*
