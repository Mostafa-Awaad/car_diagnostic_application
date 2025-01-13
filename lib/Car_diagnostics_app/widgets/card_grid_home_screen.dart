import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/fuel_level.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/glass_card.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/temperature_eng_coolant.dart';
import 'package:flutter/material.dart';

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
                customClass: TemperatureEngCoolant(), screenWidth: screenWidth),

            // Fuel Level Card
            Card(
              color: Colors.grey[850],
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
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
                        'Fuel Level',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Flexible(
                      child: Center(
                        child: FuelLevel(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
