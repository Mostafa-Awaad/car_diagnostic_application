import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BatterySocGuage extends StatelessWidget {
  const BatterySocGuage({
    super.key,
    required this.currentBatterySoc,
    //required this.getBatterySOHColor,
  });
  final double currentBatterySoc;
  //final Color Function() getBatterySOHColor;
  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animateFromLastPercent: true,
      barRadius: const Radius.circular(10),
      animation: true,
      backgroundColor: const Color.fromARGB(255, 66, 66, 84).withOpacity(0.5),
      percent: currentBatterySoc / 100,
      lineHeight: 40,
      animationDuration: 1000,
      center: Text(
        currentBatterySoc.toStringAsFixed(2) + "%",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      linearGradient: LinearGradient(
          colors: currentBatterySoc <= 40
              ? [
                  const Color.fromARGB(255, 243, 144, 144),
                  const Color.fromARGB(255, 234, 96, 50)
                ]
              : [Colors.cyan, Colors.blue]),
    );
  }
}
