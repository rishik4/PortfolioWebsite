import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class ScadaDetailPage extends StatefulWidget {
  const ScadaDetailPage({super.key});

  @override
  State<ScadaDetailPage> createState() => _ScadaDetailPageState();
}

class _ScadaDetailPageState extends State<ScadaDetailPage>
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
    3: 3, // Hardware tab (schematic, PCB, components)
    4: 2, // Software tab (architecture, interface)
    5: 3, // Process tab (design, testing, results)
    6: 2, // Impact tab (current impact, future goals)
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
                        "Smart Home SCADA System",
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
                              // PCB Image or Logo (placeholder)
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
                                    Icons.memory,
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
                                      "Energy Monitoring & Control",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Custom-designed SCADA system for monitoring household energy consumption with PCB prototype",
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
                                                Icons.electrical_services,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "IoT-Enabled Control",
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
                                                Icons.trending_down,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Energy Efficiency",
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
        return _buildProcessTab();
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
                  "ABOUT THE PROJECT",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This project is a custom-built SCADA system (Supervisory Control and Data Acquisition) "
                  "that monitors and controls household energy usage at the appliance level. Developed using "
                  "an ESP32, ACS712 current sensor, and a relay module, it enables real-time data collection, "
                  "switching, and analysis.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The goal is to give homeowners clear insight into power consumption and enable automated "
                  "energy-saving actions — all wrapped in a compact PCB design, scalable for mass production.",
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
                  "TECH STACK",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Modern households face significant challenges in monitoring and managing their energy consumption. "
                  "Without device-level monitoring, it's difficult to identify which appliances are consuming the most power, "
                  "leading to waste and inefficiency.",
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
                  "MARKET RESEARCH",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildMarketResearchStats(),
                const SizedBox(height: 40),
                _buildCompetitorAnalysis(),
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
                  "Our Smart Home SCADA system addresses these challenges through an integrated approach to energy monitoring "
                  "and control. The system combines hardware and software components to provide a comprehensive solution for "
                  "household energy management.",
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
                  "HARDWARE DESIGN",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The hardware component of the SCADA system consists of a custom-designed PCB that integrates "
                  "an ESP32 microcontroller, ACS712 current sensor, and relay module. The design prioritizes "
                  "compactness, safety, and ease of installation.",
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
                  "SCHEMATICS & PCB DESIGN",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSchematicsPanel(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "3D MODELS & PHYSICAL IMPLEMENTATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _build3DModelViews(),
                const SizedBox(height: 40),
                _buildPhysicalImplementation(),
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
                  "The software component consists of firmware running on the ESP32 microcontroller and a Flutter "
                  "mobile application for user interaction. The system uses Firebase for cloud storage and real-time "
                  "data synchronization.",
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
                  "USER INTERFACE",
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The development of the Smart Home SCADA system followed a structured process from initial "
                  "concept to final implementation. Each phase involved careful planning, design, and testing "
                  "to ensure a high-quality product.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
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
                  "PCB MANUFACTURING & ASSEMBLY",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildManufacturingProcess(),
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
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTestingProcess(),
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
                  "IMPACT & FUTURE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The Smart Home SCADA system has the potential to make a significant impact on household "
                  "energy consumption and environmental sustainability. By providing detailed insights and "
                  "control capabilities, it empowers users to reduce waste and save money.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildImpactMetrics(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FUTURE ROADMAP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFutureRoadmap(),
                const SizedBox(height: 40),
                _buildGetInvolved(),
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
          _buildHighlightRow('Status', 'Prototype Complete'),
          const SizedBox(height: 15),
          _buildHighlightRow('Timeline', 'Jan 2022 - Present'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Lead Engineer & Designer'),
          const SizedBox(height: 15),
          _buildHighlightRow('Hardware', 'ESP32, ACS712, Relay Module'),
          const SizedBox(height: 15),
          _buildHighlightRow('Software', 'Arduino IDE, Flutter, Firebase'),
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

  Widget _buildTechStackGrid() {
    final List<Map<String, dynamic>> techStack = [
      {
        'name': 'ESP32',
        'category': 'Microcontroller',
        'icon': Icons.developer_board,
      },
      {
        'name': 'ACS712',
        'category': 'Current Sensor',
        'icon': Icons.electric_meter,
      },
      {
        'name': 'Relay Module',
        'category': 'Switching',
        'icon': Icons.toggle_on,
      },
      {
        'name': 'PCB Design',
        'category': 'Hardware',
        'icon': Icons.memory,
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
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                techStack[index]['icon'],
                color: Colors.cyanAccent,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                techStack[index]['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                techStack[index]['category'],
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
        'title': 'Energy Waste',
        'description':
            'Most households are unaware of how much energy individual appliances consume, leading to unnecessary waste and high utility bills.',
        'icon': Icons.warning_amber,
      },
      {
        'title': 'Lack of Automation',
        'description':
            'Traditional switches don\'t allow remote control or scheduled automation for energy-intensive appliances.',
        'icon': Icons.schedule,
      },
      {
        'title': 'Bulky & Expensive Smart Switches',
        'description':
            'Existing smart systems are either too large, overpriced, or incompatible with older appliances and fixtures.',
        'icon': Icons.price_change,
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
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  problem['icon'],
                  color: Colors.cyanAccent,
                  size: 32,
                ),
                const SizedBox(height: 15),
                Text(
                  problem['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
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
        );
      }).toList(),
    );
  }

  Widget _buildMarketResearchStats() {
    final List<Map<String, String>> stats = [
      {'value': '30%', 'label': 'Average energy wasted in typical households'},
      {
        'value': '\$300+',
        'label': 'Potential annual savings with smart monitoring'
      },
      {'value': '60%', 'label': 'Users desire appliance-level energy insights'},
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

  Widget _buildCompetitorAnalysis() {
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
            "COMPETITOR ANALYSIS",
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
                  "Product",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Limitations",
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
          _buildCompetitorRow(
            "Smart Plugs",
            "\$25-45",
            "Only works with plug-in devices, no integration with fixtures",
          ),
          const SizedBox(height: 15),
          _buildCompetitorRow(
            "Smart Switches",
            "\$50-80",
            "Requires professional installation, no energy monitoring",
          ),
          const SizedBox(height: 15),
          _buildCompetitorRow(
            "Home Energy Monitors",
            "\$150-300",
            "Whole-house monitoring only, no device-level insights",
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            color: Colors.cyanAccent.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          _buildCompetitorRow(
            "Our Solution",
            "\$35-60 (est.)",
            "None - works with any wired appliance with detailed monitoring",
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitorRow(String product, String price, String limitations,
      {bool isHighlighted = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            product,
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
          flex: 1,
          child: Text(
            price,
            style: TextStyle(
              fontSize: 16,
              color: isHighlighted
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            limitations,
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
        'title': 'Non-Invasive Energy Monitoring',
        'description':
            'The system wraps around an appliance\'s power wire and detects current flow using the ACS712 sensor.',
      },
      {
        'title': 'Smart Relay Control',
        'description':
            'Users can remotely turn appliances on/off through the ESP32-controlled relay.',
      },
      {
        'title': 'Compact Custom PCB',
        'description':
            'Designed a PCB small enough to fit inside or near standard outlets, manufacturable through JLCPCB.',
      },
      {
        'title': 'Future Amazon Sale',
        'description':
            'The system is designed with scalability in mind, ready for consumer use.',
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
                    "Sensor Data Collection",
                    Icons.sensors,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "2",
                    "Local Processing",
                    Icons.memory,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "3",
                    "Cloud Storage",
                    Icons.cloud_upload,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "4",
                    "Mobile App Interface",
                    Icons.phone_android,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "5",
                    "Automated Control",
                    Icons.smart_toy,
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
        'name': 'ESP32',
        'description':
            'Powerful Wi-Fi & Bluetooth enabled microcontroller that serves as the brain of the system',
        'icon': Icons.developer_board,
      },
      {
        'name': 'ACS712 Current Sensor',
        'description':
            'Hall-effect-based linear current sensor that accurately measures AC/DC current flow',
        'icon': Icons.electric_meter,
      },
      {
        'name': 'Relay Module',
        'description':
            'Electronically controlled switch that allows high power control with low voltage signals',
        'icon': Icons.toggle_on,
      },
      {
        'name': 'Custom PCB',
        'description':
            'Specially designed circuit board that integrates all components in a compact form factor',
        'icon': Icons.memory,
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

  Widget _buildSchematicsPanel() {
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
              "CIRCUIT DIAGRAM & PCB LAYOUT",
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
                          Icons.electrical_services,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Circuit Schematic",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Full electrical diagram showing all components and connections",
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
                          Icons.grid_on,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "PCB Layout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Top and bottom layer traces with component placement",
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
                          Icons.view_in_ar,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Component Placement",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Layout showing optimal component positioning",
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
                          Icons.bolt,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Isolation & Protection",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Safety features for high/low voltage separation",
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

  Widget _build3DModelViews() {
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
              "3D VISUALIZATION",
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
                          Icons.view_in_ar,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "3D PCB Render",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Three-dimensional visualization of the board design",
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
                          Icons.home,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Enclosure Design",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Custom housing for safe installation",
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

  Widget _buildPhysicalImplementation() {
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
              "MANUFACTURING & ASSEMBLY",
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
                  height: 200,
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
                          Icons.add_circle_outline,
                          color: Colors.cyanAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Printed PCB",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 200,
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
                          Icons.hardware,
                          color: Colors.cyanAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Component Soldering",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 200,
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
                          Icons.check_circle_outline,
                          color: Colors.cyanAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Completed Assembly",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
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

  // Helper widgets for Software Tab
  Widget _buildSoftwareStack() {
    final List<Map<String, dynamic>> softwareComponents = [
      {
        'name': 'ESP32 Firmware',
        'description':
            'Arduino-based firmware for sensor data collection, processing, and relay control. Includes Wi-Fi communication and offline data storage capabilities.',
        'icon': Icons.memory,
      },
      {
        'name': 'Flutter Mobile App',
        'description':
            'Cross-platform mobile application that allows users to monitor energy usage, control appliances, and set automation rules remotely.',
        'icon': Icons.phone_android,
      },
      {
        'name': 'Firebase Backend',
        'description':
            'Cloud-based backend for data storage, user authentication, and real-time synchronization between devices and the mobile app.',
        'icon': Icons.cloud,
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
                        "Main interface showing real-time power consumption",
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
                        Icons.touch_app,
                        color: Colors.cyanAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Control Screen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Interface for manually controlling connected devices",
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
                        Icons.insert_chart,
                        color: Colors.cyanAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Analytics Screen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Detailed usage statistics and trends over time",
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
            "ESP32 Sensor Reading Function",
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
              "float readCurrentSensor() {\n"
              "  int sensorValue = 0;\n"
              "  float currentValue = 0.0;\n\n"
              "  // Read sensor multiple times for accuracy\n"
              "  for(int i = 0; i < 10; i++) {\n"
              "    sensorValue += analogRead(CURRENT_SENSOR_PIN);\n"
              "    delay(2);\n"
              "  }\n\n"
              "  // Average readings\n"
              "  sensorValue = sensorValue / 10;\n\n"
              "  // Convert to current using calibration factor\n"
              "  currentValue = (sensorValue - 512) * 0.0733;\n\n"
              "  return abs(currentValue);\n"
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
            "Flutter App Energy Dashboard Widget",
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
              "Widget _buildEnergyGraph(BuildContext context) {\n"
              "  return Container(\n"
              "    height: 250,\n"
              "    padding: EdgeInsets.all(16),\n"
              "    decoration: BoxDecoration(\n"
              "      borderRadius: BorderRadius.circular(12),\n"
              "      color: Colors.black12,\n"
              "    ),\n"
              "    child: StreamBuilder<List<EnergyDataPoint>>(\n"
              "      stream: _energyDataStream,\n"
              "      builder: (context, snapshot) {\n"
              "        if (!snapshot.hasData) {\n"
              "          return Center(child: CircularProgressIndicator());\n"
              "        }\n\n"
              "        return LineChart(\n"
              "          // Chart configuration\n"
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

  // Helper widgets for Process Tab
  Widget _buildDevelopmentTimeline() {
    final List<Map<String, dynamic>> timelineSteps = [
      {
        'phase': 'Research & Planning',
        'description':
            'Market research, component selection, and initial system architecture',
        'duration': 'January 2024',
        'icon': Icons.search,
      },
      {
        'phase': 'Prototyping',
        'description': 'Breadboard testing of components and circuit design',
        'duration': 'February 2024',
        'icon': Icons.science,
      },
      {
        'phase': 'PCB Design',
        'description': 'Creating schematic and PCB layout in EasyEDA/Altium',
        'duration': 'March 2024',
        'icon': Icons.design_services,
      },
      {
        'phase': 'Manufacturing',
        'description': 'PCB fabrication and component assembly',
        'duration': 'April 2024',
        'icon': Icons.precision_manufacturing,
      },
      {
        'phase': 'Testing & Refinement',
        'description': 'Functional testing, debugging, and optimization',
        'duration': 'May 2024',
        'icon': Icons.speed,
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
                  step['icon'],
                  color: Colors.cyanAccent,
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
                            color: Colors.cyanAccent,
                          ),
                        ),
                        Text(
                          step['duration'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.7),
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

  Widget _buildManufacturingProcess() {
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
              "PCB CREATION PROCESS",
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
                child: _buildProcessStep(
                  "1. Gerber File Export",
                  "Exporting fabrication files from EasyEDA",
                  Icons.file_download,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "2. PCB Manufacturing",
                  "Professional fabrication by JLCPCB",
                  Icons.precision_manufacturing,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "3. Component Preparation",
                  "Organizing and testing components",
                  Icons.category,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildProcessStep(
                  "4. Soldering Process",
                  "Hand soldering of all components",
                  Icons.whatshot,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "5. Initial Testing",
                  "Checking for shorts and continuity",
                  Icons.cable,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "6. Final Assembly",
                  "Enclosure fitting and wire management",
                  Icons.inventory_2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.cyanAccent,
            size: 40,
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.cyanAccent.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingProcess() {
    final List<Map<String, dynamic>> tests = [
      {
        'name': 'Current Sensor Calibration',
        'result': 'Accuracy within ±0.1A after calibration',
        'status': 'PASSED',
      },
      {
        'name': 'Relay Switching Test',
        'result': 'Reliable switching with 100,000+ cycle durability',
        'status': 'PASSED',
      },
      {
        'name': 'Wi-Fi Connectivity Range',
        'result': 'Reliable connection up to 30 meters from router',
        'status': 'PASSED',
      },
      {
        'name': 'Power Consumption',
        'result': 'Device draws < 1W in standby mode',
        'status': 'PASSED',
      },
      {
        'name': 'Heat Dissipation',
        'result': 'Max temperature of 45°C under full load',
        'status': 'PASSED',
      },
      {
        'name': 'Safety Isolation',
        'result': 'Complete electrical isolation between high and low voltage',
        'status': 'PASSED',
      },
    ];

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
            "TEST RESULTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: tests.map((test) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
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
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        test['result'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.cyanAccent.withOpacity(0.8),
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

  // Helper widgets for Impact Tab
  Widget _buildImpactMetrics() {
    final List<Map<String, dynamic>> impacts = [
      {
        'title': 'Energy Savings',
        'description':
            'Potential to reduce household electricity consumption by 15-20% through monitoring and automated control',
        'icon': Icons.eco,
      },
      {
        'title': 'Cost Effectiveness',
        'description':
            'At an estimated production cost of \$35-60, the system can pay for itself in energy savings within 3-6 months',
        'icon': Icons.attach_money,
      },
      {
        'title': 'Safety Enhancement',
        'description':
            'Threshold-based current monitoring can prevent overheating and potential fire hazards from faulty appliances',
        'icon': Icons.security,
      },
      {
        'title': 'Environmental Impact',
        'description':
            'Reduced energy consumption means lower carbon emissions - estimated at 0.5 tons CO2 per household annually',
        'icon': Icons.public,
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

  Widget _buildFutureRoadmap() {
    final List<Map<String, dynamic>> roadmap = [
      {
        'phase': 'Phase 1: Production Optimization',
        'description':
            'Streamline manufacturing process for cost reduction and quality assurance',
        'timeline': 'Q3 2024',
      },
      {
        'phase': 'Phase 2: Advanced Features',
        'description':
            'Machine learning for pattern recognition and customized energy-saving recommendations',
        'timeline': 'Q4 2024',
      },
      {
        'phase': 'Phase 3: Commercial Launch',
        'description':
            'Retail availability through e-commerce platforms and home improvement stores',
        'timeline': 'Q1 2025',
      },
      {
        'phase': 'Phase 4: Smart Home Integration',
        'description':
            'Compatibility with popular platforms like Google Home, Amazon Alexa, and Apple HomeKit',
        'timeline': 'Q2 2025',
      },
    ];

    return Column(
      children: roadmap.map((phase) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    phase['phase'],
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
                      phase['timeline'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                phase['description'],
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGetInvolved() {
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
            "GET INVOLVED",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "If you'd like to be a part of this project or have any questions, there are several ways to get involved:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://github.com/your-username/smart-home-scada'),
                  label: "VIEW SOURCE CODE",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TechButton(
                  onPressed: () =>
                      launchUrlExternal('mailto:your-email@example.com'),
                  label: "CONTACT ME",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
