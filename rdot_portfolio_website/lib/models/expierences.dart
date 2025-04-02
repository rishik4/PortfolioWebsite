class Experience {
  final String title;
  final String organization;
  final String duration;
  final List<String> responsibilities;
  final List<String>? technologies;

  const Experience({
    required this.title,
    required this.organization,
    required this.duration,
    required this.responsibilities,
    this.technologies,
  });

  // All experiences data
  static const List<Experience> experiences = [
    Experience(
      title: 'Hardware-Software Integration Engineer',
      organization: 'Longhorn Neurotech',
      duration: 'Aug 2024 – Present',
      responsibilities: [
        'Developed wireless communication protocols (Wi-Fi, BLE, Radio) to integrate EEG and EMG signals with ESP32 microcontrollers for controlling a robotic rover',
        'Implemented UDP communication to ensure real-time command transmission with minimal latency',
        'Collaborated across interdisciplinary teams (EEG/EMG, Electrical, Mechanical) to design, build, and troubleshoot the rover, addressing technical issues such as signal drift and connectivity'
      ],
      technologies: ['ESP32', 'Wi-Fi', 'BLE', 'Radio', 'UDP', 'EEG/EMG'],
    ),
    Experience(
      title: 'Polaris Flight Controller Designer',
      organization: 'Longhorn Rocketry Association',
      duration: 'Aug 2024 – Present',
      responsibilities: [
        'Designed, prototyped, and manufactured the Polaris Flight Controller PCB for high-powered rocketry, prioritizing cost-efficiency, reliability, and compact design',
        'Created detailed schematics and performed component sourcing to ensure affordability and reliability',
        'Collaborated with interdisciplinary teams to integrate the flight controller seamlessly into rocket systems, significantly enhancing mission reliability and data acquisition capabilities'
      ],
      technologies: [
        'PCB Design',
        'Hardware Design',
        'Component Sourcing',
        'Flight Systems'
      ],
    ),
    Experience(
      title: 'Programming Lead',
      organization: 'FIRST Robotics (Howdy Bots)',
      duration: 'Jan 2015 – Aug 2024',
      responsibilities: [
        'Divided up tasks and led sub-teams in a community robotics group, achieving division finalist at the World Championship',
        'Programmed and developed the smallest competition legal FRC robot (Short Stack)',
        'Created a custom FRC Dashboard using LabVIEW, to clean up the driver interface; showing only relevant and important information to monitor and control the robot\'s motors and sensors',
        'Helped organize fundraising efforts (\$250k+) with events and found sponsors to sufficiently self-raise the operations of a robotics team without any school funding',
        'Designed and built various prototypes including a shooter prototype to eject balls with a high arc over 25 meters'
      ],
      technologies: [
        'LabVIEW',
        'FRC',
        'Robotics',
        'Project Management',
        'Fundraising'
      ],
    ),
  ];
}
