import 'package:flutter/material.dart';
import '../screens/cinematch_detail_page.dart';
import '../screens/debate_timer_pro.dart';
import '../screens/icog_detail_page.dart';
import '../screens/scada.dart'; // Add import for SCADA detail page
import '../screens/pillow_alarm.dart'; // Add import for WakeSense detail page
import '../screens/breakout_board.dart'; // Add import for ESP32 breakout board detail page

class Project {
  final String title;
  final String description;
  final String longDescription;
  final List<String> achievements;
  final List<String> technologies;
  final String imageUrl;
  final bool isCustom;
  final Widget Function(BuildContext)? detailPageBuilder;
  final String type; // Add type property for filtering

  const Project({
    required this.title,
    required this.description,
    required this.longDescription,
    required this.achievements,
    required this.technologies,
    required this.imageUrl,
    this.isCustom = false,
    this.detailPageBuilder,
    required this.type, // Add to constructor
  });

  // All projects data
  static List<Project> projects = [
    Project(
      title: 'iCog Dementia Screening App',
      description:
          'Online app for early-stage dementia screening used by over 13k users in 83 countries. Partnered with Mini-Cog and recognized in national competitions; research publication in progress.',
      longDescription:
          'An innovative mobile application designed to provide early-stage dementia screening, making healthcare more accessible to people worldwide. The app has been successfully adopted by over 13,000 users across 83 countries, demonstrating its global impact and usability.',
      achievements: [
        'Developed a user-friendly interface for conducting cognitive assessments',
        'Implemented secure data storage and analysis systems',
        'Established partnership with Mini-Cog for validated screening methods',
        'Achieved recognition in national competitions',
        'Currently working on research publication'
      ],
      technologies: ['Flutter', 'Firebase', 'AI/ML', 'Google Cloud'],
      imageUrl:
          'https://i.ytimg.com/vi/3D-XUG3nF6Q/hq720.jpg?sqp=-oaymwEnCNAFEJQDSFryq4qpAxkIARUAAIhCGAHYAQHiAQoIGBACGAY4AUAB&rs=AOn4CLBvH3LT7H3hYB8YsHsS90A6KTEjEQ',
      isCustom: true,
      detailPageBuilder: (context) => const ICogDetailPage(),
      type: 'software',
    ),
    Project(
      title: 'CineMatch Pro',
      description:
          'Movie seat finder and auto-booking app that finds optimal cinema seating and automatically books tickets when they become available.',
      longDescription:
          'A breakthrough movie app designed to help users find the best movie theater seats and book them automatically. Using advanced algorithms, it analyzes seating layouts to recommend the optimal viewing experience.',
      achievements: [
        'Developed seat scoring algorithm to identify best viewing positions',
        'Created auto-booking system for ticket release dates',
        'Implemented multi-theater search to compare options',
        'Built user preference system for personalized recommendations',
        'Designed simple, intuitive user interface'
      ],
      technologies: ['Flutter', 'Firebase', 'Web Scraping', 'Google Cloud'],
      imageUrl: 'https://via.placeholder.com/300x150',
      isCustom: true,
      detailPageBuilder: (context) => CineMatchDetailPage(),
      type: 'software',
    ),
    Project(
      title: 'Debate Timer Pro',
      description:
          'Specialized timer app for debaters with format-specific presets, integrated speech recording, and customizable alerts. Available on iOS and Android, used by schools and debate teams nationwide.',
      longDescription:
          'A comprehensive debate timing application designed to help debaters manage speaking times across various formats. With integrated recording capabilities and intuitive controls, the app allows debaters to focus on their arguments rather than timekeeping.',
      achievements: [
        'Created format-specific timers for Policy, Public Forum, and Lincoln-Douglas debates',
        'Implemented speech recording and analysis tools for performance improvement',
        'Designed a distraction-free, user-friendly interface for competitive environments',
        'Adopted by over 200 high schools and colleges for debate programs',
        'Maintains 5/5 star rating on app stores with positive user feedback'
      ],
      technologies: ['Flutter', 'Dart', 'Native Audio APIs', 'Local Storage'],
      imageUrl: 'https://via.placeholder.com/300x150',
      isCustom: true,
      detailPageBuilder: (context) => const DebateTimerDetailPage(),
      type: 'software',
    ),
    Project(
      title: 'Smart Energy Monitor & Light Switch',
      description:
          'SCADA system measuring household appliance energy consumption with a custom PCB prototype and plans for large-scale production.',
      longDescription:
          'A comprehensive SCADA (Supervisory Control and Data Acquisition) system designed to monitor and analyze energy consumption of household appliances. The project includes custom PCB design and prototyping, with scalability in mind for potential mass production.',
      achievements: [
        'Designed and manufactured custom PCB for energy monitoring',
        'Implemented real-time data collection and analysis',
        'Developed user interface for monitoring energy consumption',
        'Created scalable architecture for future production'
      ],
      technologies: ['IoT', 'PCB Design', 'Embedded Systems'],
      imageUrl: 'https://via.placeholder.com/300x150',
      type: 'hardware',
      isCustom: true, // Change to true to use custom detail page
      detailPageBuilder: (context) =>
          const ScadaDetailPage(), // Add custom detail page
    ),
    Project(
      title: 'WakeSense Smart Pillow Alarm',
      description:
          'Smart pillow alarm using pressure sensors to track sleep quality and wake individuals with hearing impairments, connected via Flutter app.',
      longDescription:
          'An innovative smart pillow system designed to assist individuals with hearing impairments. The system uses pressure sensors to monitor sleep patterns and provides tactile wake-up alerts, all managed through a custom Flutter application.',
      achievements: [
        'Integrated pressure sensors for sleep tracking',
        'Developed Flutter app for alarm control and sleep analysis',
        'Implemented Bluetooth connectivity for device communication',
        'Created adaptive wake-up algorithms based on sleep patterns'
      ],
      technologies: ['Flutter', 'Firebase', 'IoT'],
      imageUrl: 'https://via.placeholder.com/300x150',
      type: 'hardware',
      isCustom: true, // Change to true to use custom detail page
      detailPageBuilder: (context) =>
          const WakeSenseDetailPage(), // Add custom detail page
    ),
    Project(
      title: 'ESP32 Custom Breakout Board',
      description:
          'Custom-designed PCB with enhanced I/O, power management, and specialized connectivity for ESP32-based IoT development.',
      longDescription:
          'A custom ESP32 breakout board designed to address the limitations of standard development boards by providing robust power regulation, expanded GPIO capabilities, and specialized connectors for rapid prototyping and integration into larger systems.',
      achievements: [
        'Designed complete schematic and PCB layout from scratch',
        'Implemented multi-source power management with battery support',
        'Created specialized I/O protection for robust operation',
        'Optimized design for manufacturability and reliability'
      ],
      technologies: ['PCB Design', 'EasyEDA/Altium', 'ESP32', 'Electronics'],
      imageUrl: 'https://via.placeholder.com/300x150',
      type: 'hardware',
      isCustom: true,
      detailPageBuilder: (context) => const ESP32BreakoutDetailPage(),
    ),
  ];
}
