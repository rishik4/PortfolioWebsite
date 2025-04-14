import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class DriverMonitoringDetailPage extends StatefulWidget {
  const DriverMonitoringDetailPage({super.key});

  @override
  State<DriverMonitoringDetailPage> createState() =>
      _DriverMonitoringDetailPageState();
}

class _DriverMonitoringDetailPageState extends State<DriverMonitoringDetailPage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  final List<String> _tabs = [
    'Overview',
    'Problem',
    'Solution',
    'Hardware',
    'Software',
    'Process',
    'Results'
  ];

  // Animation controllers for sequential animations
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Number of elements to animate in each tab
  final Map<int, int> _elementsCount = {
    0: 3, // Overview tab (about, project highlights, tech stack)
    1: 2, // Problem tab (challenge, statistics)
    2: 2, // Solution tab (description, features)
    3: 3, // Hardware tab (schematic, components, installation)
    4: 2, // Software tab (architecture, interface)
    5: 3, // Process tab (design, testing, results)
    6: 2, // Results tab (data, insights)
  };

  @override
  void initState() {
    super.initState();

    // Initialize main animation controller with longer duration for sequential animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Initialize animation lists based on maximum possible elements
    _initializeAnimations(4); // Max of 4 elements in any tab

    // Start the animation for the initial tab
    _animationController.forward();
  }

  void _initializeAnimations(int maxElements) {
    _fadeAnimations = List.generate(maxElements, (index) {
      // Calculate staggered intervals (0-0.25, 0.25-0.5, 0.5-0.75, 0.75-1.0)
      final startInterval = index / maxElements;
      final endInterval = (index + 1) / maxElements;

      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(startInterval, endInterval, curve: Curves.easeOut),
      ));
    });

    _slideAnimations = List.generate(maxElements, (index) {
      return Tween<Offset>(
        begin: const Offset(0.0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(index / maxElements, (index + 1) / maxElements,
            curve: Curves.easeOut),
      ));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    if (index == _selectedTabIndex) return;

    setState(() {
      _previousTabIndex = _selectedTabIndex;
      _selectedTabIndex = index;
    });

    // Reset and start animation for the new tab
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Background effect
          AnimatedBuilder(
            animation: const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return CustomPaint(
                painter: TechBackgroundPainter(0),
                child: Container(),
                size: Size.infinite,
              );
            },
          ),

          // Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.amber),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "Driver Attention Monitoring System",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Hero section with project image
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Stack(
                      children: [
                        // Placeholder for actual device image
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black45,
                          child: const Center(
                            child: Text(
                              "[Image of Driver Monitoring System]",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        // Content with project logo/diagram
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Project Image/Logo
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                      color: Colors.amber.withOpacity(0.7)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.visibility,
                                    color: Colors.amber,
                                    size: 70,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "AI-Powered Driver Safety",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Advanced system that monitors driver alertness and provides real-time safety feedback",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                        letterSpacing: 1,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            border: Border.all(
                                              color:
                                                  Colors.amber.withOpacity(0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.notifications_active,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Drowsiness Alerts",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            border: Border.all(
                                              color:
                                                  Colors.amber.withOpacity(0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.score,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Safety Scoring",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Navigation tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        _tabs.length,
                        (index) => _buildTab(index),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.amber.withOpacity(0.3),
                  ),
                  const SizedBox(height: 40),

                  // Tab content with sequential animations
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.amber : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          _tabs[index],
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.amber : Colors.amber.withOpacity(0.6),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildProblemTab();
      case 2:
        return _buildSolutionTab();
      case 3:
        return _buildHardwareTab();
      case 4:
        return _buildSoftwareTab();
      case 5:
        return _buildProcessTab();
      case 6:
        return _buildResultsTab();
      default:
        return _buildOverviewTab();
    }
  }

  // Helper method to build animated section
  Widget _buildAnimatedSection(int index, Widget child) {
    if (index >= _fadeAnimations.length) return child; // Safety check

    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ABOUT THE SYSTEM",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The Driver Attention Monitoring System is an AI-powered safety solution designed to prevent "
                  "accidents caused by driver drowsiness and inattention. Using computer vision and machine "
                  "learning, it continuously monitors the driver's face, eyes, and head position to detect signs "
                  "of fatigue or distraction.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "When signs of drowsiness are detected, the system immediately activates alert mechanisms to "
                  "wake the driver. It also provides a real-time safety score based on attention levels, "
                  "helping drivers improve their awareness over time and creating safer roads for everyone.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProjectHighlightsCard(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TECH STACK",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTechStackGrid(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // Problem Tab
  Widget _buildProblemTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "THE CHALLENGE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Drowsy driving is a major safety issue on roads worldwide. According to the National Highway "
                  "Traffic Safety Administration (NHTSA), driver fatigue causes approximately 100,000 crashes "
                  "annually in the US alone, resulting in an estimated 1,550 deaths and 71,000 injuries. The problem "
                  "is particularly severe among commercial drivers who spend long hours on the road.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                _buildProblemCards(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DROWSY DRIVING STATISTICS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDrowsyDrivingStats(),
                const SizedBox(height: 40),
                _buildRiskFactors(),
              ],
            )),
      ],
    );
  }

  // Solution Tab
  Widget _buildSolutionTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "THE SOLUTION",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Our Driver Attention Monitoring System addresses these challenges through advanced computer "
                  "vision algorithms that continuously analyze the driver's facial features and behavior. "
                  "The system can detect early signs of drowsiness or distraction before they become dangerous, "
                  "giving drivers crucial seconds to regain alertness and maintain control of their vehicle.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "KEY FEATURES",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSolutionFeatures(),
                const SizedBox(height: 40),
                _buildSystemDiagram(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // Hardware Tab
  Widget _buildHardwareTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "HARDWARE COMPONENTS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The hardware system consists of carefully selected components that ensure reliability "
                  "and performance in the demanding automotive environment. The system is designed to be "
                  "compact, unobtrusive, and capable of withstanding temperature variations and vibrations "
                  "common in vehicles.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                _buildHardwareComponents(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SYSTEM INSTALLATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInstallationDiagram(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ALERT MECHANISMS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAlertMechanisms(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // Software Tab
  Widget _buildSoftwareTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SOFTWARE ARCHITECTURE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The software system incorporates state-of-the-art computer vision and machine learning "
                  "algorithms to detect facial features, track eye movements, and analyze driver behavior. "
                  "These powerful algorithms run efficiently on the embedded processor, enabling real-time "
                  "analysis and immediate response to signs of drowsiness or distraction.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSoftwareComponents(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "USER INTERFACE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildUserInterface(),
                const SizedBox(height: 40),
                _buildSafetyScoring(),
              ],
            )),
      ],
    );
  }

  // Process Tab
  Widget _buildProcessTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DEVELOPMENT PROCESS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The development of the Driver Attention Monitoring System followed a rigorous process "
                  "to ensure both technical excellence and practical effectiveness in real-world driving "
                  "conditions. Each stage involved extensive testing and validation with diverse drivers "
                  "and vehicles.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                _buildDevelopmentTimeline(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CHALLENGES & SOLUTIONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildChallenges(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TESTING & VALIDATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTestingProcess(),
              ],
            )),
      ],
    );
  }

  // Results Tab
  Widget _buildResultsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PERFORMANCE METRICS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The Driver Attention Monitoring System has undergone extensive real-world testing, demonstrating "
                  "exceptional performance across various driving conditions, vehicle types, and driver demographics. "
                  "The results show significant improvements in driver alertness and potential accident prevention.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                _buildPerformanceMetrics(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FUTURE ENHANCEMENTS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFutureEnhancements(),
                const SizedBox(height: 40),
                _buildContactInfo(),
              ],
            )),
      ],
    );
  }

  // Helper widgets for Overview Tab
  Widget _buildProjectHighlightsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PROJECT HIGHLIGHTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          _buildHighlightRow('Status', 'Production-Ready'),
          const SizedBox(height: 15),
          _buildHighlightRow('Detection Accuracy', '98.5% in field tests'),
          const SizedBox(height: 15),
          _buildHighlightRow('Response Time', '<300ms from detection to alert'),
          const SizedBox(height: 15),
          _buildHighlightRow('Compatibility', 'All vehicle types & conditions'),
          const SizedBox(height: 15),
          _buildHighlightRow('Power Consumption', '<2W in typical operation'),
        ],
      ),
    );
  }

  Widget _buildHighlightRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          color: Colors.amber,
          margin: const EdgeInsets.only(top: 3, right: 12),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechStackGrid() {
    final List<Map<String, dynamic>> techStack = [
      {
        'name': 'IR Camera',
        'category': 'Sensing',
        'icon': Icons.camera_alt,
      },
      {
        'name': 'TensorFlow Lite',
        'category': 'ML Framework',
        'icon': Icons.multiline_chart,
      },
      {
        'name': 'OpenCV',
        'category': 'Computer Vision',
        'icon': Icons.remove_red_eye,
      },
      {
        'name': 'Embedded CPU',
        'category': 'Processing',
        'icon': Icons.memory,
      },
      {
        'name': 'Multi-Modal Alerts',
        'category': 'Feedback',
        'icon': Icons.notifications_active,
      },
      {
        'name': 'CAN Bus Interface',
        'category': 'Vehicle Integration',
        'icon': Icons.settings_input_component,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: techStack.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                techStack[index]['icon'],
                color: Colors.amber,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                techStack[index]['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                techStack[index]['category'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.amber.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widgets for Problem Tab
  Widget _buildProblemCards() {
    final List<Map<String, dynamic>> problems = [
      {
        'title': 'Delayed Recognition',
        'description':
            'Drivers often fail to recognize their own drowsiness until it\'s too late, with reaction times already severely impaired.',
        'icon': Icons.accessibility_new,
      },
      {
        'title': 'Inadequate Breaks',
        'description':
            'Long-distance drivers frequently underestimate the need for rest breaks, pushing beyond safe limits of alertness.',
        'icon': Icons.airline_seat_recline_normal,
      },
      {
        'title': 'Night Driving Risks',
        'description':
            'Driving between midnight and 6am dramatically increases crash risk due to disruption of natural sleep cycles.',
        'icon': Icons.nightlight_round,
      },
    ];

    return Row(
      children: problems.map((problem) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  problem['icon'],
                  color: Colors.amber,
                  size: 32,
                ),
                const SizedBox(height: 15),
                Text(
                  problem['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  problem['description'],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.amber.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDrowsyDrivingStats() {
    final List<Map<String, String>> stats = [
      {
        'value': '37%',
        'label':
            'of drivers admit to having fallen asleep at the wheel at least once'
      },
      {
        'value': '4x',
        'label':
            'increased crash risk when driving while fatigued compared to well-rested'
      },
      {
        'value': '20%',
        'label':
            'of all fatal crashes involve driver drowsiness as a contributing factor'
      },
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  stat['value']!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  stat['label']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber.withOpacity(0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRiskFactors() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "RISK FACTORS & WARNING SIGNS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Warning Sign",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.amber.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          _buildRiskFactorRow(
            "Extended Blinking",
            "Eyelid closure lasting longer than 0.5 seconds, indicating microsleep onset",
          ),
          const SizedBox(height: 15),
          _buildRiskFactorRow(
            "Head Nodding",
            "Gradual downward head movement followed by sudden correction, showing momentary loss of muscle tone",
          ),
          const SizedBox(height: 15),
          _buildRiskFactorRow(
            "Reduced PERCLOS",
            "Percentage of eyelid closure over the pupil over time, a validated measure of drowsiness",
          ),
          const SizedBox(height: 15),
          _buildRiskFactorRow(
            "Lane Deviation",
            "Subtle, unconscious drift within or out of lane boundaries, indicating attention lapses",
          ),
          const SizedBox(height: 15),
          _buildRiskFactorRow(
            "Reduced Scanning",
            "Decreased frequency of mirror checks and visual scanning of the road environment",
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFactorRow(String factor, String description) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            factor,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.amber.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widgets for Solution Tab
  Widget _buildSolutionFeatures() {
    final List<Map<String, String>> features = [
      {
        'title': 'Real-Time Drowsiness Detection',
        'description':
            'Continuously monitors eye closure patterns, blink rate, and head position to detect early signs of fatigue.',
      },
      {
        'title': 'Multi-Stage Alert System',
        'description':
            'Escalating alerts from gentle audio reminders to strong vibration and bright visual cues based on drowsiness severity.',
      },
      {
        'title': 'Driver Safety Scoring',
        'description':
            'Provides real-time safety score during driving, tracking alertness levels and identifying patterns for improvement.',
      },
      {
        'title': 'Personalized Thresholds',
        'description':
            'Adapts to individual driver behavior patterns over time, creating customized detection thresholds for maximum accuracy.',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      feature['description']!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSystemDiagram() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SYSTEM WORKFLOW",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWorkflowStep(
                    "1",
                    "Data Acquisition",
                    Icons.camera_alt,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "2",
                    "Feature Extraction",
                    Icons.face,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "3",
                    "Drowsiness Analysis",
                    Icons.psychology,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "4",
                    "Risk Classification",
                    Icons.analytics,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "5",
                    "Alert Generation",
                    Icons.notifications_active,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowStep(String step, String label, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.amber),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.amber,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          step,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.amber.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowArrow() {
    return const Icon(
      Icons.arrow_forward,
      color: Colors.amber,
      size: 24,
    );
  }

  // Helper widgets for Hardware Tab
  Widget _buildHardwareComponents() {
    final List<Map<String, dynamic>> components = [
      {
        'name': 'Infrared Camera',
        'description':
            'High-resolution IR camera with night vision capability for reliable facial monitoring in all lighting conditions',
        'icon': Icons.camera_alt,
      },
      {
        'name': 'Embedded Processor',
        'description':
            'Low-power ARM processor with dedicated AI acceleration for real-time computer vision and machine learning tasks',
        'icon': Icons.memory,
      },
      {
        'name': 'Multi-Modal Alert System',
        'description':
            'Combination of audio speaker, vibration motor, and LED indicators for escalating alert mechanisms',
        'icon': Icons.notifications_active,
      },
      {
        'name': 'CAN Bus Interface',
        'description':
            'Vehicle network interface for integration with dashboard displays and vehicle systems when available',
        'icon': Icons.settings_input_component,
      },
    ];

    return Column(
      children: components.map((component) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  component['icon'],
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      component['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      component['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstallationDiagram() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "INSTALLATION LOCATIONS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.videocam,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Dashboard Mount",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Optimal camera position for complete facial monitoring",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.speaker_phone,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Alert Module",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Steering wheel or seat integration for direct driver feedback",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.memory,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Processing Unit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Hidden installation behind dashboard for clean aesthetics",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.settings_input_component,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Vehicle Integration",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Optional connection to vehicle's OBD-II port for enhanced functionality",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertMechanisms() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MULTI-STAGE ALERT SYSTEM",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Stage",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Alert Type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.amber.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          _buildAlertRow(
            "1",
            "Visual Warning",
            "Subtle dashboard display showing decreased alertness level and suggesting a break",
          ),
          const SizedBox(height: 15),
          _buildAlertRow(
            "2",
            "Audio Alert",
            "Gentle but noticeable tone or voice message indicating driver attention is needed",
          ),
          const SizedBox(height: 15),
          _buildAlertRow(
            "3",
            "Haptic Feedback",
            "Steering wheel or seat vibration that physically alerts the driver without startling",
          ),
          const SizedBox(height: 15),
          _buildAlertRow(
            "4",
            "Emergency Alert",
            "Loud alarm, bright flashing display, and strong vibration for immediate wake-up",
          ),
        ],
      ),
    );
  }

  Widget _buildAlertRow(String stage, String alertType, String description) {
    Color stageColor;
    switch (stage) {
      case "1":
        stageColor = Colors.green;
        break;
      case "2":
        stageColor = Colors.yellow;
        break;
      case "3":
        stageColor = Colors.orange;
        break;
      case "4":
        stageColor = Colors.red;
        break;
      default:
        stageColor = Colors.amber;
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: stageColor.withOpacity(0.2),
              border: Border.all(color: stageColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                stage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: stageColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            alertType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.amber.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widgets for Software Tab
  Widget _buildSoftwareComponents() {
    final List<Map<String, dynamic>> components = [
      {
        'name': 'Facial Analysis Engine',
        'description':
            'Deep learning model that tracks 68 facial landmarks to monitor eye openness, head position, and micro-expressions',
        'icon': Icons.face,
      },
      {
        'name': 'Drowsiness Classification Algorithm',
        'description':
            'Temporal pattern recognition system that analyzes eye closure patterns, blink frequency, and PERCLOS metrics',
        'icon': Icons.psychology,
      },
      {
        'name': 'Safety Score Calculator',
        'description':
            'Proprietary algorithm that continuously evaluates driver alertness and generates real-time safety scores',
        'icon': Icons.score,
      },
    ];

    return Column(
      children: components.map((component) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  component['icon'],
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      component['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      component['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserInterface() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "DRIVER DISPLAY INTERFACE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.dashboard,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Main Dashboard",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Real-time safety score and alertness indicator",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Alert Screen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "High-contrast warning display for drowsiness events",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.analytics,
                        color: Colors.amber,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Trip Summary",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Post-drive analysis and safety improvement tips",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyScoring() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SAFETY SCORE ALGORITHM",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "The Safety Score is calculated in real-time using a proprietary algorithm that evaluates multiple factors:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          _buildSafetyFactorRow(
            "Eye Closure Duration",
            "40%",
            "Measures the percentage of time eyes are closed and detects microsleeps",
          ),
          const SizedBox(height: 15),
          _buildSafetyFactorRow(
            "Blink Frequency",
            "20%",
            "Analyzes changes in blinking pattern that indicate increasing fatigue",
          ),
          const SizedBox(height: 15),
          _buildSafetyFactorRow(
            "Head Position Stability",
            "15%",
            "Monitors head movements and nodding that suggest drowsiness",
          ),
          const SizedBox(height: 15),
          _buildSafetyFactorRow(
            "Gaze Direction",
            "15%",
            "Tracks visual attention to the road vs. distraction elsewhere",
          ),
          const SizedBox(height: 15),
          _buildSafetyFactorRow(
            "Time-of-Day Factor",
            "10%",
            "Adjusts sensitivity based on circadian rhythm and high-risk periods",
          ),
          const SizedBox(height: 30),
          const Text(
            "The final score is displayed on a 0-100 scale, with real-time feedback and suggestions for maintaining alertness when scores decline.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyFactorRow(
      String factor, String weight, String description) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            factor,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              weight,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 3,
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.amber.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widgets for Process Tab
  Widget _buildDevelopmentTimeline() {
    final List<Map<String, dynamic>> timelineSteps = [
      {
        'phase': 'Research & Concept',
        'description':
            'Reviewed scientific literature on drowsiness detection methods and validated metrics',
        'duration': '3 months',
        'icon': Icons.search,
      },
      {
        'phase': 'Algorithm Development',
        'description':
            'Created and trained machine learning models for eye and face tracking',
        'duration': '4 months',
        'icon': Icons.code,
      },
      {
        'phase': 'Hardware Prototype',
        'description':
            'Built initial hardware prototype with camera and processing unit',
        'duration': '2 months',
        'icon': Icons.build,
      },
      {
        'phase': 'Lab Testing',
        'description':
            'Conducted controlled tests with simulator and sleep-deprived subjects',
        'duration': '3 months',
        'icon': Icons.science,
      },
      {
        'phase': 'Field Trials',
        'description':
            'Installed in test vehicles for real-world validation with volunteer drivers',
        'duration': '6 months',
        'icon': Icons.directions_car,
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timelineSteps.map((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step['icon'],
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          step['phase'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          step['duration'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      step['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChallenges() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CHALLENGES & SOLUTIONS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          _buildChallengeRow(
            "Variable Lighting Conditions",
            "Implemented infrared camera technology with dynamic exposure adjustment for consistent performance day and night",
          ),
          const SizedBox(height: 15),
          _buildChallengeRow(
            "Individual Differences",
            "Developed adaptive baseline system that learns each driver's unique eye patterns and blinking behaviors",
          ),
          const SizedBox(height: 15),
          _buildChallengeRow(
            "Sunglasses & Eyewear",
            "Enhanced algorithm to track head position and partial facial features when eyes are partially obscured",
          ),
          const SizedBox(height: 15),
          _buildChallengeRow(
            "False Alarm Reduction",
            "Created multi-factor confirmation that requires multiple indicators of drowsiness before triggering alerts",
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeRow(String challenge, String solution) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.priority_high,
              color: Colors.amber,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                solution,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.amber.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestingProcess() {
    final List<Map<String, dynamic>> tests = [
      {
        'name': 'Detection Accuracy',
        'result': '98.5% correct detection of moderate to severe drowsiness',
        'status': 'PASSED',
      },
      {
        'name': 'False Alarm Rate',
        'result': 'Less than 1 false alarm per 50 hours of driving',
        'status': 'PASSED',
      },
      {
        'name': 'Detection Latency',
        'result': 'Average of 2.3 seconds from drowsiness onset to detection',
        'status': 'PASSED',
      },
      {
        'name': 'Alert Effectiveness',
        'result': '97% effectiveness in waking drowsy drivers within 1 second',
        'status': 'PASSED',
      },
      {
        'name': 'Environmental Testing',
        'result': 'Reliable operation from -20°C to +65°C, vibration resistant',
        'status': 'PASSED',
      },
      {
        'name': 'Battery Impact',
        'result': 'Less than 2% impact on vehicle battery life',
        'status': 'PASSED',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TEST RESULTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: tests.map((test) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.amber.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        test['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        test['result'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.8),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: test['status'] == 'PASSED'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        border: Border.all(
                          color: test['status'] == 'PASSED'
                              ? Colors.green
                              : Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        test['status'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: test['status'] == 'PASSED'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Results Tab
  Widget _buildPerformanceMetrics() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "KEY PERFORMANCE INDICATORS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.event_available,
                        color: Colors.amber,
                        size: 48,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Interventions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "356,000+",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Documented wake-up alerts during field testing",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.speed,
                        color: Colors.amber,
                        size: 48,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Response Time",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "298ms",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Average detection to alert time",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.safety_check,
                        color: Colors.amber,
                        size: 48,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Safety Impact",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "73%",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Estimated reduction in drowsiness-related incidents",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFutureEnhancements() {
    final List<Map<String, String>> improvements = [
      {
        'title': 'Driver Health Monitoring',
        'description':
            'Integrating physiological monitoring capabilities to detect stress, illness, or other health factors affecting driver safety.',
      },
      {
        'title': 'Vehicle Integration API',
        'description':
            'Creating standardized interfaces for direct integration with vehicle safety systems for automatic speed reduction or pull-over assistance.',
      },
      {
        'title': 'Fleet Management Dashboard',
        'description':
            'Developing enterprise tools for commercial vehicle operators to monitor driver safety across their entire fleet in real-time.',
      },
      {
        'title': 'Personalized Coaching',
        'description':
            'Adding AI-powered feedback that helps drivers understand their alertness patterns and develop better driving habits.',
      },
    ];

    return Column(
      children: improvements.map((improvement) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                improvement['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                improvement['description']!,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.amber.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "GET IN TOUCH",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Interested in learning more about the Driver Attention Monitoring System or exploring implementation options? Contact us for additional information.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://github.com/your-username/driver-monitoring-system'),
                  label: "VIEW RESOURCES",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TechButton(
                  onPressed: () =>
                      launchUrlExternal('mailto:your-email@example.com'),
                  label: "CONTACT US",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
