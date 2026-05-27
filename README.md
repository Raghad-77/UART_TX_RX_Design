````md
# UART Transmitter & Receiver Design

## Overview
This project implements a configurable UART (Universal Asynchronous Receiver Transmitter) Transmitter and Receiver using Verilog/SystemVerilog.

The design supports configurable parity modes, oversampling techniques, frame validation, and consecutive frame reception. The project was verified through simulation using QuestaSim/ModelSim.

---

## Features

### UART Transmitter (TX)
- Serial transmission of 8-bit parallel data
- Configurable parity enable/disable
- Supports even and odd parity modes
- Busy signal during frame transmission
- Asynchronous active-low reset
- Prevents accepting new data while transmission is active
- Idle line remains HIGH when no transmission occurs

### UART Receiver (RX)
- UART frame reception and decoding
- Oversampling support:
  - 8x
  - 16x
  - 32x
- Start bit, parity bit, and stop bit validation
- Parity error detection
- Stop bit error detection
- Consecutive frame reception without gaps
- Asynchronous active-low reset

---

## Supported UART Frames

### Parity Enabled (Even)
- Start Bit
- 8-bit Data
- Even Parity Bit
- Stop Bit

### Parity Enabled (Odd)
- Start Bit
- 8-bit Data
- Odd Parity Bit
- Stop Bit

### Parity Disabled
- Start Bit
- 8-bit Data
- Stop Bit

---

## Design Modules
- UART_TX
- UART_RX
- Parity Calculator
- Serializer
- Deserializer
- FSM Controllers
- Oversampling Logic
- Error Detection Logic

---

## Verification
The design was verified using simulation testbenches covering:
- Correct frame transmission/reception
- Parity enable/disable cases
- Even/odd parity validation
- Stop bit validation
- Consecutive frame handling
- Busy signal behavior
- Error injection scenarios

---

## Tools Used
- Verilog / SystemVerilog
- QuestaSim

---

## Project Structure
```text
RTL/        -> UART RTL design files
TB/         -> Testbenches
sim/        -> Simulation scripts
````

## Author
Raghad Waleed


