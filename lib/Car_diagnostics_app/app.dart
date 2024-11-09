import 'package:flutter/material.dart';
import 'screens/base_screen.dart';

// Main app widget for the Car Diagnostics application
class CarDiagnosticsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the app
      title: 'Car Diagnostics', // App title
      theme: ThemeData(
        brightness: Brightness.dark, // Sets the app theme to dark mode
        // The color of the background behind the bottom navigation bar
        scaffoldBackgroundColor: Colors.black, // Deep dark background color for the scaffold
        primaryColor: Color(0xFF00FFC6), // Primary color, a bright neon green-cyan

        // Dark color scheme for the theme, with custom primary and secondary colors
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF00FFC6), // Matches primaryColor above
          secondary: Color(0xFF29B6F6), // Neon blue used for secondary elements
          background: Color(0xFF1B1B1F), // Background color for app screens
        ),

        // Icon theme settings for general app icons
        iconTheme: IconThemeData(
          color: Colors.blueGrey, // Muted gray color for non-primary icons
          size: 30, // Larger icon size
        ),

        // Text theme settings for different text styles throughout the app
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white, // Text color for body text
            fontFamily: 'Orbitron', // Custom futuristic font if available
          ),
          titleLarge: TextStyle(
            color: Colors.white, // Title color for large text
            fontSize: 28, // Font size for large titles
            fontWeight: FontWeight.bold, // Bold weight for emphasis
            fontFamily: 'Orbitron', // Matches custom font for consistency
          ),
        ),

        // Card widget background color, with a dark shade and subtle neon effect
        cardColor: Color(0xFF1B1B1F),

        // Elevated button style settings for consistency across buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF29B6F6), // Neon blue background for buttons
            foregroundColor: Colors.black, // Text color on buttons
            textStyle: TextStyle(
              fontWeight: FontWeight.bold, // Bold font for button text
              fontSize: 18, // Larger text size for readability
              fontFamily: 'Orbitron', // Consistent font style
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded edges for button shape
            ),
            shadowColor: Color(0xFF29B6F6).withOpacity(0.5), // Neon blue shadow for a glow effect
            elevation: 15, // Elevation to enhance the shadow effect
          ),
        ),

        // AppBar (top bar) theme with custom color and text style
        appBarTheme: AppBarTheme(
          color: Colors.black, // Dark background matching the app's overall theme
          elevation: 0, // No elevation, making the AppBar flat
          iconTheme: IconThemeData(color: Color(0xFF00FFC6)), // Icon color for AppBar icons (neon green-cyan)
          titleTextStyle: TextStyle(
            color: Color(0xFF00FFC6), // Title text color in AppBar
            fontSize: 26, // Title font size in AppBar
            fontWeight: FontWeight.w700, // Bold weight for AppBar title
            fontFamily: 'Orbitron', // Matches custom font
          ),
        ),

        // Button theme settings for default button style throughout the app
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF00FFC6), // Primary color for default buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded edges for buttons
          ),
        ),
      ),
      home: BaseScreen(), // BaseScreen widget as the app's initial screen
    );
  }
}
