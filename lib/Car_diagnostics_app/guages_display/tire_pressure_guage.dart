import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TirePressureGuage extends StatelessWidget {
  const TirePressureGuage(
      {super.key,
      required this.currentTirePressure,
      required this.tirePressureColor});
  final double currentTirePressure;
  final Color tirePressureColor;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          '$currentTirePressure',
          style: GoogleFonts.notoSansIndicSiyaqNumbers(
              fontWeight: FontWeight.bold,
              color: tirePressureColor),
        );
      },
    );
  }
}
