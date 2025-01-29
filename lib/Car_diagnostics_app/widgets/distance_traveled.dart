import 'dart:isolate';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/guages_display/battery_soh_guage.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/guages_display/distance_traveled_guage.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/signal_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DistanceTraveled extends StatefulWidget {
  const DistanceTraveled({super.key});
  @override
  State<DistanceTraveled> createState() => _DistanceTraveledState();

}

class _DistanceTraveledState extends State<DistanceTraveled>{
  final SupabaseClient supabase = Supabase.instance.client;

  //Define a Variable for current BatterySOH value and initialize it wtih 0.
  double currentDistance= 0.0;

  //Define a list for storing different data types, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];

  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;
  //Define currentBatterySOH Isolate that will be initialized later when accessed for accessing Car tire Pressure
  Isolate? DistanceIsolate;
  //Define Receive port for the  value that will be used to return the value of the battery SOH to the main isolate of the program
  late ReceivePort tirePressureReceivePort;
  final VehicleDataSignal distancesignal = VehicleDataSignal(
    name: VehicleDataSignalName.distanceTraveled,
    hexIndex: 4,
    scale: 1,
    offset: 0.0,
    unit: '%',
  );

  @override
  void initState() {
    super.initState();

    // Initialize ReceivePort for isolate communication
    tirePressureReceivePort = ReceivePort();
    tirePressureReceivePort.listen((message) {
      if (message is double) {
        // Vehicle speed data received
        setState(() {
          currentDistance = message;
        });
      } else {
        //debugPrint("Unknown message type received: $message");
      }
    });
    final signalHandler = SignalHandler(supabaseClient: supabase, signal: distancesignal, signlaIsolate: DistanceIsolate, signalReceivePort: tirePressureReceivePort);
    // Fetch the most recent row initially
    signalHandler.fetchMostRecentRow().then((latestRow) {
      if (latestRow != null) {
        //debugPrint("latest row: $latestRow");
        signalHandler.handleNewRow(latestRow);
      }
    });
    // Subscribe to real-time updates
    signalHandler.subscribeToRealtimeUpdates();
  }
  @override
  void dispose() {
    //debugPrint("Disposing tire pressure...");
    if (DistanceIsolate != null) {
      DistanceIsolate?.kill(priority: Isolate.immediate);
      DistanceIsolate = null; // Reset to avoid any unexpected reuse
    }
    tirePressureReceivePort.close();
    super.dispose();
  }
  @override
  build(BuildContext context){
    return DistanceTraveledGuage(currentDistance: currentDistance,);
  }
}