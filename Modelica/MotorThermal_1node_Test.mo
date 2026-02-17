model MotorThermal_1node_Test
  //MotorThermal_1node m;
  // Baselines
  //Modelica.Blocks.Sources.Constant torqueBase(k=20) "N*m";
  //Modelica.Blocks.Sources.Constant speedBase(k=150) "rad/s";
  //Modelica.Blocks.Sources.Constant voltageBase(k=300) "V";
  //Modelica.Blocks.Sources.Constant ambTemp(k=298.15) "K";
  // Steps (changes in time)
  //Modelica.Blocks.Sources.Step torqueStep(height=40, startTime=200) "N*m";
  //Modelica.Blocks.Sources.Step speedStep(height=250, startTime=400) "rad/s";
  //Modelica.Blocks.Sources.Step voltageStep(height=150, startTime=600) "V";
  //Modelica.Blocks.Sources.CombiTimeTable coolantTemp(
  //  table=[0,    293.15;
  //       400,  294.15;
  //       800,  292.15;
  //       1200, 294.15;
  //       1600, 293.15;
  //       2000, 293.15],
  //smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);
  // Adders: baseline + step
  //Modelica.Blocks.Math.Add torque;
  //Modelica.Blocks.Math.Add speed;
  //Modelica.Blocks.Math.Add voltage;
  Modelica.Blocks.Sources.Constant torqueBase1(k = 130)  annotation(
    Placement(transformation(origin = {-68, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant speedBase1(k = 6000)  annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant voltageBase1(k = 600)  annotation(
    Placement(transformation(origin = {-70, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant ambTemp1(k = 298.15)  annotation(
    Placement(transformation(origin = {-4, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step torqueStep1(height = 40, startTime = 500)  annotation(
    Placement(transformation(origin = {-40, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step speedStep1(height = 3000, startTime = 500)  annotation(
    Placement(transformation(origin = {-40, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add torque1 annotation(
    Placement(transformation(origin = {-2, 76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add speed1 annotation(
    Placement(transformation(origin = {-2, 34}, extent = {{-10, -10}, {10, 10}})));
  MotorThermal_1node m1 annotation(
    Placement(transformation(origin = {75, 67}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Sources.Constant coolantTemp1(k = 293.15)  annotation(
    Placement(transformation(origin = {-4, -76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 0.1047)  annotation(
    Placement(transformation(origin = {26, 34}, extent = {{-10, -10}, {10, 10}})));
equation
//  connect(torqueBase.y, torque.u1);
//  connect(torqueStep.y, torque.u2);
//  connect(speedBase.y, speed.u1);
//  connect(speedStep.y, speed.u2);
// connect(voltageBase.y, voltage.u1);
//  connect(voltageStep.y, voltage.u2);
//connect(torque.y,  m.torque);
//connect(speed.y,   m.rot_speed);
//connect(voltage.y, m.pot_dc);
//connect(coolantTemp.y[1], m.T_coola);
//connect(ambTemp.y,        m.T_ambi);
  connect(torqueBase1.y, torque1.u1) annotation(
    Line(points = {{-56, 82}, {-14, 82}}, color = {0, 0, 127}));
  connect(torqueStep1.y, torque1.u2) annotation(
    Line(points = {{-28, 64}, {-14, 64}, {-14, 70}}, color = {0, 0, 127}));
  connect(speedBase1.y, speed1.u1) annotation(
    Line(points = {{-58, 40}, {-14, 40}}, color = {0, 0, 127}));
  connect(speedStep1.y, speed1.u2) annotation(
    Line(points = {{-29, 22}, {-14, 22}, {-14, 28}}, color = {0, 0, 127}));
  connect(torque1.y, m1.torque) annotation(
    Line(points = {{10, 76}, {62, 76}, {62, 75}}, color = {0, 0, 127}));
  connect(ambTemp1.y, m1.T_ambi) annotation(
    Line(points = {{8, -44}, {22, -44}, {22, -16}, {62, -16}, {62, 62}}, color = {0, 0, 127}));
  connect(voltageBase1.y, m1.pot_dc) annotation(
    Line(points = {{-58, -4}, {62, -4}, {62, 66}}, color = {0, 0, 127}));
  connect(coolantTemp1.y, m1.T_coola) annotation(
    Line(points = {{8, -76}, {62, -76}, {62, 58}}, color = {0, 0, 127}));
  connect(speed1.y, gain.u) annotation(
    Line(points = {{10, 34}, {14, 34}}, color = {0, 0, 127}));
  connect(gain.y, m1.rot_speed) annotation(
    Line(points = {{38, 34}, {62, 34}, {62, 70}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end MotorThermal_1node_Test;
