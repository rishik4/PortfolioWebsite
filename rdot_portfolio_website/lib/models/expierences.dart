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
      title: 'Member',
      organization: 'IEEE',
      duration: 'Aug 2024 – Present',
      responsibilities: [
        'Participated in IEEE activities and events focused on advancing technology and engineering', // Placeholder
        'Collaborated with peers on projects or initiatives related to electrical and electronics engineering', // Placeholder
        'Engaged in professional development and networking opportunities' // Placeholder
      ],
      technologies: ['Electrical Engineering', 'Networking'], // Placeholder
    ),
    Experience(
      title: 'Programming Lead',
      organization: 'FIRST Robotics (Howdy Bots)',
      duration: 'Jan 2015 – May 2024',
      responsibilities: [
        'Programmer for a community-based robotics team that made it to division finalists at the World Championship',
        'Programmed and developed the smallest competition legal FRC robot (Short Stack)',
        'Created a custom FRC Dashboard using LabVIEW, to clean up the driver interface; showing only relevant and important information to monitor and control the robot’s motors and sensors',
        'Helped organize fundraising efforts with events and found sponsors to sufficiently self-raise the operations of a robotics team without any school funding',
        'Divided up tasks and led different sub-teams to explore and design various prototypes',
        'Designed and built various parts of the robot including a shooter prototype to eject balls with a high-arc',
        'Developed an algorithm to calculate the velocity of a shooter given the distance away from the target while accounting for robot movement using math and physics skills'
      ],
      technologies: [
        'LabVIEW',
        'FRC',
        'Robotics',
        'Math/Physics',
        'Project Management',
        'Fundraising'
      ],
    ),
    Experience(
      title: 'Captain',
      organization: 'Westwood Debate (Public Forum)',
      duration: 'Aug 2020 – May 2024',
      responsibilities: [
        'Qualified for state and national tournaments, and led our team to achieve a high ranking at both levels',
        'Designed and implemented lesson plans and drills to improve team performance',
        'Cultivated a strong culture around the program, building a sense of belonging by building traditions and organizing events',
        'Researched current events, preparing cases and responses against other cases for competitions',
        'Developed quick on-the-spot decision making and found my voice to lead others'
      ],
      technologies: null,
    ),
    Experience(
      title: 'Founder and President',
      organization: 'Westwood Electronics Club',
      duration: 'Oct 2021 – May 2024',
      responsibilities: [
        'Taught students the principles of electrical engineering',
        'Communicated with school officials to find problems to create electrical solutions including a fingerprint ID bathroom pass scanner',
        'Led a club with over 30 active members'
      ],
      technologies: ['Electrical Engineering', 'Hardware Design'],
    ),
    Experience(
      title: 'Vice President',
      organization: 'Mobile App Development Club',
      duration: 'Sep 2022 – May 2024',
      responsibilities: [
        'Helped create a club that taught students the basics of app development',
        'Designed a curriculum to cover both iOS and Android coding principles',
        'Led a club with over 25 active members'
      ],
      technologies: [
        'iOS Development',
        'Android Development',
        'Curriculum Design'
      ],
    ),
    Experience(
      title: 'Sergeant at Arms',
      organization: 'Technology Student Association',
      duration: 'July 2022 – May 2024',
      responsibilities: [
        'Currently serving as the officer in charge of teaching STEM lessons in club meetings and designing activities'
      ],
      technologies: ['STEM Education'],
    ),
    Experience(
      title: 'Lead Developer',
      organization: 'Project 2 Provide',
      duration: 'June 2022 – May 2024',
      responsibilities: [
        'Helped create an app to connect volunteering organizations with volunteers',
        'Volunteered at several in-person workshops to teach elementary and middle school students basic STEM and business skills through hands-on activities',
        'Introduced kids to basic electrical design like TinkerCad and coding basics using Arduinos and LEDs',
        'Co-led the technology and engineering team',
        'Reached over 1.2k followers on Instagram'
      ],
      technologies: [
        'App Development',
        'TinkerCad',
        'Arduino',
        'STEM Education'
      ],
    ),
    Experience(
      title: 'Member',
      organization: 'National Honors Society',
      duration: 'Aug 2022 – May 2024',
      responsibilities: [
        'Member of a nationwide organization that recognizes and honors high school students who excel in scholarship, leadership, service, and character',
        'Participated in various academic, civic, and social activities and events organized by the chapter'
      ],
      technologies: null,
    ),
    Experience(
      title: 'Instructor',
      organization: 'Austin Debate Institute',
      duration: 'Aug 2022 – May 2024',
      responsibilities: [
        'Helped teach elementary and middle school students the fundamentals of debate',
        'Taught and developed lesson plans to create a comprehensive curriculum from scratch',
        'Judged practice debates and connected students with high school debate resources'
      ],
      technologies: null,
    ),
  ];
}
