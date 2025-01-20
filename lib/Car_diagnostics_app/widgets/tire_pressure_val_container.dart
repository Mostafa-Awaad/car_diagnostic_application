import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TirePressureValContainer extends StatelessWidget {
  const TirePressureValContainer(
      {super.key,
      required this.currentTirePressure,
      required this.tirePressureColor});
  final double currentTirePressure;
  final Color tirePressureColor;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              spreadRadius: 5.0,
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Column(
                children: [
                  Text(
                    currentTirePressure.toStringAsFixed(1),
                    style: GoogleFonts.notoSansIndicSiyaqNumbers(
                      fontWeight: FontWeight.bold,
                      color: tirePressureColor,
                      fontSize: constraints.maxWidth * 0.4,
                    ),
                  ),
                  Text(
                    'psi',
                    style: GoogleFonts.notoSansIndicSiyaqNumbers(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: constraints.maxWidth * 0.3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
