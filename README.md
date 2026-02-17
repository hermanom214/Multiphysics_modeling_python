# Multiphysics Modeling – Lumped Motor Thermal Model (Python)

This project simulates the thermal behavior of an electric motor subjected to step changes in torque and speed.

The script solves a first-order differential equation and plots:

- motor temperature
- loss power
- torque and speed inputs

The model is simplified and intended for engineering insight and quick studies.

---

## Thermal Model

Motor temperature is described by a lumped thermal balance:

Cth * dT/dt = Ploss − h_cool * (T − T_cool) − h_amb * (T − T_amb)

Loss power is modeled as:

Ploss = k_mech * M * omega + k_elec * U²

Where:

- T = motor temperature [K]  
- Cth = thermal capacity [J/K]  
- h_cool = coolant heat transfer coefficient [W/K]  
- h_amb = ambient heat transfer coefficient [W/K]  
- M = torque [N·m]  
- omega = angular speed [rad/s]  
- U = DC voltage [V]

---

## Scenarios

Two predefined operating scenarios are included:

### baseline
Constant operating point (no step change).

### high_load
Step change at t = 500 s to a higher torque and speed operating point.

Scenario definitions are in `get_scenario()`.

---

## Requirements

Python 3.10+

Install dependencies:

## Run

python motor_thermal_lump.py --scenario high_load

## Parameters
Parameter	Meaning	Default
--scenario	baseline or high_load	baseline
--t_end	simulation time [s]	3600
--dt	time step for output [s]	1
--T0	initial motor temperature [K]	293.15

## Notes
Loss model is simplified (demonstration only).
Coolant and ambient temperatures are constant.
Single-node thermal model (no spatial gradients).
Not intended for calibration-grade prediction.


```bash
pip install numpy scipy matplotlib
