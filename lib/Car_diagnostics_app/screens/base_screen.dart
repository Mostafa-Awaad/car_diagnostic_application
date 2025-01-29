import 'package:demo_car_diagnostic_application/Car_diagnostics_app/screens/battery_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/screens/settings_screen.dart';
import 'home_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 48, 53),
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: const Color.fromARGB(255, 41, 48, 53),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Vehicle Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Stack(
                children: [
                  IconButton(
                    color: Colors.blueGrey,
                    iconSize: 40,
                    splashRadius: 25,
                    onPressed: () {},
                    icon: const FittedBox(
                        child: Icon(Icons.account_circle_rounded)),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                iconSize: 40,
                splashRadius: 25,
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded, color: Colors.blue),
              ),
            ],
          ),
        ),
        bottomNavigationBar: menu(),
        body: const TabBarView(
          children: [
            HomeScreen(),
            BatteryScreen(),
            SettingsScreen(),
            Center(
              child: Text(
                'Account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget menu() {
  return Container(
    color: const Color.fromARGB(255, 41, 48, 53),
    child: const TabBar(
      dividerHeight: 0,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.white,
      indicatorWeight: 3.0,
      tabs: [
        Tab(
          text: "Home",
          icon: Icon(
            size: 30,
            Icons.home_rounded,
          ),
        ),
        Tab(
          text: "Battery",
          icon: Icon(
            size: 30,
            Icons.battery_charging_full_rounded,
          ),
        ),
        Tab(
          text: "Status",
          icon: Icon(
            size: 30,
            Icons.settings,
          ),
        ),
        Tab(
          text: "Account",
          icon: Icon(
            size: 30,
            Icons.account_circle_rounded,
          ),
        ),
      ],
    ),
  );
}
