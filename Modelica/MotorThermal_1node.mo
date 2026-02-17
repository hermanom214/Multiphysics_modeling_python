model MotorThermal_1node
  // --- Parameters ---
  parameter Real Cth = 8000 "Thermal capacity [J/K]";
  parameter Real h_cool = 60 "Heat transfer to coolant [W/K]";
  parameter Real h_amb  = 8  "Heat transfer to ambient [W/K]";
  parameter Real k_mech = 0.02 "Loss factor for mech losses [W/(N*m*rad/s)]";
  parameter Real k_elec = 0.0008 "Loss factor for electrical losses [W/V^2]";
 // --- Inputs (connectors) ---
  Modelica.Blocks.Interfaces.RealInput rot_speed annotation(
    Placement(transformation(origin = {-115, 65}, extent = {{-15, -15}, {15, 15}}), iconTransformation(origin = {-114, 32}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput torque annotation(
    Placement(transformation(origin = {-115, 41}, extent = {{-15, -15}, {15, 15}}), iconTransformation(origin = {-114, 72}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pot_dc annotation(
    Placement(transformation(origin = {-116, 18}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-114, -8}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_ambi annotation(
    Placement(transformation(origin = {-116, -4}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-114, -46}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_coola annotation(
    Placement(transformation(origin = {-116, -32}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-114, -86}, extent = {{-20, -20}, {20, 20}})));
 //Outputs
  Modelica.Blocks.Interfaces.RealOutput T_motor_out annotation(
    Placement(transformation(origin = {68, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  //Components / heat transfer network
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor motorCap(C=Cth) annotation(
    Placement(transformation(origin = {44, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor condCool(G=h_cool) annotation(
    Placement(transformation(origin = {19, -31}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor condAmb(G=h_amb) annotation(
    Placement(transformation(origin = {20, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature_coolant annotation(
    Placement(transformation(origin = {-68, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_Losses annotation(
    Placement(transformation(origin = {6, 52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature_Ambient annotation(
    Placement(transformation(origin = {-68, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-82, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = k_mech)  annotation(
    Placement(transformation(origin = {-58, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(transformation(origin = {-78, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = k_elec)  annotation(
    Placement(transformation(origin = {-52, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {-30, 52}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Blocks.Sources.Constant const(k = -273.15)  annotation(
    Placement(transformation(origin = {62, -20}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Blocks.Interfaces.RealOutput T_motor_out_C annotation(
    Placement(transformation(origin = {122, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, 0}, extent = {{-10, -10}, {10, 10}})));
equation
// Simple loss model
//  P_loss = k_mech*torque*rot_speed + k_elec*pot_dc^2;
// Output
  T_motor_out = motorCap.T;
 
 connect(motorCap.port, condAmb.port_a) annotation(
    Line(points = {{44, 50}, {44, -2}, {30, -2}}, color = {191, 0, 0}));
 connect(motorCap.port, condCool.port_a) annotation(
    Line(points = {{44, 50}, {43, 50}, {43, 26}, {44, 26}, {44, -31}, {28, -31}}, color = {191, 0, 0}));
 connect(prescribedTemperature_Ambient.port, condAmb.port_b) annotation(
    Line(points = {{-58, -4}, {-58, -2}, {10, -2}}, color = {191, 0, 0}));
 connect(prescribedTemperature_coolant.port, condCool.port_b) annotation(
    Line(points = {{-58, -32}, {-58, -31}, {10, -31}}, color = {191, 0, 0}));
connect(prescribedHeatFlow_Losses.port, motorCap.port) annotation(
  Line(points = {{16, 52}, {16, 52.5}, {44, 52.5}, {44, 50}}, color = {191, 0, 0}));
 connect(product.u1, rot_speed) annotation(
    Line(points = {{-94, 64}, {-104, 64}, {-104, 65}, {-115, 65}}, color = {0, 0, 127}));
 connect(torque, product.u2) annotation(
    Line(points = {{-115, 41}, {-115, 52}, {-94, 52}}, color = {0, 0, 127}));
 connect(product.y, gain.u) annotation(
    Line(points = {{-70, 58}, {-70, 58}}, color = {0, 0, 127}));
 connect(pot_dc, product1.u1) annotation(
    Line(points = {{-116, 18}, {-116, 30}, {-90, 30}}, color = {0, 0, 127}));
 connect(product1.u2, pot_dc) annotation(
    Line(points = {{-90, 18}, {-116, 18}}, color = {0, 0, 127}));
 connect(product1.y, gain1.u) annotation(
    Line(points = {{-67, 24}, {-65, 24}}, color = {0, 0, 127}));
 connect(gain.y, add.u1) annotation(
    Line(points = {{-47, 58}, {-42, 58}}, color = {0, 0, 127}));
 connect(gain1.y, add.u2) annotation(
    Line(points = {{-41, 24}, {-41, 46}, {-42, 46}}, color = {0, 0, 127}));
 connect(add.y, prescribedHeatFlow_Losses.Q_flow) annotation(
    Line(points = {{-19, 52}, {-19, 53}, {-4, 53}, {-4, 52}}, color = {0, 0, 127}));
 connect(T_ambi, prescribedTemperature_Ambient.T) annotation(
    Line(points = {{-116, -4}, {-80, -4}}, color = {0, 0, 127}));
 connect(T_coola, prescribedTemperature_coolant.T) annotation(
    Line(points = {{-116, -32}, {-80, -32}}, color = {0, 0, 127}));
 connect(T_motor_out, add1.u1) annotation(
    Line(points = {{68, 0}, {78, 0}, {78, 6}}, color = {0, 0, 127}));
 connect(const.y, add1.u2) annotation(
    Line(points = {{74, -20}, {78, -20}, {78, -6}}, color = {0, 0, 127}));
 connect(add1.y, T_motor_out_C) annotation(
    Line(points = {{102, 0}, {122, 0}}, color = {0, 0, 127}));

annotation(uses(Modelica(version="4.0.0")));

end MotorThermal_1node;
