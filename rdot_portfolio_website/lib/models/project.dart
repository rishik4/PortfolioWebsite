import 'package:flutter/material.dart';
import '../screens/icog_detail_page.dart';

class Project {
  final String title;
  final String description;
  final String longDescription;
  final List<String> achievements;
  final List<String> technologies;
  final String imageUrl;
  final bool isCustom;
  final Widget Function(BuildContext)? detailPageBuilder;

  const Project({
    required this.title,
    required this.description,
    required this.longDescription,
    required this.achievements,
    required this.technologies,
    required this.imageUrl,
    this.isCustom = false,
    this.detailPageBuilder,
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
    ),
    const Project(
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
    ),
    const Project(
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
    ),
    const Project(
      title: 'Debate Timer App',
      description:
          'App to time, record, and improve debater performances, part of Rdot Apps with over 9k users across 5 apps.',
      longDescription:
          'A specialized timing application designed for debate competitions, featuring performance recording and analysis tools. Part of the successful Rdot Apps suite, which has garnered over 9,000 users across its various applications.',
      achievements: [
        'Created intuitive timing interface for debate rounds',
        'Implemented performance recording and playback features',
        'Developed analytics for speech improvement',
        'Achieved significant user adoption within debate community'
      ],
      technologies: ['Flutter', 'Dart', 'Firebase'],
      imageUrl: 'https://via.placeholder.com/300x150',
    ),
  ];
}
