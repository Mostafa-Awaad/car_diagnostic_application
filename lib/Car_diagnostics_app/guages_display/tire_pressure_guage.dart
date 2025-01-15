import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/tire_pressure_val_container.dart';
import 'package:flutter/material.dart';

class TirePressureGuage extends StatelessWidget {
  const TirePressureGuage(
      {super.key,
      required this.currentTirePressure,
      required this.tirePressureColor});
  final double currentTirePressure;
  final Color tirePressureColor;
  @override
  Widget build(BuildContext context) {
    return TirePressureValContainer(currentTirePressure: currentTirePressure, tirePressureColor: tirePressureColor);
  }
}
