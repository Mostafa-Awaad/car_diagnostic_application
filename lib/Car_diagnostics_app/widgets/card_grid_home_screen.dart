import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/fuel_level.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/glass_card.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/temperature_eng_coolant.dart';
import 'package:flutter/material.dart';
enum Signals {tempEngCoolant, fuelLevel, tiresPressure, batterySOH}
final text1 = {
  Signals.tempEngCoolant: "Engine",
  Signals. fuelLevel: "Fuel",
  Signals.tiresPressure: "Tires",
  Signals.batterySOH: "Battery",
};
final text2 = {
  Signals.tempEngCoolant: "Coolant Temp",
  Signals. fuelLevel: "Level",
  Signals.tiresPressure: "Pressure",
  Signals.batterySOH: "State of Health",
};

class BottomCardGrid extends StatefulWidget {
  const BottomCardGrid({super.key});
  @override
  State<BottomCardGrid> createState() => _BottomCardGridState();
}

class _BottomCardGridState extends State<BottomCardGrid> {
  double fuelLevel = 80;
  
  // Example fuel level in percentage
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GridView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screenWidth * 0.05,
            mainAxisSpacing: screenHeight * 0.02,
            childAspectRatio: 0.8,
          ),
          children: [
            // Temperature Card
            GlassCard(
                customClass: TemperatureEngCoolant(), screenWidth: screenWidth, text1: text1[Signals.tempEngCoolant].toString(), text2: text2[Signals.tempEngCoolant].toString()),
            GlassCard(customClass: FuelLevel(), screenWidth: screenWidth, text1: text1[Signals.fuelLevel].toString(), text2: text2[Signals.fuelLevel].toString()),
            
          ],
        ),
      ),
    );
  }
}
