import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/battery_soh.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/tire_pressure.dart';
import 'package:flutter/material.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/configs/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    iconSize: 30,
                    splashRadius: 25,
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    )),
                const Text(
                  'Vehicle Status',
                  style: TextStyle(fontSize: 25),
                ),
                const Spacer(),
                const Text(
                  'MODEL 0',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'Orbitron'),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: kCardGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 600,
                    child: Stack(
                      children: [
                        const Positioned(
                          top: 0,
                          left: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tires Pressure',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                'Recommended: Front 35 psi | Rear 35 psi',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 145, 144, 144)),
                              )
                            ],
                          ),
                        ),
                        // Positioned(
                        //   top: 0,
                        //   right: 0,
                        //   child: Container(
                        //     decoration: const BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         gradient: buttonGradient),
                        //     child: IconButton(
                        //       iconSize: 35,
                        //       onPressed: () {},
                        //       icon: const Icon(
                        //         Icons.replay_rounded,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: SizedBox(
                              width: 350,
                              height: 650,
                              child: Stack(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 650,
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            const Positioned(
                                              top: 100,
                                              right: 40,
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: CustomRipple(),
                                              ),
                                            ),
                                            const Positioned(
                                              top: 115,
                                              right: 55,
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: CustomRipple(),
                                              ),
                                            ),
                                            //Text for car tire pressure
                                            const Positioned(
                                              top: 50,
                                              right: 0.5,
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: TirePressure(),
                                              ),
                                            ),
                                            const Positioned(
                                              top: 50,
                                              left: 0.5,
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: TirePressure(),
                                              ),
                                            ),
                                            const Positioned(
                                              bottom: 50,
                                              left: 0.5,
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: TirePressure(),
                                              ),
                                            ),
                                            const Positioned(
                                              bottom: 50,
                                              right: 0.5,
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: TirePressure(),
                                              ),
                                            ),

                                            const Positioned(
                                                top: 100,
                                                left: 40,
                                                child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: CustomRipple())),
                                            const Positioned(
                                                top: 115,
                                                left: 55,
                                                child: SizedBox(
                                                    width: 70,
                                                    height: 70,
                                                    child: CustomRipple())),
                                            const Positioned(
                                                bottom: 100,
                                                right: 40,
                                                child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: CustomRipple())),
                                            const Positioned(
                                                bottom: 115,
                                                right: 55,
                                                child: SizedBox(
                                                    width: 70,
                                                    height: 70,
                                                    child: CustomRipple())),
                                            const Positioned(
                                                bottom: 100,
                                                left: 40,
                                                child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: CustomRipple())),
                                            const Positioned(
                                              bottom: 115,
                                              left: 55,
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: CustomRipple(),
                                              ),
                                            ),
                                            Positioned(
                                              child: Image.asset(
                                                'lib/Car_diagnostics_app/images/bird_view_tesla.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  const Text(
                    'Battery Health',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BatterySoh(),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text('Sensors',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Sensor(
                        sensorWidth: 60,
                        heigth: 120,
                        value: 0.8,
                        label: 'Motors',
                      ),
                      Sensor(
                        sensorWidth: 60,
                        heigth: 120,
                        value: 0.4,
                        label: 'Batery Temp',
                      ),
                      Sensor(
                        sensorWidth: 60,
                        heigth: 120,
                        value: 0.9,
                        label: 'Brakes',
                      ),
                      Sensor(
                        sensorWidth: 60,
                        heigth: 120,
                        value: 0.6,
                        label: 'Suspentions',
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Sensor extends StatelessWidget {
  const Sensor({
    super.key,
    required this.value,
    required this.label,
    required this.heigth,
    required this.sensorWidth,
  });

  final double value;
  final double heigth;
  final String label;
  final double sensorWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: sensorWidth,
              height: heigth,
              color: kProgressBackGroundColor.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: heigth * value,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            colors: buttonGradient.colors)),
                  )
                ],
              ),
            )),
        const SizedBox(
          height: 5,
        ),
        Text(label)
      ],
    );
  }
}

class CustomRipple extends StatefulWidget {
  const CustomRipple({super.key});

  @override
  State<CustomRipple> createState() => _CustomRippleState();
}

class _CustomRippleState extends State<CustomRipple>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween<double>(begin: 0.4, end: 0.8).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 8),
            shape: BoxShape.circle),
      ),
    );
  }
}
