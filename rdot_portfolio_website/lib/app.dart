import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/portfolio_home.dart';

/// Custom scroll behavior to enable smooth scrolling on web and desktop
class SmoothScrollBehavior extends MaterialScrollBehavior {
  const SmoothScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDOT Portfolio',
      debugShowCheckedModeBanner: false,
      // Added smooth scrolling behavior
      scrollBehavior: const SmoothScrollBehavior(),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Color(0xFF666666),
          background: Colors.black,
          surface: Color(0xFF1A1A1A),
        ),
        textTheme: GoogleFonts.spaceMonoTextTheme().copyWith(
          bodyLarge: const TextStyle(
            letterSpacing: 0.5,
            height: 1.2,
            color: Colors.cyanAccent,
          ),
        ),
        useMaterial3: true,
      ),
      home: const PortfolioHome(),
    );
  }
}
