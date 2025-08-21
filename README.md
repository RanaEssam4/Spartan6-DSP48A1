# Spartan-6 DSP48A1 Slice

## Features
- Parameterized **DSP48A1** implementation
- Supports synchronous and asynchronous reset
- Implements:
  - Multiplication
  - Addition / Subtraction
  - Accumulation
  - Multiplexing (input selection, output modes)
  - Cascade modes
  - Carry in / Carry out
- Fully synthesizable Verilog HDL
- Testbench included for functional verification

---

## Project Structure
├── constraints/           # Clock and pin constraint file (.xdc)
├── src/                   # Verilog source files
├── tb/                    # Testbench files
├── DSP48A1_Report.pdf     # Detailed project report

---

## Tools
- **QuestaSim** – Simulation
- **QuestaLint** – Linting
- **Xilinx Vivado** – Synthesis & Implementation
- **VS Code** – Source editing

---

## Documentation
The full design documentation `DSP48A1_Report.pdf` includes:
- RTL Design
- Testbench description
- Simulation results
- DO file for automated simulation
- Constraint file
- RTL schematic
- Synthesis report

---

## Simulation
### 1. Automatic Simulation
Run the provided DO/script file:
- Compiles all Verilog files
- Loads the testbench
- Runs the simulation
- Displays the waveform

### 2. Manual Simulation
1. Compile source files from `src/`
2. Compile testbench files from `tb/`
3. Load the top-level testbench (`DSP48A1_tb`)
4. Run the simulation and observe waveforms

---

## Testbench
- The provided `DSP48A1_tb.v` contains example DSP operations
- Extend with custom vectors for more thorough testing

