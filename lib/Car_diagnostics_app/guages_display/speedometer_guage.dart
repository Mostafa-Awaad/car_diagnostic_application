import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedometerGuage extends StatelessWidget{
  const SpeedometerGuage({super.key, required this.currentSpeed, required this.speedColor});
  final double currentSpeed;
  final Color speedColor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfRadialGauge(
        ///Initializing a Radial Guage with its specifications
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 255,
            showLabels: true,
            showTicks: true,
            axisLineStyle: AxisLineStyle(
              thickness: 20,
              cornerStyle: CornerStyle.bothCurve,
              color: Colors.grey[800],
              thicknessUnit: GaugeSizeUnit.logicalPixel,
            ),

            ///Initializing range pointer of the radial guage with its specification
            pointers: <GaugePointer>[
              RangePointer(
                value: currentSpeed,
                width: 20, 
                gradient: const SweepGradient(
                  ///Make the range pointer a mix with three colours to beautify the design
                  colors: [Colors.cyan, Colors.blueAccent, Colors.purple],
                  stops: [0.0, 0.5, 1.0],
                ),
                cornerStyle: CornerStyle.bothCurve,
              ),

              ///Initializing the Needle pointer to point to the current speed value and configure its specifications
              NeedlePointer(
                value: currentSpeed,
                needleLength: 0.9,
                enableAnimation: true,
                animationType: AnimationType.ease,
                needleStartWidth: 0,
                needleEndWidth: 5,
                needleColor: Colors.white,
                knobStyle: const KnobStyle(
                  knobRadius: 0.07,
                  color: Colors.blueAccent,
                ),
              ),
            ],

            ///Positioning the Guage annotation and specify its format and style
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      currentSpeed.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: speedColor,
                      ),
                    ),
                    const Text(
                      'km/h',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.7,
              ),
            ],
          ),
        ],
      ),
    );
  }
}