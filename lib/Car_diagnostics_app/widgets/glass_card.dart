import 'dart:ui';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/fuel_level.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/temperature_eng_coolant.dart';
import 'package:flutter/material.dart';

final text1 = {
  TemperatureEngCoolant(): "Engine",
  FuelLevel(): "Fuel",
};
final text2 = {
  TemperatureEngCoolant() : "Coolant Temp",
  FuelLevel(): "Level"
};
class GlassCard extends StatelessWidget {
  GlassCard({super.key, required this.screenWidth, required this.customClass});
  final double screenWidth;
  final Widget customClass;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // Transparent base for the glass effect
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Engine',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Coolant Temp ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Flexible(child: Center(child: customClass)),
                    const SizedBox(height: 20),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
