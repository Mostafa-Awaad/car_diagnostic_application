import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class EngCoolTempGuage extends StatelessWidget{
  const EngCoolTempGuage({super.key, required this.currentTemperature, required this.getTemperatureColor});
  final double currentTemperature;
  final Color Function() getTemperatureColor;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gaugeSize = constraints.maxWidth *
            0.8; // Adjust gauge size based on screen width

        return Center(
          child: SizedBox(
            width: gaugeSize,
            height: gaugeSize,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  ticksPosition: ElementsPosition.outside,
                  labelsPosition: ElementsPosition.outside,
                  axisLabelStyle: const GaugeTextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  radiusFactor: 2.0,
                  majorTickStyle: const MajorTickStyle(
                      length: 0.1,
                      thickness: 2,
                      lengthUnit: GaugeSizeUnit.factor),
                  minorTickStyle: const MinorTickStyle(
                      length: 0.05,
                      thickness: 1.5,
                      lengthUnit: GaugeSizeUnit.factor),
                  minimum: -40,
                  maximum: 215,
                  startAngle: 150,
                  endAngle: 30,
                  showLabels: true,
                  showTicks: true,
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
                          Colors.green,
                          Colors.yellow,
                          Colors.red
                        ],
                      ),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: currentTemperature,
                      width: 20,
                      cornerStyle: CornerStyle.bothCurve,
                      color: Colors.transparent,
                    ),
                    NeedlePointer(
                      value: currentTemperature,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentTemperature.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: gaugeSize * 0.2,
                                  fontWeight: FontWeight.bold,
                                  color: getTemperatureColor(),
                                ),
                              ),
                              const Text(
                                ' °C',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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