import 'dart:isolate';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/guages_display/fuel_level_guage.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/signal_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Create a class for Speedometer. Making it extends StatefulWidget because the vehicle speed value will change over time.
class FuelLevel extends StatefulWidget {
  const FuelLevel({super.key});

  @override
  State<FuelLevel> createState() => _FuelLevelState();
}

class _FuelLevelState extends State<FuelLevel> {
  //Initialize the Supabase client, the Supabase_Url and Supabase_Anon_Key is stored in .env file
  final SupabaseClient supabase = Supabase.instance.client;

  //Define a Variable for current value for fuel level and initialize it w 0.
  double currentFuelLevel = 0.0;

  //Define a list for storing different data types, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];

  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;
  //Define fuelLevelIsolate that will be initialized later when accessed for accessing fuel level data
  Isolate? fuelLevelIsolate;
  //Define Receive port for the fuel level value that will be used to return the value of the vehicle's fuel level to the main isolate of the program
  late ReceivePort fuelLevelReceivePort;
  final VehicleDataSignal fuelLevelSignal = VehicleDataSignal(
    name: VehicleDataSignalName.fuelLevel,
    hexIndex: 6,
    scale: 0.392156862745098,
    offset: 0.0,
    unit: '%',
  );
  @override
  void initState() {
    super.initState();

    // Initialize ReceivePort for isolate communication
    fuelLevelReceivePort = ReceivePort();
    fuelLevelReceivePort.listen((message) {
      if (message is double) {
        // Fuel Level data received
        setState(() {
          currentFuelLevel = message;
        });
      } else {
        //debugPrint("Unknown message type received: $message");
      }
    });
    final signalHandler = SignalHandler(supabaseClient: supabase, signal: fuelLevelSignal, signlaIsolate: fuelLevelIsolate, signalReceivePort: fuelLevelReceivePort);
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
    //debugPrint("Disposing Fuel Level...");
    if (fuelLevelIsolate != null) {
      fuelLevelIsolate?.kill(priority: Isolate.immediate);
      fuelLevelIsolate = null; // Reset to avoid any unexpected reuse
    }
    fuelLevelReceivePort.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Changing the color of the text showing the fuel level value depending on its range
    Color getFuelColor() {
    if (currentFuelLevel < 25) return Colors.red;
    if (currentFuelLevel < 50) return Colors.orange;
    if (currentFuelLevel < 75) return const Color.fromARGB(255, 144, 192, 230);
    return Colors.blue;
  }

    return FuelLevelGuage(currentFuelLevel: currentFuelLevel, getFuelColor: getFuelColor);
  }
}