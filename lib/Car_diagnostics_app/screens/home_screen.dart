import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/configs/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Create a class for Speedometer. Making it extends StatefulWidget because the vehicle speed value will change over time.
class Speedometer extends StatefulWidget {
  const Speedometer({super.key});

  @override
  _SpeedometerState createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  //Initialize the Supabase client, the Supabase_Url and Supabase_Anon_Key is stored in .env file
  final SupabaseClient _supabase = Supabase.instance.client;

  //Define a Variable for vehicle current speed and initialize it wtih 0.
  double currentSpeed = 0.0;

  //Define a list for storing different data types, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];

  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;
  //Define speedisolate that will be initialized later when accessed for accessing vehicle speed data
  late Isolate speedisolate;
  //Define Receive port for the speed value that will be used to return the value of the vehicle speed to the main isolate of the program
  late ReceivePort speedReceivePort;
  @override
  void initState() {
    super.initState();
    fetchDataFrame();
  }

  /// @brief:   Function for fetching data frame by querying the data_frame column from the car_logs table
  ///           Using Future class, because we have asynchronous computation which need to wait for something external to the program
  ///           such as querying a database in our case
  ///
  /// @retval:  Void Function
  Future<void> fetchDataFrame() async {
    ///Receiving the data from the data_frame column in car_logs table
    ///Using await operation to delay execution until anohter synchronous computation has a result.
    final response = await _supabase.from('car_logs').select('data_frame');
    //Storing the whole data frame in a dynamic list
    dataFrame = response as List<dynamic>;
    startSpeedIsolate();
  }

// Starting the Isolate specified for updating vehicle speed data
  void startSpeedIsolate() {
    //ReceivePort receivePort = ReceivePort();
    speedReceivePort = ReceivePort();
    speedReceivePort.listen((speedData) {
      setState(() {
        currentSpeed = speedData as double;
      });
    });

    //Spawning the vehicle speed isolate
    Isolate.spawn(
      updateSpeedData,
      [dataFrame, speedReceivePort.sendPort],
    );
  }

  /// @brief:   Function for updating vehicle speed value when iteration through rows.
  ///           This is achieved by decoding the encoded current data frame, then accessing the 8th byte and convert it to double
  ///
  /// @retval:  Void Function
  static void updateSpeedData(List<Object> args) {
    int speedHexIndex = 14; // The hex index position for speed (e.g., 14 for '9c' in "3b3740fa75f27a9c")
    List<dynamic> data = args[0] as List<dynamic>;
    SendPort sendPort = args[1] as SendPort;
    int index0 = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      // Decode the base64-encoded data_frame and convert to hex format
      String base64String = data[index0]['data_frame'];
      List<int> bytes = base64.decode(base64String);
      String hexDataFrame =
          bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

      // Access speed from specified hex index
      String speedHexValue =
          hexDataFrame.substring(speedHexIndex, speedHexIndex + 2);
      int speedValue = int.parse(speedHexValue, radix: 16);

      // Send the speed value as a double (convert or map to the appropriate range as needed)
      sendPort.send(speedValue.toDouble());

      // Move to the next data frame
      index0 = (index0 + 1) % data.length;
    });
  }

  @override
  void dispose() {
    speedisolate.kill(priority: Isolate.immediate);
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

    return Center(
      child: SfRadialGauge(
        ///Initializing a Radial Guage with its specifications
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 255,
            showLabels: true,
            showTicks: true,
            axisLineStyle: AxisLineStyle(
              thickness: 20,
              cornerStyle: CornerStyle.bothCurve,
              color: Colors.grey[800],
              thicknessUnit: GaugeSizeUnit.logicalPixel,
            ),

            ///Initializing range pointer of the radial guage with its specification
            pointers: <GaugePointer>[
              RangePointer(
                value: currentSpeed,
                width: 20,
                gradient: const SweepGradient(
                  ///Make the range pointer a mix with three colours to beautify the design
                  colors: [Colors.cyan, Colors.blueAccent, Colors.purple],
                  stops: [0.0, 0.5, 1.0],
                ),
                cornerStyle: CornerStyle.bothCurve,
              ),

              ///Initializing the Needle pointer to point to the current speed value and configure its specifications
              NeedlePointer(
                value: currentSpeed,
                needleLength: 0.9,
                enableAnimation: true,
                animationType: AnimationType.ease,
                needleStartWidth: 0,
                needleEndWidth: 5,
                needleColor: Colors.white,
                knobStyle: const KnobStyle(
                  knobRadius: 0.07,
                  color: Colors.blueAccent,
                ),
              ),
            ],

            ///Positioning the Guage annotation and specify its format and style
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      currentSpeed.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: speedColor,
                      ),
                    ),
                    const Text(
                      'km/h',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
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
    );
  }
}

class TemperatureGauge extends StatefulWidget {
  const TemperatureGauge({super.key});
  @override
  _TemperatureGaugeState createState() => _TemperatureGaugeState();
}

class _TemperatureGaugeState extends State<TemperatureGauge> {
  double currentTemperature = 0.0;
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> dataFrame = [];
  late Isolate temperatureIsolate;
  late ReceivePort temperatureReceivePort;

  @override
  void initState() {
    super.initState();
    fetchDataFrame();
  }

  Future<void> fetchDataFrame() async {
    final response = await _supabase.from('car_logs').select('data_frame');
    dataFrame = response as List<dynamic>;
    startTemperatureIsolate();
  }

  void startTemperatureIsolate() {
    temperatureReceivePort = ReceivePort();
    temperatureReceivePort.listen((tempData) {
      setState(() {
        currentTemperature = tempData as double;
      });
    });
    Isolate.spawn(
      updateTemperatureData,
      [dataFrame, temperatureReceivePort.sendPort],
    );
  }

  static void updateTemperatureData(List<Object> args) {
   
    int tempCoolantHexIndex = 12; // Specify the correct hex index position for speed (e.g., 14 for '9c' in "3b3740fa75f27a9c")
    List<dynamic> data = args[0] as List<dynamic>;
    SendPort sendPort = args[1] as SendPort;
    int index1 = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      // Decode the base64-encoded data_frame and convert to hex format
      String base64String = data[index1]['data_frame'];
      List<int> bytes = base64.decode(base64String);
      String hexDataFrame =
          bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

      // Access speed from specified hex index
      String tempCoolantHexValue =
          hexDataFrame.substring(tempCoolantHexIndex, tempCoolantHexIndex + 2);
      int tempCoolantValue = (int.parse(tempCoolantHexValue, radix: 16) - 40);

      // Send the speed value as a double (convert or map to the appropriate range as needed)
      sendPort.send(tempCoolantValue.toDouble());

      // Move to the next data frame
      index1 = (index1 + 1) % data.length;
    });
  }

  @override
  void dispose() {
    temperatureIsolate.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gaugeSize = constraints.maxWidth *
            0.8; // Adjust gauge size based on screen width

        return Center(
          child: Container(
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
                      tailStyle: TailStyle(
                        length: 0.18,
                        width: 8,
                        color: Colors.black,
                        lengthUnit: GaugeSizeUnit.factor,
                      ),
                      needleLength: 0.5,
                      needleStartWidth: 1,
                      needleEndWidth: 8,
                      knobStyle: KnobStyle(
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

  Color getTemperatureColor() {
    if (currentTemperature <= 85) {
      return Colors.green;
    } else if (currentTemperature <= 170) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

class FuelGauge extends StatefulWidget {
  const FuelGauge({super.key});

  @override
  _FuelGaugeState createState() => _FuelGaugeState();
}

class _FuelGaugeState extends State<FuelGauge> {
  double currentFuelLevel = 0.0;
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> dataFrame = [];
  late Isolate fuelIsolate;
  late ReceivePort fuelReceivePort;

  @override
  void initState() {
    super.initState();
    fetchDataFrame();
  }

  Future<void> fetchDataFrame() async {
    final response = await _supabase.from('car_logs').select('data_frame');
    dataFrame = response as List<dynamic>;
    startFuelIsolate();
  }

  void startFuelIsolate() {
    fuelReceivePort = ReceivePort();
    fuelReceivePort.listen((fuelData) {
      setState(() {
        currentFuelLevel = fuelData as double;
      });
    });
    Isolate.spawn(
      updateFuelData,
      [dataFrame, fuelReceivePort.sendPort],
    );
  }

  static void updateFuelData(List<Object> args) {
    int fuelByteIndex = 4; // Index for fuel data in the data_frame
    List<dynamic> data = args[0] as List<dynamic>;
    SendPort sendPort = args[1] as SendPort;
    int index1 = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      String base64String = data[index1]['data_frame'];
      List<int> bytes = base64.decode(base64String);
      double fuelLevel = bytes[fuelByteIndex].toDouble();

      sendPort.send(fuelLevel);
      index1 = (index1 + 1) % data.length;
    });
  }

  @override
  void dispose() {
    fuelIsolate.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gaugeSize = constraints.maxWidth * 0.8;

        return Center(
          child: Container(
            width: gaugeSize,
            height: gaugeSize,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  startAngle: 150,
                  endAngle: 30,
                  radiusFactor: 2.0,
                  labelsPosition: ElementsPosition.outside,
                  ticksPosition: ElementsPosition.outside,
                  axisLabelStyle: const GaugeTextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  majorTickStyle: const MajorTickStyle(
                      length: 0.1,
                      thickness: 2,
                      lengthUnit: GaugeSizeUnit.factor),
                  minorTickStyle: const MinorTickStyle(
                      length: 0.05,
                      thickness: 1.5,
                      lengthUnit: GaugeSizeUnit.factor),
                  axisLineStyle: const AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
                  ranges: <GaugeRange>[
                    
                    GaugeRange(
                      startValue: 0,
                      endValue: 25,
                      color: Colors.red,
                      startWidth: 0.1,
                      endWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                    GaugeRange(
                      startValue: 25,
                      endValue: 50,
                      color: Colors.orange,
                      startWidth: 0.1,
                      endWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                    GaugeRange(
                      startValue: 50,
                      endValue: 75,
                      color: Colors.yellow,
                      startWidth: 0.1,
                      endWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                    GaugeRange(
                      startValue: 75,
                      endValue: 100,
                      color: Colors.green,
                      startWidth: 0.1,
                      endWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: currentFuelLevel,
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      needleColor: Colors.black,
                      tailStyle: TailStyle(
                        length: 0.18,
                        width: 8,
                        color: Colors.black,
                        lengthUnit: GaugeSizeUnit.factor,
                      ),
                      needleLength: 0.5,
                      needleStartWidth: 1,
                      needleEndWidth: 8,
                      knobStyle: KnobStyle(
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
                          Text(
                            '${(currentFuelLevel * 0.392156862745098).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: gaugeSize * 0.2,
                              fontWeight: FontWeight.bold,
                              color: getFuelColor(),
                            ),
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

  Color getFuelColor() {
    if (currentFuelLevel < 25) return Colors.red;
    if (currentFuelLevel < 50) return Colors.orange;
    if (currentFuelLevel < 75) return Colors.yellow;
    return Colors.green;
  }
}

class BottomCardGrid extends StatefulWidget {
  const BottomCardGrid({super.key});
  @override
  State<BottomCardGrid> createState() => _BottomCardGridState();
}

class _BottomCardGridState extends State<BottomCardGrid> {
  double fuelLevel = 80;

  // Example fuel level in percentage
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GridView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screenWidth * 0.05,
            mainAxisSpacing: screenHeight * 0.02,
            childAspectRatio: 0.8,
          ),
          children: [
            // Temperature Card
            Card(
              color: Colors.grey[850],
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Engine',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Coolant Temp ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Flexible(child: Center(child: TemperatureGauge())),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Fuel Level Card
            Card(
              color: Colors.grey[850],
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Fuel Level',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Flexible(child: Center(child: FuelGauge())),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 50,
                      splashRadius: 25,
                      onPressed: () {},
                      icon: Icon(Icons.menu_rounded, color: kPrimaryColor),
                    ),
                    Spacer(),
                    Stack(
                      children: [
                        IconButton(
                          iconSize: 50,
                          splashRadius: 25,
                          onPressed: () {},
                          icon: FittedBox(
                              child: Icon(Icons.account_circle_rounded)),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Dashboard ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 35),
                child: Text(
                  'MODEL 0',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w200),
                ),
              ),
              Image.asset(
                  'lib/Car_diagnostics_app/images/normal_car_front_view.png'),
              const Speedometer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      'lib/Car_diagnostics_app/images/lighting.svg'),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Current Speed ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const BottomCardGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
//I try to make the following two cards in a grid view in the bottom of the screen with reasonable padding that fit in all screens, regenerate the code to make it applicable 