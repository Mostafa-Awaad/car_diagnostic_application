import 'package:demo_car_diagnostic_application/Car_diagnostics_app/configs/colors.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/battery_soc.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/battery_soh.dart';
import 'package:flutter/material.dart';

class BatteryScreen extends StatelessWidget{
  const BatteryScreen ({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: kCardGradient),
      child: Column(
        children: [
          Image.asset('lib/Car_diagnostics_app/images/futuristic_car2.png'),
          const Text(
                    'Battery SOH',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BatterySoh(),
                   const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Battery SOC',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BatterySoc(),
        ],
      ),
    );
  }
}