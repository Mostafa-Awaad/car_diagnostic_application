import 'dart:isolate';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/guages_display/tire_pressure_guage.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/signal_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Create a class for Speedometer. Making it extends StatefulWidget because the vehicle speed value will change over time.
class TirePressure extends StatefulWidget {
  const TirePressure({super.key});

  @override
  State<TirePressure> createState() => _TirePressureState();
}

class _TirePressureState extends State<TirePressure> {
  //Initialize the Supabase client, the Supabase_Url and Supabase_Anon_Key is stored in .env file
  final SupabaseClient supabase = Supabase.instance.client;

  //Define a Variable for current Tires pressure and initialize it wtih 0.
  double currentTirePressure = 0.0;

  //Define a list for storing different data types, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];

  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;
  //Define tirePressureIsolate that will be initialized later when accessed for accessing Car tire Pressure
  Isolate? tirePressureIsolate;
  //Define Receive port for the  value that will be used to return the value of the car tire pressure to the main isolate of the program
  late ReceivePort tirePressureReceivePort;
  final VehicleDataSignal tirePressureSignal = VehicleDataSignal(
    name: VehicleDataSignalName.carTirePressure,
    hexIndex: 2,
    scale: 0.5,
    offset: 0.0,
    unit: 'psi',
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
          currentTirePressure = message;
        });
      } else {
        //debugPrint("Unknown message type received: $message");
      }
    });
    final signalHandler = SignalHandler(supabaseClient: supabase, signal: tirePressureSignal, signlaIsolate: tirePressureIsolate, signalReceivePort: tirePressureReceivePort);
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
    if (tirePressureIsolate != null) {
      tirePressureIsolate?.kill(priority: Isolate.immediate);
      tirePressureIsolate = null; // Reset to avoid any unexpected reuse
    }
    tirePressureReceivePort.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Changing the color of the text showing the speed value depending on its range
    Color speedColor = (currentTirePressure <= 36) && (currentTirePressure >=28)
        ? Colors.lightBlue
        : const Color.fromARGB(255, 235, 101, 101);

    return TirePressureGuage(currentTirePressure: currentTirePressure, tirePressureColor: speedColor);
  }
}