import 'dart:ui';
import 'package:flutter/material.dart';


class GlassCard extends StatelessWidget {
  GlassCard({super.key, required this.screenWidth, required this.customClass, required this.text1, required this.text2});
  final double screenWidth;
  final Widget customClass;
  final String text1;
  final String text2;
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
                        colors: [Color.fromARGB(255, 159, 83, 172), Color.fromARGB(255, 136, 190, 235)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        text1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color.fromARGB(255, 159, 83, 172), Color.fromARGB(255, 136, 190, 235)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        text2,
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
