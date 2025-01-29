import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FuelLevelGuage extends StatelessWidget{
  const FuelLevelGuage({super.key, required this.currentFuelLevel, required this.getFuelColor});
  final double currentFuelLevel;
  final Color Function() getFuelColor;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gaugeSize = constraints.maxWidth * 0.8;

        return Center(
          child: SizedBox(
            width: gaugeSize,
            height: gaugeSize,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  startAngle: 150,
                  endAngle: 30,
                  radiusFactor: 2.0,
                  labelsPosition: ElementsPosition.outside,
                  ticksPosition: ElementsPosition.outside,
                  axisLabelStyle: const GaugeTextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  majorTickStyle: const MajorTickStyle(
                      length: 0.1,
                      thickness: 2,
                      lengthUnit: GaugeSizeUnit.factor),
                  minorTickStyle: const MinorTickStyle(
                      length: 0.05,
                      thickness: 1.5,
                      lengthUnit: GaugeSizeUnit.factor),
                  axisLineStyle: const AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: -40,
                      endValue: 215,
                      startWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.1,
                      gradient: const SweepGradient(
                        stops: <double>[0.2, 0.5, 0.75],
                        colors: <Color>[
                          Colors.cyan,
                          Colors.blue,
                          Color.fromARGB(255, 123, 2, 228)
                        ],
                      ),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: currentFuelLevel,
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      needleColor: Colors.black,
                      tailStyle: const TailStyle(
                        length: 0.18,
                        width: 8,
                        color: Colors.black,
                        lengthUnit: GaugeSizeUnit.factor,
                      ),
                      needleLength: 0.5,
                      needleStartWidth: 1,
                      needleEndWidth: 8,
                      knobStyle: const KnobStyle(
                        knobRadius: 0.07,
                        color: Colors.white,
                        borderWidth: 0.05,
                        borderColor: Colors.black,
                      ),
                      lengthUnit: GaugeSizeUnit.factor,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${(currentFuelLevel).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: gaugeSize * 0.2,
                              fontWeight: FontWeight.bold,
                              color: getFuelColor(),
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
          ),
        );
      },
    );
  }
}