import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/card_grid_home_screen.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/widgets/speedometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/configs/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                      icon: const Icon(Icons.menu_rounded, color: kPrimaryColor),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        IconButton(
                          iconSize: 50,
                          splashRadius: 25,
                          onPressed: () {},
                          icon: const FittedBox(
                              child: Icon(Icons.account_circle_rounded)),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
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
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'Dashboard ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 35),
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
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
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
