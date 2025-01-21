import 'dart:isolate';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/guages_display/eng_cool_temp_guage.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/signal_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Create a class for Speedometer. Making it extends StatefulWidget because the vehicle speed value will change over time.
class TemperatureEngCoolant extends StatefulWidget {
  const TemperatureEngCoolant({super.key});

  @override
  State<TemperatureEngCoolant> createState() => _TemperatureEngCoolant();
}

class _TemperatureEngCoolant extends State<TemperatureEngCoolant> {
  //Initialize the Supabase client, the Supabase_Url and Supabase_Anon_Key is stored in .env file
  final SupabaseClient supabase = Supabase.instance.client;

  //Define a Variable for engine coolant current Temperature and initialize it wtih 0.
  double currentTemp = 0.0;

  //Define a list for storing different data types, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];

  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;
  //Define temperature isolate that will be initialized later when accessed for accessing engine coolant temperature.
  Isolate? tempIsolate;
  //Define Receive port for the temperature value that will be used to return the value of the engine coolant temperature to the main isolate of the program
  late ReceivePort tempReceivePort;
  final VehicleDataSignal engineCoolantTemp = VehicleDataSignal(
    name: VehicleDataSignalName.coolantTemp,
    hexIndex: 12,
    scale: 1.0,
    offset: -40.0,
    unit: 'degC',
  );
  @override
  void initState() {
    super.initState();

    // Initialize ReceivePort for isolate communication
    tempReceivePort = ReceivePort();
    tempReceivePort.listen((message) {
      if (message is double) {
        // engine coolant temperature data received
        setState(() {
          currentTemp = message;
        });
      } else {
        //debugPrint("Unknown message type received: $message");
      }
    });
    final signalHandler = SignalHandler(supabaseClient: supabase, signal: engineCoolantTemp, signlaIsolate: tempIsolate, signalReceivePort: tempReceivePort);
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
    //debugPrint("Disposing Engine Coolant Temperature...");
    if (tempIsolate != null) {
      tempIsolate?.kill(priority: Isolate.immediate);
      tempIsolate = null; // Reset to avoid any unexpected reuse
    }
    tempReceivePort.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Changing the color of the text showing the speed value depending on its range
    Color getTemperatureColor() {
    if (currentTemp <= 85) {
      return Colors.blue;
    } else if (currentTemp <= 170) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

    return EngCoolTempGuage(currentTemperature: currentTemp, getTemperatureColor: getTemperatureColor);
  }
}