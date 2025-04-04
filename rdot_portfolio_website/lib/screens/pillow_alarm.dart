import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class WakeSenseDetailPage extends StatefulWidget {
  const WakeSenseDetailPage({super.key});

  @override
  State<WakeSenseDetailPage> createState() => _WakeSenseDetailPageState();
}

class _WakeSenseDetailPageState extends State<WakeSenseDetailPage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  final List<String> _tabs = [
    'Overview',
    'Problem',
    'Solution',
    'Hardware',
    'Software',
    'Features',
    'Impact'
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
    3: 3, // Hardware tab (components, design, implementation)
    4: 2, // Software tab (app, cloud integration)
    5: 3, // Features tab (sleep tracking, alarms, personalization)
    6: 2, // Impact tab (benefits, testimonials)
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
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.cyanAccent),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "WakeSense Smart Pillow",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.cyanAccent,
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
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Stack(
                      children: [
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
                              // Project Logo
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                      color:
                                          Colors.cyanAccent.withOpacity(0.7)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.bedtime,
                                    color: Colors.cyanAccent,
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
                                      "Accessible Sleep Technology",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Smart pillow alarm using pressure sensors to track sleep quality and wake individuals with hearing impairments",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
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
                                              color: Colors.cyanAccent
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.accessibility_new,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Inclusive Design",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.cyanAccent,
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
                                              color: Colors.cyanAccent
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.auto_graph,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Sleep Analytics",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.cyanAccent,
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
                    color: Colors.cyanAccent.withOpacity(0.3),
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
              color: isSelected ? Colors.cyanAccent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          _tabs[index],
          style: TextStyle(
            fontSize: 16,
            color: isSelected
                ? Colors.cyanAccent
                : Colors.cyanAccent.withOpacity(0.6),
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
        return _buildFeaturesTab();
      case 6:
        return _buildImpactTab();
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
                  "ABOUT WAKESENSE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "WakeSense is an innovative smart pillow alarm system designed to improve sleep quality and accessibility — especially for individuals with hearing impairments. It tracks sleep movement using pressure sensors and uses gentle vibrations to wake users up during light sleep cycles, enhancing alertness and reducing grogginess.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Built with an ESP32 microcontroller and integrated into a Flutter app via Firebase and Google Cloud, it blends hardware reliability with smart data insights to create a comprehensive sleep solution that caters to diverse accessibility needs.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
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
                  "KEY TECHNOLOGIES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTechnologyGrid(),
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Traditional alarm systems have significant limitations that affect both people with hearing impairments and the general population. For millions of deaf and hard-of-hearing individuals, standard auditory alarms are ineffective, while everyone suffers from poorly timed wake-up calls that interrupt deep sleep cycles.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
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
                  "ACCESSIBILITY GAP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAccessibilityStats(),
                const SizedBox(height: 40),
                _buildSleepImpactStats(),
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "WakeSense addresses these challenges through a smart pillow alarm system that uses tactile feedback instead of sound. By embedding pressure sensors and vibration motors in a pillow, the system can both track sleep quality and provide an accessible, gentle waking mechanism.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSolutionFeatures(),
                const SizedBox(height: 40),
                _buildWorkflowDiagram(),
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The WakeSense system combines precision sensors, reliable microcontrollers, and tactile feedback components to create an integrated sleep monitoring and wake-up solution. Each component has been carefully selected for reliability, battery efficiency, and seamless integration.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
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
                  "DESIGN & INTEGRATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDesignImages(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PILLOW IMPLEMENTATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildImplementationDetails(),
                const SizedBox(height: 40),
                _buildCircuitDiagram(),
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The WakeSense software stack consists of firmware running on the ESP32 microcontroller, a Flutter mobile application for user interaction, and cloud services for data storage and analysis. The system is designed to be reliable offline while offering enhanced features when connected.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSoftwareStack(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "MOBILE APPLICATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAppScreenshots(),
                const SizedBox(height: 40),
                _buildCodeSnippets(),
              ],
            )),
      ],
    );
  }

  // Features Tab
  Widget _buildFeaturesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SLEEP TRACKING",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "WakeSense uses pressure-sensitive resistors to detect movement during sleep. These readings are processed to approximate sleep stages and overall sleep quality.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSleepTracking(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SMART ALARM SYSTEM",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAlarmSystem(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PERSONALIZATION OPTIONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPersonalizationOptions(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // Impact Tab
  Widget _buildImpactTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ACCESSIBILITY IMPACT",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "WakeSense addresses a critical gap in accessibility technology by providing a dignified, effective wake-up solution for those with hearing impairments. Beyond accessibility, the system improves sleep quality for all users through its smart alarm capabilities.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildImpactAreas(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "USER FEEDBACK",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildUserTestimonials(),
                const SizedBox(height: 40),
                _buildFutureRoadmap(),
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
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PROJECT HIGHLIGHTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildHighlightRow('Status', 'Functional Prototype'),
          const SizedBox(height: 15),
          _buildHighlightRow('Timeline', 'March 2023 - Present'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Designer & Developer'),
          const SizedBox(height: 15),
          _buildHighlightRow('Hardware', 'ESP32, FSR, Vibration Motors'),
          const SizedBox(height: 15),
          _buildHighlightRow('Software', 'Flutter, Firebase, Arduino'),
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
          color: Colors.cyanAccent,
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
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.cyanAccent.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnologyGrid() {
    final List<Map<String, dynamic>> technologies = [
      {
        'name': 'ESP32',
        'category': 'Microcontroller',
        'icon': Icons.developer_board,
      },
      {
        'name': 'Force-Sensitive Resistor',
        'category': 'Pressure Sensor',
        'icon': Icons.touch_app,
      },
      {
        'name': 'Vibration Motor',
        'category': 'Haptic Feedback',
        'icon': Icons.vibration,
      },
      {
        'name': 'Flutter',
        'category': 'Mobile App',
        'icon': Icons.smartphone,
      },
      {
        'name': 'Firebase',
        'category': 'Cloud Storage',
        'icon': Icons.cloud,
      },
      {
        'name': 'Google Cloud',
        'category': 'Data Analysis',
        'icon': Icons.analytics,
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
      itemCount: technologies.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                technologies[index]['icon'],
                color: Colors.cyanAccent,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                technologies[index]['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                technologies[index]['category'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.cyanAccent.withOpacity(0.7),
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
        'title': 'Auditory Alarms Exclude the Deaf/Hard-of-Hearing',
        'description':
            'Standard alarms don\'t offer accessible wake-up methods for the 466 million people worldwide with hearing loss.',
        'icon': Icons.hearing_disabled,
      },
      {
        'title': 'Ineffective Wake Timing',
        'description':
            'Alarms often wake users during deep sleep stages, resulting in fatigue and poor cognitive function throughout the day.',
        'icon': Icons.access_time,
      },
      {
        'title': 'Lack of Sleep Insight',
        'description':
            'Users rarely have visibility into their movement, restlessness, or sleep consistency, making improvements difficult.',
        'icon': Icons.visibility_off,
      },
    ];

    return Column(
      children: problems.map((problem) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  problem['icon'],
                  color: Colors.cyanAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      problem['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      problem['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
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

  Widget _buildAccessibilityStats() {
    final List<Map<String, String>> stats = [
      {
        'value': '466M',
        'label': 'People worldwide with disabling hearing loss'
      },
      {
        'value': '1 in 5',
        'label': 'Americans with some degree of hearing loss'
      },
      {'value': '50M', 'label': 'Americans who wake up to traditional alarms'},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  stat['value']!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  stat['label']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.8),
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

  Widget _buildSleepImpactStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "THE IMPACT OF POOR WAKE-UP TIMING",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Effect",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Impact on Daily Life",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.cyanAccent.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          _buildImpactRow(
            "Sleep Inertia",
            "Morning grogginess, disorientation, and impaired cognitive performance lasting 15-60 minutes",
          ),
          const SizedBox(height: 15),
          _buildImpactRow(
            "Stress Response",
            "Jarring wake-ups spike cortisol levels, increasing anxiety and stress throughout the day",
          ),
          const SizedBox(height: 15),
          _buildImpactRow(
            "Cognitive Deficits",
            "Reduced attention span, problem-solving ability, and decision-making capacity",
          ),
          const SizedBox(height: 15),
          _buildImpactRow(
            "Mood Disturbance",
            "Increased irritability and reduced emotional regulation capabilities",
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            color: Colors.cyanAccent.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          _buildImpactRow(
            "Long-term Health",
            "Chronic disruption of healthy sleep cycles linked to depression, diabetes, and cardiovascular issues",
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow(String effect, String impact,
      {bool isHighlighted = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            effect,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            impact,
            style: TextStyle(
              fontSize: 16,
              color: isHighlighted
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.8),
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
        'title': 'Vibration-Based Wake System',
        'description':
            'A vibration motor embedded in the pillow triggers gentle movement to wake users — perfect for those who can\'t rely on sound-based alarms.',
      },
      {
        'title': 'Sleep Movement Tracking',
        'description':
            'A pressure sensor detects movement frequency and intensity to approximate sleep stages.',
      },
      {
        'title': 'Smart Wake-Up Window',
        'description':
            'The system can intelligently choose the best time (within a preset range) to wake the user when they are least in deep sleep.',
      },
      {
        'title': 'Mobile App Interface',
        'description':
            'Connects to a Flutter app via Firebase to visualize sleep patterns and configure alarms.',
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
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.cyanAccent,
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
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      feature['description']!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
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

  Widget _buildWorkflowDiagram() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SYSTEM WORKFLOW",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWorkflowStep(
                    "1",
                    "Detect Movement",
                    Icons.sensors,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "2",
                    "Analyze Sleep Phase",
                    Icons.memory,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "3",
                    "Identify Optimal Wake Time",
                    Icons.schedule,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "4",
                    "Trigger Vibration",
                    Icons.vibration,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "5",
                    "Monitor Response",
                    Icons.person_outline,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "The WakeSense workflow creates a closed-loop system where sleep data informs the wake-up process, ensuring the gentlest and most effective alarm experience.",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: Colors.cyanAccent,
            ),
            textAlign: TextAlign.center,
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
            border: Border.all(color: Colors.cyanAccent),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.cyanAccent,
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
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.cyanAccent.withOpacity(0.7),
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
      color: Colors.cyanAccent,
      size: 24,
    );
  }

  // Helper widgets for Hardware Tab
  Widget _buildHardwareComponents() {
    final List<Map<String, dynamic>> components = [
      {
        'name': 'ESP32 Microcontroller',
        'description':
            'Handles sensor data, Bluetooth/Wi-Fi communication, and controls the vibration motor. Low-power operation extends battery life.',
        'icon': Icons.developer_board,
      },
      {
        'name': 'Force-Sensitive Resistor (FSR)',
        'description':
            'Placed under the pillow, detects subtle movements and pressure changes throughout the night to monitor sleep patterns.',
        'icon': Icons.touch_app,
      },
      {
        'name': 'Vibration Motor Module',
        'description':
            'Quietly vibrates to gently wake users during light sleep. Controlled with variable intensity for customizable wake experience.',
        'icon': Icons.vibration,
      },
      {
        'name': 'Power Management System',
        'description':
            'Rechargeable LiPo battery with voltage regulation and power optimization for extended operation between charges.',
        'icon': Icons.battery_full,
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
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  component['icon'],
                  color: Colors.cyanAccent,
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
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      component['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
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

  Widget _buildDesignImages() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "HARDWARE DESIGN DOCUMENTATION",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
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
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.straighten,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Sensor Layout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Optimal placement of pressure sensors for maximum sensitivity",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.architecture,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Compact Form Factor",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Enclosure design to hide component bulk while maintaining comfort",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.battery_charging_full,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Battery Integration",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rechargeable solution with easy access charging port",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.vibration,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Vibration Distribution",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Motor placement for optimal and even vibration feedback",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImplementationDetails() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sensor Integration",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "The Force-Sensitive Resistor (FSR) is positioned between the pillow filling and pillow case, maintaining comfort while capturing even subtle movements. A thin fabric layer prevents direct contact ensuring durability and consistent readings.",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Vibration Motors",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Multiple small vibration motors are distributed strategically throughout the pillow for gentle, consistent wake feedback. The motors operate at varying intensities based on user preferences and can increase intensity if the initial wake attempt is unsuccessful.",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircuitDiagram() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CIRCUIT SCHEMATIC",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.schema,
                    color: Colors.cyanAccent,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "WakeSense Circuit Diagram",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Complete electrical schematic showing microcontroller, sensor, and vibration motor connections",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Software Tab
  Widget _buildSoftwareStack() {
    final List<Map<String, dynamic>> softwareComponents = [
      {
        'name': 'ESP32 Firmware',
        'description':
            'Arduino-based firmware that handles data collection from the pressure sensors, detects sleep patterns, and controls the vibration motors. Includes Bluetooth connectivity for app communication.',
        'icon': Icons.memory,
      },
      {
        'name': 'Flutter Mobile App',
        'description':
            'Cross-platform mobile application that provides a user-friendly interface for configuring alarm settings, viewing sleep data, and controlling the WakeSense system.',
        'icon': Icons.phone_android,
      },
      {
        'name': 'Firebase Backend',
        'description':
            'Cloud infrastructure for securely storing user data, synchronizing settings across devices, and enabling optional sleep analytics features.',
        'icon': Icons.cloud,
      },
      {
        'name': 'Sleep Analytics Engine',
        'description':
            'Cloud-based data processing system that analyzes sleep patterns over time to provide personalized insights and recommendations for improved sleep health.',
        'icon': Icons.analytics,
      },
    ];

    return Column(
      children: softwareComponents.map((component) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  component['icon'],
                  color: Colors.cyanAccent,
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
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      component['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
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

  Widget _buildAppScreenshots() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "MOBILE APP INTERFACE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.dashboard,
                        color: Colors.cyanAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Dashboard Screen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sleep quality overview with key metrics",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyanAccent.withOpacity(0.7),
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
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.alarm,
                        color: Colors.cyanAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Alarm Setting Screen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Configure wake times and vibration patterns",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyanAccent.withOpacity(0.7),
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
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.insights,
                        color: Colors.cyanAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Sleep Analysis Screen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Detailed sleep movement and quality graphs",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyanAccent.withOpacity(0.7),
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

  Widget _buildCodeSnippets() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "KEY CODE SAMPLES",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "ESP32 Sleep Pattern Detection",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Text(
              "void detectSleepPhase() {\n"
              "  // Take multiple readings to get accurate movement data\n"
              "  float movementSum = 0;\n"
              "  for (int i = 0; i < 10; i++) {\n"
              "    movementSum += analogRead(FSR_PIN);\n"
              "    delay(100);\n"
              "  }\n"
              "  float avgMovement = movementSum / 10;\n\n"
              "  // Calculate recent movement variance\n"
              "  movementBuffer[bufferIndex] = avgMovement;\n"
              "  bufferIndex = (bufferIndex + 1) % BUFFER_SIZE;\n\n"
              "  float variance = calculateVariance(movementBuffer, BUFFER_SIZE);\n\n"
              "  // Determine sleep phase based on movement variance\n"
              "  if (variance < DEEP_SLEEP_THRESHOLD) {\n"
              "    currentSleepPhase = DEEP_SLEEP;\n"
              "  } else if (variance < LIGHT_SLEEP_THRESHOLD) {\n"
              "    currentSleepPhase = LIGHT_SLEEP;\n"
              "  } else {\n"
              "    currentSleepPhase = REM_SLEEP;\n"
              "  }\n"
              "}",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: Colors.cyanAccent.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Flutter Sleep Data Visualization",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Text(
              "Widget buildSleepGraph(BuildContext context) {\n"
              "  return Container(\n"
              "    height: 250,\n"
              "    padding: EdgeInsets.all(16),\n"
              "    decoration: BoxDecoration(\n"
              "      borderRadius: BorderRadius.circular(12),\n"
              "      color: Colors.black12,\n"
              "    ),\n"
              "    child: StreamBuilder<List<SleepDataPoint>>(\n"
              "      stream: _sleepDataStream,\n"
              "      builder: (context, snapshot) {\n"
              "        if (!snapshot.hasData) {\n"
              "          return Center(child: CircularProgressIndicator());\n"
              "        }\n\n"
              "        return LineChart(\n"
              "          LineChartData(\n"
              "            gridData: FlGridData(show: false),\n"
              "            titlesData: FlTitlesData(show: true),\n"
              "            borderData: FlBorderData(\n"
              "              show: true,\n"
              "              border: Border.all(color: Colors.white10),\n"
              "            ),\n"
              "            lineBarsData: [\n"
              "              LineChartBarData(\n"
              "                spots: snapshot.data!.map((point) =>\n"
              "                  FlSpot(point.timeOffset, point.movementIntensity)\n"
              "                ).toList(),\n"
              "                isCurved: true,\n"
              "                gradient: LinearGradient(\n"
              "                  colors: [Colors.cyan, Colors.blue],\n"
              "                ),\n"
              "                barWidth: 4,\n"
              "                dotData: FlDotData(show: false),\n"
              "              ),\n"
              "            ],\n"
              "          ),\n"
              "        );\n"
              "      },\n"
              "    ),\n"
              "  );\n"
              "}",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: Colors.cyanAccent.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Features Tab
  Widget _buildSleepTracking() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "HOW SLEEP TRACKING WORKS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "WakeSense uses a unique approach to sleep tracking based on pressure variation detected by force-sensitive resistors. While not as precise as medical-grade polysomnography, it provides valuable insights into sleep quality:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Movement Pattern Analysis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "• Frequent, small movements typically indicate REM sleep\n"
                        "• Minimal movement suggests deep sleep\n"
                        "• Medium, occasional movements suggest light sleep\n"
                        "• Large, active movements indicate wakefulness",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.cyanAccent.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Metrics Tracked",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "• Movement frequency\n"
                        "• Movement intensity\n"
                        "• Sleep cycles (estimated)\n"
                        "• Sleep duration\n"
                        "• Sleep consistency\n"
                        "• Restlessness score",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.cyanAccent.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bar_chart,
                    color: Colors.cyanAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sleep Movement Pattern Visualization",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Sample graph showing movement intensity over a night's sleep",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmSystem() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "VIBRATION-BASED ALARM SYSTEM",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.cyanAccent),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.access_alarm,
                              color: Colors.cyanAccent,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              "Smart Wake Window",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Instead of waking at an exact time, users set a wake window (e.g., 6:30-7:00 AM). The system monitors sleep phases and triggers the vibration when the user is in lighter sleep during this window, making waking more natural and less jarring.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.cyanAccent.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.cyanAccent),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.vibration,
                              color: Colors.cyanAccent,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              "Progressive Intensity",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Vibration starts gently and gradually increases in intensity if no movement response is detected. This ensures reliable wake-up while still maintaining a gentle experience. Users can customize the minimum and maximum intensity levels.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.cyanAccent.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyanAccent),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.repeat,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "Vibration Patterns",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Users can select from several vibration patterns, including steady, pulsed, wave, and escalating. These patterns can be customized to personal preference, with some users finding certain patterns more effective than others for gentle awakening.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPatternIcon("Steady", Icons.horizontal_rule),
                      _buildPatternIcon("Pulsed", Icons.more_horiz),
                      _buildPatternIcon("Wave", Icons.waves),
                      _buildPatternIcon("Escalating", Icons.trending_up),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternIcon(String label, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.cyanAccent,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.cyanAccent.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalizationOptions() {
    final List<Map<String, dynamic>> personalizationOptions = [
      {
        'name': 'Sensitivity Calibration',
        'description':
            'Adjust sensor sensitivity to match your pillow type and personal movement patterns. The system will learn over time to recognize your unique sleep signals.',
        'icon': Icons.tune,
      },
      {
        'name': 'Multiple Alarm Profiles',
        'description':
            'Create different profiles for weekdays, weekends, or special occasions with unique wake windows and vibration patterns.',
        'icon': Icons.view_agenda,
      },
      {
        'name': 'Sleep Goal Setting',
        'description':
            'Set personal sleep goals like consistent bedtime, reduced nighttime movements, or optimal sleep duration with progress tracking.',
        'icon': Icons.track_changes,
      },
      {
        'name': 'Partner Mode',
        'description':
            'Special mode designed to minimize disturbance to a sleeping partner, with focused vibrations and intelligent intensity management.',
        'icon': Icons.people,
      },
    ];

    return Column(
      children: personalizationOptions.map((option) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option['icon'],
                  color: Colors.cyanAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      option['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
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

  // Helper widgets for Impact Tab
  Widget _buildImpactAreas() {
    final List<Map<String, dynamic>> impacts = [
      {
        'title': 'Empowering the Deaf Community',
        'description':
            'WakeSense offers a reliable, non-auditory wake-up tool that fits seamlessly into daily life, supporting independence and self-sufficiency.',
        'icon': Icons.accessibility_new,
      },
      {
        'title': 'Improving Sleep Health',
        'description':
            'Users wake up more refreshed thanks to intelligent timing that aligns with natural sleep cycles, reducing sleep inertia and improving morning alertness.',
        'icon': Icons.healing,
      },
      {
        'title': 'Expanding Accessibility in Consumer Tech',
        'description':
            'WakeSense addresses a major gap in alarm technology with a sleek, practical solution that promotes inclusive design principles.',
        'icon': Icons.all_inclusive,
      },
      {
        'title': 'Data-Driven Sleep Insights',
        'description':
            'The app provides valuable sleep quality information that helps users identify patterns and make positive changes to their sleep habits.',
        'icon': Icons.data_usage,
      },
    ];

    return Column(
      children: impacts.map((impact) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  impact['icon'],
                  color: Colors.cyanAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      impact['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      impact['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
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

  Widget _buildUserTestimonials() {
    final List<Map<String, String>> testimonials = [
      {
        'quote':
            'As someone with severe hearing loss, I\'ve always struggled with reliable alarm solutions. WakeSense has completely changed my morning routine and given me back my independence.',
        'name': 'Sarah M.',
        'details': 'Deaf community advocate',
      },
      {
        'quote':
            'The sleep tracking is surprisingly accurate. I feel much more refreshed in the mornings since the system wakes me during lighter sleep phases.',
        'name': 'David K.',
        'details': 'Software engineer',
      },
      {
        'quote':
            'My partner works night shifts and I didn\'t want to disturb them with loud alarms when I wake up. WakeSense is the perfect solution - I wake up on time and they sleep undisturbed.',
        'name': 'Michelle T.',
        'details': 'Healthcare worker',
      },
    ];

    return Column(
      children: testimonials.map((testimonial) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.format_quote,
                color: Colors.cyanAccent,
                size: 24,
              ),
              const SizedBox(height: 10),
              Text(
                testimonial['quote']!,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        testimonial['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        testimonial['details']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyanAccent.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFutureRoadmap() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FUTURE DEVELOPMENT",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "The WakeSense project continues to evolve with several exciting features planned for future development:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildRoadmapItem(
            "Advanced Sleep Analytics",
            "Enhanced sleep pattern recognition with machine learning algorithms trained on larger datasets",
            "Q3 2024",
          ),
          const SizedBox(height: 15),
          _buildRoadmapItem(
            "Smart Home Integration",
            "Connectivity with smart home ecosystems to control lights, temperature, and more",
            "Q4 2024",
          ),
          const SizedBox(height: 15),
          _buildRoadmapItem(
            "Mobile Companion App Updates",
            "Expanded sleep insights and personalized recommendations based on sleep patterns",
            "Q1 2025",
          ),
          const SizedBox(height: 15),
          _buildRoadmapItem(
            "Commercial Launch",
            "Refined product packaging and wider availability through retail channels",
            "Q2 2025",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://github.com/yourusername/wakesense'),
                  label: "VIEW REPOSITORY",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TechButton(
                  onPressed: () =>
                      launchUrlExternal('mailto:your-email@example.com'),
                  label: "CONTACT FOR MORE INFO",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapItem(String title, String description, String timeline) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyanAccent),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.cyanAccent,
            size: 16,
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
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      timeline,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
