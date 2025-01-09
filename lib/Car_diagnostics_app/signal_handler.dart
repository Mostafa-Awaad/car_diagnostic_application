import 'dart:isolate';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/signal_processor.dart';

class SignalHandler {
  SignalHandler({required this.supabaseClient, required this.signal ,required this.signlaIsolate, required this.signalReceivePort});
  final SupabaseClient supabaseClient;
  //Define signlaIsolate that will be initialized later when accessed for accessing data signal
  Isolate? signlaIsolate;
  //Define Receive port for the signal value that will be used to return the value of the signal to the main isolate of the program
  late ReceivePort signalReceivePort;
  final VehicleDataSignal signal;
  // The fetchMostRecentRow function is responsible for retrieving the most recent row
  //from the car_logs_2 table in a Supabase database.
  Future<Map<String, dynamic>?> fetchMostRecentRow() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('car_logs_2')
          .select('data_frame')
          .order('timestamp', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        return response.first as Map<String, dynamic>;
      } else {
        //debugPrint("No data found in the table.");
      }
    } catch (e) {
      //debugPrint("Error fetching initial row: $e");
    }
    return null;
  }

  void subscribeToRealtimeUpdates() {
    supabaseClient
        .from('car_logs_2')
        .stream(primaryKey: ['message_number']) // Use the table's primary key
        .listen((rows) {
      if (rows.isNotEmpty) {
        final latestRow = rows.last;
        //debugPrint("New row received: $latestRow");
        handleNewRow(latestRow);
      }
    });
  }

  void handleNewRow(Map<String, dynamic> row) {
    final base64String = row['data_frame'] as String;

    try {
      
      double signalValue = SignalProcessor(signal: signal).extractValue(base64String);
      // Send the processed data (vehicle speed) to the isolate
      if (signlaIsolate == null) {
        //debugPrint("Spawning new isolate for speed updates...");
        Isolate.spawn(
          SignalProcessor(signal: signal).processSpeedData,
           signalValue,
        ).then((isolate) {
          signlaIsolate = isolate;
          //debugPrint("Isolate spawned successfully.");
        }).catchError((error) {
          //debugPrint("Error spawning isolate: $error");
        });
      } else {
        //debugPrint("Sending processed data to existing isolate: $vehicleSpeedValue");
        signalReceivePort.sendPort.send(signalValue);
      }
    } catch (e) {
      //debugPrint("Error decoding data frame: $e");
    }
  }
}
