import 'dart:async';
import 'dart:isolate';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Speedometer extends StatefulWidget {
  const Speedometer({Key? key}) : super(key: key);

  @override
  _SpeedometerState createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  final SupabaseClient _supabase = Supabase.instance.client;
  double currentSpeed = 0.0;
  List<dynamic> dataFrame = [];
  int currentIndex = 0;
  late Isolate isolate;

  @override
  void initState() {
    super.initState();
    fetchDataFrame();
  }

  Future<void> fetchDataFrame() async {
    final response = await _supabase.from('car_logs').select('data_frame');
    dataFrame = response as List<dynamic>;
    startIsolate();
  }

  void startIsolate() {
    ReceivePort receivePort = ReceivePort();
    receivePort.listen((data) {
      setState(() {
        currentSpeed = data as double;
      });
    });
    Isolate.spawn(
      processData,
      [dataFrame, receivePort.sendPort],
    );
  }

  static void processData(List<Object> args) {
    List<dynamic> data = args[0] as List<dynamic>;
    SendPort sendPort = args[1] as SendPort;
    int index = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      String base64String = data[index]['data_frame'];
      List<int> bytes = base64.decode(base64String);
      double speed = bytes[7].toDouble();

      sendPort.send(speed);
      index = (index + 1) % data.length;
    });
  }

  @override
  void dispose() {
    isolate.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 255,
            pointers: <GaugePointer>[
              RangePointer(value: currentSpeed, width: 20),
              NeedlePointer(value: currentSpeed),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '${currentSpeed.toStringAsFixed(0)} km/h',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
