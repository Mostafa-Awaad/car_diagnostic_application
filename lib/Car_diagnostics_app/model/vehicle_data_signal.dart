enum VehicleDataSignalName {
  vehicleSpeed,
  coolantTemp,
  fuelLevel,
  carTirePressure,
  batteryStateOfHealth,
  batteryStateOfCharge,
  distanceTraveled,
}

class VehicleDataSignal {
  VehicleDataSignal({
    required this.name,
    required this.hexIndex,
    required this.scale,
    required this.offset,
    required this.unit,
  });

  final VehicleDataSignalName name; // Name of the signal
  final int hexIndex; // Hex index for the signal value
  final double scale; // Scaling factor
  final double offset; // Offset
  final String unit; // Unit of the signal value (e.g., km/h, °C)
}
