# Simulates a lumped motor thermal model under step changes in torque and speed,
# then plots motor temperature, losses, and inputs over time.
# Run the script with a specific scenario, e.g.:
# python motor_thermal_lump.py --scenario high_load
# Solves differential equation of first order
# Cth​dT/dt​=Ploss​−hcool​(T−Tcool​)−hamb​(T−Tamb​)
# Loss power - dummy model: Ploss​=kmech​Mω+k_elec​U^2


import argparse
import numpy as np
from dataclasses import dataclass
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt


# -----------------------------
# Dataclasses - Data containers for inputs and parameters
# -----------------------------
@dataclass
class Inputs:
    # Torque [N*m]
    torque_base_nm: float
    torque_step_nm: float      # absolute target after step (not height)
    torque_step_time_s: float

    # Speed [rpm]
    speed_base_rpm: float
    speed_step_rpm: float      # absolute target after step (not height)
    speed_step_time_s: float

    # DC voltage [V] (constant for this simplified study)
    voltage_v: float

    # Temperatures [K]
    T_amb_k: float
    T_cool_k: float            # constant coolant inlet temperature


@dataclass
class Params:
    # Thermal
    Cth: float = 8000.0     # [J/K]
    h_cool: float = 60.0    # [W/K]
    h_amb: float = 8.0      # [W/K]

    # Loss model (didactic)
    k_mech: float = 0.02    # [W/(N*m*rad/s)]
    k_elec: float = 0.0008  # [W/V^2]


# -----------------------------
# Helpers - Helper functions for units and step profiles
# -----------------------------
def rpm_to_rad_s(rpm: float) -> float:
    return rpm * 2.0 * np.pi / 60.0


def stepped_value(t: float, base: float, target_after_step: float, step_time: float) -> float:
    return target_after_step if t >= step_time else base


def torque_nm(t: float, inp: Inputs) -> float:
    return stepped_value(t, inp.torque_base_nm, inp.torque_step_nm, inp.torque_step_time_s)


def speed_rpm(t: float, inp: Inputs) -> float:
    return stepped_value(t, inp.speed_base_rpm, inp.speed_step_rpm, inp.speed_step_time_s)


def voltage_v(_: float, inp: Inputs) -> float:
    return inp.voltage_v


def T_amb_k(_: float, inp: Inputs) -> float:
    return inp.T_amb_k


def T_cool_k(_: float, inp: Inputs) -> float:
    return inp.T_cool_k

def torque_for_power(power_w: float, rpm: float) -> float:
    omega = rpm_to_rad_s(rpm)
    return power_w / omega


# -----------------------------
# ODE model - lumped thermal balance
# -----------------------------
def motor_thermal_ode(t: float, y: np.ndarray, p: Params, inp: Inputs) -> np.ndarray:
    T_motor = y[0]  # [K]

    M = torque_nm(t, inp)                 # [N*m]
    omega = rpm_to_rad_s(speed_rpm(t, inp))  # [rad/s]
    U = voltage_v(t, inp)                 # [V]

    # Loss power [W] (toy model)
    P_loss = p.k_mech * M * omega + p.k_elec * (U ** 2)

    # Lumped thermal balance
    dTdt = (
        P_loss
        - p.h_cool * (T_motor - T_cool_k(t, inp))
        - p.h_amb * (T_motor - T_amb_k(t, inp))
    ) / p.Cth

    return np.array([dTdt])


# -----------------------------
# Scenarios (EV-motor oriented) - definitions for inputs
# -----------------------------
def get_scenario(name: str) -> Inputs:
    step_time = 500.0
    sim_Tcool = 293.15   # konstantní inlet coolant
    sim_Tamb  = 298.15

    # Zvolené pracovní body (můžeš později změnit)
    rpm_base = 8000.0
    rpm_high = 12000.0

    # Cílové výkony
    P_base = 80_000.0
    P_high = 160_000.0

    tq_base = torque_for_power(P_base, rpm_base)
    tq_high = torque_for_power(P_high, rpm_high)

    if name == "baseline":
        return Inputs(
            torque_base_nm=tq_base,
            torque_step_nm=tq_base,          # bez změny
            torque_step_time_s=step_time,

            speed_base_rpm=rpm_base,
            speed_step_rpm=rpm_base,         # bez změny
            speed_step_time_s=step_time,

            voltage_v=600.0,
            T_amb_k=sim_Tamb,
            T_cool_k=sim_Tcool,
        )

    if name == "high_load":
        return Inputs(
            torque_base_nm=tq_base,
            torque_step_nm=tq_high,          # step na 160 kW point
            torque_step_time_s=step_time,

            speed_base_rpm=rpm_base,
            speed_step_rpm=rpm_high,         # step na 160 kW point
            speed_step_time_s=step_time,

            voltage_v=800.0,
            T_amb_k=sim_Tamb,
            T_cool_k=sim_Tcool,
        )

    raise ValueError(f"Unknown scenario: {name}")


# -----------------------------
# Main / CLI - parse CLI, solve ODE, and plot results
# -----------------------------
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--scenario", choices=["baseline", "high_load"], default="baseline")
    parser.add_argument("--t_end", type=float, default=3600.0)
    parser.add_argument("--dt", type=float, default=1.0)
    parser.add_argument("--T0", type=float, default=293.15)  # initial motor temp [K]
    args = parser.parse_args()

    inp = get_scenario(args.scenario)
    p = Params()

    t_eval = np.arange(0.0, args.t_end + args.dt, args.dt)

    sol = solve_ivp(
        fun=lambda t, y: motor_thermal_ode(t, y, p, inp),
        t_span=(0.0, args.t_end),
        y0=[args.T0],
        t_eval=t_eval,
        method="RK45",
    )
    if not sol.success:
        raise RuntimeError(sol.message)

    t = sol.t
    T_motor = sol.y[0]

    # Derived for plotting
    M = np.array([torque_nm(tt, inp) for tt in t])
    rpm = np.array([speed_rpm(tt, inp) for tt in t])
    omega = rpm_to_rad_s(rpm)
    U = np.array([voltage_v(tt, inp) for tt in t])

    P_loss = p.k_mech * M * omega + p.k_elec * (U ** 2)
    Tcool = np.full_like(t, inp.T_cool_k)
    Tamb = np.full_like(t, inp.T_amb_k)

    # Plots
    plt.figure()
    plt.plot(t, T_motor - 273.15, label="T_motor [°C]")
    #plt.plot(t, Tcool - 273.15, label="T_cool [°C]")
    #plt.plot(t, Tamb - 273.15, label="T_amb [°C]")
    plt.axvline(500.0, linestyle="--", label="step @ 500s")
    plt.xlabel("t [s]")
    plt.ylabel("Temperature [°C]")
    plt.title(f"Scenario: {args.scenario}")
    plt.grid(True)
    plt.legend()

    plt.figure()
    plt.plot(t, P_loss, label="P_loss [W]")
    plt.xlabel("t [s]")
    plt.ylabel("Power [W]")
    plt.title("Loss power")
    plt.grid(True)
    plt.legend()

    plt.figure()
    plt.plot(t, rpm, label="speed [rpm]")
    plt.plot(t, M, label="torque [Nm]")
    plt.xlabel("t [s]")
    plt.title("Inputs")
    plt.grid(True)
    plt.legend()

    plt.show()


if __name__ == "__main__":
    main()

