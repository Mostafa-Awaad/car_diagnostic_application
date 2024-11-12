import 'dart:convert';
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
  //Define a list for storing speedData, which stores any type of data whether int or double.
  List<dynamic> dataFrame = [];
  //Define a variable for storing current index for the current row in the car_logs table.
  int currentIndex = 0;

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

    setState(() {
      //Storing the whole data frame in a dynamic list
      dataFrame = response as List<dynamic>;
    });
    updateSpeed();
    
  }

  /// @brief:   Function for updating vehicle speed value when iteration through rows. 
  ///           This is achieved by decoding the encoded current data frame, then accessing the 8th byte and convert it to double
  ///
  /// @retval:  Void Function
  void updateSpeed() {
    if (dataFrame.isNotEmpty) {
      setState(() {
        String base64String = dataFrame[currentIndex]['data_frame'];
        List<int> bytes = base64.decode(base64String);
        currentSpeed = bytes[7].toDouble();
        // Ensures continous loop, once the current index reaches the end, it wraps back to 0
        currentIndex = (currentIndex + 1) % dataFrame.length;
      });
      //Delay 1 second between two consecutive readings
      Future.delayed(const Duration(seconds: 1), updateSpeed);
    }
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
                animationType: AnimationType.easeOutBack,
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double temperature = 20; // Example temperature value
    double fuelLevel = 80; // Example fuel level in percentage

    // Set the text color based on the temperature
    Color temperatureColor =
        temperature > 30 ? Colors.redAccent.shade200 : Colors.teal;

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
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
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
                    child: Text(
                      'Current Speed',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: kCardColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.teal,
                                    Colors.redAccent.shade200
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  'Temperature',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [Colors.grey, Colors.blueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  'Cabin',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: temperature.toStringAsFixed(0),
                                        style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: temperatureColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Transform.translate(
                                          offset: Offset(0, -12),
                                          child: Text(
                                            '°C',
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: temperatureColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Card(
                      color: kCardColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [Colors.redAccent, Colors.teal],
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
                              // Text(
                              //   'Remaining',
                              //   style: TextStyle(fontSize: screenWidth * 0.04),
                              // ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  '${fuelLevel.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: fuelLevel > 30
                                        ? Colors.teal
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
