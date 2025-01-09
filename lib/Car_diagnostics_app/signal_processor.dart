import 'dart:async';
import 'dart:convert';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/model/vehicle_data_signal.dart';

class SignalProcessor {
  SignalProcessor({required this.signal});
  final VehicleDataSignal signal;

  /// Decode the base64 data and extract the signal value
  double extractValue(String base64String) {
    try {
      // Decode base64 string to bytes
      List<int> bytes = base64.decode(base64String);

      // Convert bytes to a hex string
      String hexDataFrame =
          bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

      // Extract the signal's hex value from the hexDataFrame
      String hexValue =
          hexDataFrame.substring(signal.hexIndex, signal.hexIndex + 2);

      // Convert hex value to decimal, apply scaling and offset
      return int.parse(hexValue, radix: 16) * signal.scale + signal.offset;
    } catch (e) {
      //print("Error extracting value for signal $signal.name: $e");
      return 0.0; // Return a default value on error
    }
  }

  void processSpeedData(double vehicleSpeedValue) {
    
    try {
      // Simulate periodic updates back to the main thread
      Timer.periodic(const Duration(seconds: 2), (timer) {
        //debugPrint("Sending processed speed back to main thread: $vehicleSpeedValue");
      });
    } catch (e) {
      //debugPrint("Error in isolate: $e");
    }
  }
}
