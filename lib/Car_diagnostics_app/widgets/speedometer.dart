import 'dart:isolate';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/guages_display/speedometer_guage.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/signal_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Create a class for Speedometer. Making it extends StatefulWidget because the vehicle speed value will change over time.
class Speedometer extends StatefulWidget {
  const Speedometer({super.key});

  @override
  State<Speedometer> createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  //Initialize the Supabase client, the Supabase_Url and Supabase_Anon_Key is stored in .env file
  final SupabaseClient supabase = Supabase.instance.client;

  //Define a Variable for vehicle current speed and initialize it wtih 0.
  double currentSpeed = 0.0;

  //Define a list for storing different data types, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];

  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;
  //Define speedisolate that will be initialized later when accessed for accessing vehicle speed data
  Isolate? speedisolate;
  //Define Receive port for the speed value that will be used to return the value of the vehicle speed to the main isolate of the program
  late ReceivePort speedReceivePort;
  final VehicleDataSignal vehicleSpeedSignal = VehicleDataSignal(
    name: VehicleDataSignalName.vehicleSpeed,
    hexIndex: 14,
    scale: 1.0,
    offset: 0.0,
    unit: 'km/h',
  );
  @override
  void initState() {
    super.initState();

    // Initialize ReceivePort for isolate communication
    speedReceivePort = ReceivePort();
    speedReceivePort.listen((message) {
      if (message is double) {
        // Vehicle speed data received
        setState(() {
          currentSpeed = message;
        });
      } else {
        //debugPrint("Unknown message type received: $message");
      }
    });
    final signalHandler = SignalHandler(supabaseClient: supabase, signal: vehicleSpeedSignal, signlaIsolate: speedisolate, signalReceivePort: speedReceivePort);
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
    //debugPrint("Disposing Speedometer...");
    if (speedisolate != null) {
      speedisolate?.kill(priority: Isolate.immediate);
      speedisolate = null; // Reset to avoid any unexpected reuse
    }
    speedReceivePort.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Changing the color of the text showing the speed value depending on its range
    Color speedColor = currentSpeed <= 100
        ? Colors.blue
        : ((100 < currentSpeed) && (currentSpeed <= 190))
            ? Colors.purple
            : Colors.red;

    return SpeedometerGuage(currentSpeed: currentSpeed, speedColor: speedColor);
  }
}