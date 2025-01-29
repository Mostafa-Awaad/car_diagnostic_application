import 'package:demo_car_diagnostic_application/Car_diagnostics_app/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DistanceTraveledGuage extends StatelessWidget {
  const DistanceTraveledGuage({
    super.key,
    required this.currentDistance,
    
  });
  final double currentDistance;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: kCardGradient,
      ),
      child: Text(
        "$currentDistance km",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
