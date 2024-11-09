import 'package:flutter/material.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/configs/colors.dart';
import 'package:demo_car_diagnostic_application/Car_diagnostics_app/screens/settings_screen.dart';
import 'home_screen.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Bottom navigation icon with gradient(Mix of Colors) effect
  Widget _bottomAppBarIcon({required int index, required IconData icon}) {
    bool isSelected = _selectedIndex == index;

    return IconButton(
      onPressed: () {
        navigateTo(index);
      },
      icon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return isSelected
              ? LinearGradient(
                  colors: [Colors.blue, Color(0xFF7209B7)], // Blue-purple gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds)
              : LinearGradient(
                  colors: [Colors.grey[400]!, Colors.grey[500]!],
                ).createShader(bounds);
        },
        child: Icon(
          icon,
          color: Colors.white, // Set white to apply gradient from ShaderMask
          size: isSelected ? 36 : 30, // Larger size for selected icon
        ),
      ),
      iconSize: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Color(0xFF1B1B1F),
        child: SafeArea(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                //For changing the color of the bottom navigation bar
                colors: [Colors.blueGrey.withOpacity(0.8), Colors.black.withOpacity(0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              //The Radius for of the borders of the navigation bar
              borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
            
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAppBarIcon(index: 0, icon: Icons.home_rounded),
                _bottomAppBarIcon(index: 1, icon: Icons.bar_chart_rounded),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple], // Blue-purple gradient for power button
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            iconSize: 60,
                            onPressed: () {},
                            icon: Icon(
                              Icons.power_settings_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _bottomAppBarIcon(index: 2, icon: Icons.settings),
                _bottomAppBarIcon(index: 3, icon: Icons.account_circle_rounded),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: kBackGroundGradient,
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // List of Widgets each widget represents a page
            // Navigation to different pages (HomeScreen, (Container1 -> bar_chart), SettingScreen,
            // Container2 -> profile )
            HomeScreen(),
            Container(
              child: Center(
                child: Text(
                  'Page 02',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SettingsScreen(),
            Container(
              child: Center(
                child: Text(
                  'Page 04',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
