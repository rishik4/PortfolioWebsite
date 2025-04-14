import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class WaterFilterDetailPage extends StatefulWidget {
  const WaterFilterDetailPage({super.key});

  @override
  State<WaterFilterDetailPage> createState() => _WaterFilterDetailPageState();
}

class _WaterFilterDetailPageState extends State<WaterFilterDetailPage>
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
    3: 3, // Hardware tab (schematic, PCB, components)
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
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.lightBlueAccent),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "Raspberry Pi Water Filtration Monitor",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.lightBlueAccent,
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
                      border: Border.all(
                          color: Colors.lightBlueAccent.withOpacity(0.3)),
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
                              "[Image of Raspberry Pi Water Filter]",
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
                                      color: Colors.lightBlueAccent
                                          .withOpacity(0.7)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.water_drop,
                                    color: Colors.lightBlueAccent,
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
                                      "DIY Water Quality Monitoring & Filtration",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.lightBlueAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "A Raspberry Pi-based project to monitor water quality parameters and automate filtration processes",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent,
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
                                              color: Colors.lightBlueAccent
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.show_chart,
                                                color: Colors.lightBlueAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Real-time Monitoring",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.lightBlueAccent,
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
                                              color: Colors.lightBlueAccent
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.health_and_safety,
                                                color: Colors.lightBlueAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Health Safety",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent.withOpacity(0.3),
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
              color: isSelected ? Colors.lightBlueAccent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          _tabs[index],
          style: TextStyle(
            fontSize: 16,
            color: isSelected
                ? Colors.lightBlueAccent
                : Colors.lightBlueAccent.withOpacity(0.6),
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
                  "ABOUT THE PROJECT",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This project is a DIY water quality monitoring and filtration system built using a "
                  "Raspberry Pi. It continuously measures key water parameters such as pH, turbidity, "
                  "temperature, and contaminant levels to ensure safe drinking water.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Using affordable sensors and open-source software, this system provides real-time "
                  "water quality data and can automatically trigger filtration when parameters fall "
                  "outside safe ranges. The project demonstrates how accessible technology can be used "
                  "to address critical environmental and health challenges.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "According to data from various health organizations, millions of people worldwide still drink "
                  "contaminated water, leading to waterborne illnesses. Traditional water monitoring methods "
                  "require manual collection and laboratory testing, which is time-consuming and not accessible "
                  "to many communities.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
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
                  "WATER QUALITY FACTS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildWaterQualityStats(),
                const SizedBox(height: 40),
                _buildSensorComparison(),
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
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "My Raspberry Pi Water Filtration Monitor addresses these challenges by providing an affordable, "
                  "open-source solution for continuous water quality monitoring. The system can be built for a "
                  "fraction of the cost of commercial systems while providing comparable accuracy and additional "
                  "features like remote monitoring and automated responses.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The hardware system consists of a Raspberry Pi acting as the central controller, connected to "
                  "various water quality sensors and filtration control mechanisms. The components were selected "
                  "for their accuracy, reliability, and cost-effectiveness.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
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
                  "SYSTEM SCHEMATIC",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildWhiteboardSchematic(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PHYSICAL SETUP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPhysicalSetup(),
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
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The software component is built with Python for data acquisition, processing, and control logic. "
                  "A web-based interface allows for real-time monitoring and remote control of the system, while "
                  "data is stored locally and can be synced to cloud services for long-term analysis.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildUserInterface(),
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
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The development of this project followed an iterative approach, starting with research and "
                  "planning, followed by prototyping, testing, and refinement. Each stage presented unique "
                  "challenges and learning opportunities.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
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
                  "TESTING METHODOLOGY",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
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
                  "PROJECT OUTCOMES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The Raspberry Pi Water Filtration Monitor successfully demonstrates how affordable technology "
                  "can be used to address critical water quality challenges. The system provides accurate, "
                  "real-time monitoring of water parameters and can integrate with various filtration systems.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildResultsData(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FUTURE IMPROVEMENTS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFutureImprovements(),
                const SizedBox(height: 40),
                _buildResourceLinks(),
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
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PROJECT HIGHLIGHTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildHighlightRow('Status', 'Functional Prototype'),
          const SizedBox(height: 15),
          _buildHighlightRow('Timeframe', 'Personal Project (8 weeks)'),
          const SizedBox(height: 15),
          _buildHighlightRow(
              'Key Components', 'Raspberry Pi, pH Sensor, Turbidity Sensor'),
          const SizedBox(height: 15),
          _buildHighlightRow('Software', 'Python, Flask, SQLite'),
          const SizedBox(height: 15),
          _buildHighlightRow('Cost', '~\$150 in materials'),
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
          color: Colors.lightBlueAccent,
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
                color: Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.lightBlueAccent.withOpacity(0.8),
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
        'name': 'Raspberry Pi 4',
        'category': 'Computing',
        'icon': Icons.memory,
      },
      {
        'name': 'pH Sensor',
        'category': 'Water Chemistry',
        'icon': Icons.science,
      },
      {
        'name': 'Turbidity Sensor',
        'category': 'Water Clarity',
        'icon': Icons.opacity,
      },
      {
        'name': 'Relay Control',
        'category': 'Automation',
        'icon': Icons.toggle_on,
      },
      {
        'name': 'Python',
        'category': 'Programming',
        'icon': Icons.code,
      },
      {
        'name': 'Flask Web Server',
        'category': 'Interface',
        'icon': Icons.web,
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
            border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                techStack[index]['icon'],
                color: Colors.lightBlueAccent,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                techStack[index]['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                techStack[index]['category'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.lightBlueAccent.withOpacity(0.7),
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
        'title': 'Water Quality Monitoring',
        'description':
            'Traditional water testing is infrequent and costly. There\'s a need for continuous, real-time monitoring to detect contaminants promptly.',
        'icon': Icons.watch_later,
      },
      {
        'title': 'Limited Access',
        'description':
            'Commercial water monitoring systems are expensive and often inaccessible to individuals and small communities who need them most.',
        'icon': Icons.attach_money,
      },
      {
        'title': 'Data Transparency',
        'description':
            'Many people lack information about what\'s in their water and how it might affect their health, leading to distrust and reliance on bottled water.',
        'icon': Icons.visibility_off,
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
              border:
                  Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  problem['icon'],
                  color: Colors.lightBlueAccent,
                  size: 32,
                ),
                const SizedBox(height: 15),
                Text(
                  problem['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  problem['description'],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.lightBlueAccent.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWaterQualityStats() {
    final List<Map<String, String>> stats = [
      {
        'value': '80%',
        'label':
            'of illnesses in developing countries are linked to poor water quality'
      },
      {
        'value': '120+',
        'label': 'toxins can exist in untreated water supplies'
      },
      {
        'value': '300x',
        'label': 'cost difference between filtered water and bottled water'
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
              border:
                  Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  stat['value']!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  stat['label']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.lightBlueAccent.withOpacity(0.8),
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

  Widget _buildSensorComparison() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "WATER QUALITY PARAMETERS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Parameter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Safe Range",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Health Impact",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.lightBlueAccent.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          _buildParameterRow(
            "pH Level",
            "6.5-8.5",
            "Extreme pH can cause corrosion of pipes or irritation to eyes and skin",
          ),
          const SizedBox(height: 15),
          _buildParameterRow(
            "Turbidity",
            "< 1 NTU",
            "High turbidity can harbor pathogens and reduce effectiveness of disinfection",
          ),
          const SizedBox(height: 15),
          _buildParameterRow(
            "TDS (Total Dissolved Solids)",
            "< 500 mg/L",
            "High TDS can affect taste and indicate presence of harmful contaminants",
          ),
          const SizedBox(height: 15),
          _buildParameterRow(
            "Temperature",
            "10-15°C",
            "Higher temperatures promote bacterial growth and affect taste",
          ),
        ],
      ),
    );
  }

  Widget _buildParameterRow(String parameter, String range, String impact) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            parameter,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            range,
            style: TextStyle(
              fontSize: 16,
              color: Colors.lightBlueAccent.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            impact,
            style: TextStyle(
              fontSize: 16,
              color: Colors.lightBlueAccent.withOpacity(0.8),
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
        'title': 'Multi-Parameter Monitoring',
        'description':
            'Simultaneously tracks pH, turbidity, TDS, and temperature for comprehensive water quality assessment.',
      },
      {
        'title': 'Real-Time Data & Alerts',
        'description':
            'Provides continuous monitoring with instant notifications when parameters exceed safe thresholds.',
      },
      {
        'title': 'Automated Filtration Control',
        'description':
            'Can trigger filtration systems automatically when water quality deteriorates, ensuring consistent safety.',
      },
      {
        'title': 'Open Source & Customizable',
        'description':
            'Built with accessible components and open-source software that can be modified for specific needs.',
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
                  border: Border.all(color: Colors.lightBlueAccent),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.lightBlueAccent,
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
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      feature['description']!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.lightBlueAccent.withOpacity(0.8),
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
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SYSTEM WORKFLOW",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWorkflowStep(
                    "1",
                    "Water Sampling",
                    Icons.water,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "2",
                    "Sensor Analysis",
                    Icons.sensors,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "3",
                    "Data Processing",
                    Icons.memory,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "4",
                    "User Interface",
                    Icons.dashboard,
                  ),
                  _buildWorkflowArrow(),
                  _buildWorkflowStep(
                    "5",
                    "Filtration Control",
                    Icons.filter_alt,
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
            border: Border.all(color: Colors.lightBlueAccent),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.lightBlueAccent,
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
            color: Colors.lightBlueAccent,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.lightBlueAccent.withOpacity(0.7),
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
      color: Colors.lightBlueAccent,
      size: 24,
    );
  }

  // Helper widgets for Hardware Tab
  Widget _buildHardwareComponents() {
    final List<Map<String, dynamic>> components = [
      {
        'name': 'Raspberry Pi 4',
        'description':
            'The brain of the system, running the control software and connecting to all sensors and actuators',
        'icon': Icons.memory,
      },
      {
        'name': 'pH Sensor',
        'description':
            'Measures the acidity or alkalinity of water, crucial for determining water safety and potability',
        'icon': Icons.science,
      },
      {
        'name': 'Turbidity Sensor',
        'description':
            'Detects suspended particles in water by measuring light scatter, indicating clarity and cleanliness',
        'icon': Icons.opacity,
      },
      {
        'name': 'Relay Module',
        'description':
            'Controls the filtration system, activating when water parameters exceed safe thresholds',
        'icon': Icons.toggle_on,
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
            border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  component['icon'],
                  color: Colors.lightBlueAccent,
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
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      component['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.lightBlueAccent.withOpacity(0.8),
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

  Widget _buildWhiteboardSchematic() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "WHITEBOARD DESIGN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border:
                  Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: const Center(
              child: Text(
                "[Whiteboard schematic image showing system design]",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "The schematic shows how water flows through the system, first passing through the sampling chamber where sensors collect data, then to the filtration system controlled by the Raspberry Pi based on sensor readings. The data is processed and displayed on the web interface, while also controlling the filtration process automatically.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalSetup() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "PROTOTYPE SETUP",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black45,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: Text(
                            "[Sensor module assembly]",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.devices,
                              color: Colors.lightBlueAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Sensor Array",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Assembly of pH, turbidity, and temperature sensors",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.lightBlueAccent.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black45,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: Text(
                            "[Raspberry Pi with connections]",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.developer_board,
                              color: Colors.lightBlueAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Control Unit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Raspberry Pi with relay control and power management",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.lightBlueAccent.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black45,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: Text(
                            "[Water flow system]",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.water,
                              color: Colors.lightBlueAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Water Flow System",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Tubing and valves for controlled water flow",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.lightBlueAccent.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black45,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: Text(
                            "[Complete system assembly]",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.integration_instructions,
                              color: Colors.lightBlueAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Integrated System",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "The complete assembled monitoring and filtration system",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.lightBlueAccent.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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

  // Helper widgets for Software Tab
  Widget _buildSoftwareComponents() {
    final List<Map<String, dynamic>> components = [
      {
        'name': 'Data Acquisition Module',
        'description':
            'Python scripts that read from sensors, process raw data, and convert to meaningful water quality metrics',
        'icon': Icons.analytics,
      },
      {
        'name': 'Flask Web Server',
        'description':
            'Lightweight web application providing a user interface to monitor data and control the system remotely',
        'icon': Icons.web,
      },
      {
        'name': 'SQLite Database',
        'description':
            'Local database for storing historical water quality data, enabling trend analysis and visualization',
        'icon': Icons.storage,
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
            border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  component['icon'],
                  color: Colors.lightBlueAccent,
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
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      component['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.lightBlueAccent.withOpacity(0.8),
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
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "WEB INTERFACE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.dashboard,
                        color: Colors.lightBlueAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Dashboard View",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Main interface showing real-time water quality metrics",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlueAccent.withOpacity(0.7),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.lightBlueAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Analytics View",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Historical data visualization and trend analysis",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlueAccent.withOpacity(0.7),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.lightBlueAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Configuration",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "System settings and filtration control",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlueAccent.withOpacity(0.7),
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
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "KEY CODE SAMPLES",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "pH Sensor Reading Function",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              border:
                  Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: Text(
              "def read_ph_sensor():\n"
              "    # Open I2C bus\n"
              "    bus = smbus.SMBus(1)\n\n"
              "    # Take multiple readings for accuracy\n"
              "    readings = []\n"
              "    for i in range(10):\n"
              "        # Read from sensor\n"
              "        data = bus.read_i2c_block_data(PH_SENSOR_ADDRESS, 0, 2)\n"
              "        # Convert data to pH value\n"
              "        voltage = (data[0] * 256 + data[1]) * 3.3 / 1024\n"
              "        ph_value = 3.5 * voltage\n"
              "        readings.append(ph_value)\n"
              "        time.sleep(0.1)\n\n"
              "    # Return average reading\n"
              "    return sum(readings) / len(readings)",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: Colors.lightBlueAccent.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Flask Dashboard Route",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              border:
                  Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: Text(
              "@app.route('/')\n"
              "def dashboard():\n"
              "    # Get latest readings from database\n"
              "    conn = sqlite3.connect('water_quality.db')\n"
              "    c = conn.cursor()\n"
              "    c.execute(\"SELECT * FROM readings ORDER BY timestamp DESC LIMIT 1\")\n"
              "    latest = c.fetchone()\n"
              "    \n"
              "    # Get historical data for charts\n"
              "    c.execute(\"SELECT timestamp, ph, turbidity, tds, temperature \"\n"
              "              \"FROM readings ORDER BY timestamp DESC LIMIT 100\")\n"
              "    history = c.fetchall()\n"
              "    conn.close()\n\n"
              "    # Determine water quality status\n"
              "    status = calculate_water_quality(latest)\n\n"
              "    return render_template('dashboard.html',\n"
              "                           latest=latest,\n"
              "                           history=history,\n"
              "                           status=status)",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: Colors.lightBlueAccent.withOpacity(0.8),
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
            'Researched water quality parameters, existing solutions, and selected components',
        'duration': '2 weeks',
        'icon': Icons.search,
      },
      {
        'phase': 'Component Acquisition',
        'description':
            'Ordered Raspberry Pi, sensors, and other hardware components',
        'duration': '1 week',
        'icon': Icons.shopping_cart,
      },
      {
        'phase': 'Prototyping',
        'description':
            'Built initial circuit on breadboard and tested sensor readings',
        'duration': '2 weeks',
        'icon': Icons.build,
      },
      {
        'phase': 'Software Development',
        'description':
            'Created data collection, processing, and web interface code',
        'duration': '2 weeks',
        'icon': Icons.code,
      },
      {
        'phase': 'Testing & Refinement',
        'description':
            'Calibrated sensors, tested system, and made iterative improvements',
        'duration': '1 week',
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
            border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step['icon'],
                  color: Colors.lightBlueAccent,
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
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        Text(
                          step['duration'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.lightBlueAccent.withOpacity(0.7),
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
                        color: Colors.lightBlueAccent.withOpacity(0.8),
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
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CHALLENGES & SOLUTIONS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildChallengeRow(
            "Sensor Calibration",
            "Sensors required precise calibration for accuracy. Used standard solutions to create calibration curves.",
          ),
          const SizedBox(height: 15),
          _buildChallengeRow(
            "Water-Resistant Enclosure",
            "Electronics needed protection from moisture. Created a custom waterproof housing with appropriate sealing.",
          ),
          const SizedBox(height: 15),
          _buildChallengeRow(
            "Power Consumption",
            "Initial design drained batteries quickly. Implemented sleep modes and optimized sensor reading frequency.",
          ),
          const SizedBox(height: 15),
          _buildChallengeRow(
            "Reliability",
            "Occasional sensor reading errors affected data. Added error detection algorithms and redundant measurements.",
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
            color: Colors.lightBlueAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.priority_high,
              color: Colors.lightBlueAccent,
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
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                solution,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.lightBlueAccent.withOpacity(0.8),
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
        'name': 'Sensor Accuracy',
        'result': 'pH: ±0.1, Turbidity: ±2% NTU, Temp: ±0.5°C',
        'status': 'PASSED',
      },
      {
        'name': 'Contaminant Detection',
        'result':
            'Successfully detected chlorine, lead, and bacteria indicators',
        'status': 'PASSED',
      },
      {
        'name': 'System Uptime',
        'result': '99.7% uptime over 7-day continuous operation test',
        'status': 'PASSED',
      },
      {
        'name': 'Response Time',
        'result': 'Parameter changes detected within 3 seconds',
        'status': 'PASSED',
      },
      {
        'name': 'Filter Control',
        'result': 'Automatically activates filtration when quality declines',
        'status': 'PASSED',
      },
      {
        'name': 'Data Storage',
        'result': 'Properly logs all readings and alerts to database',
        'status': 'PASSED',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TEST RESULTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: tests.map((test) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
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
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        test['result'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlueAccent.withOpacity(0.8),
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
  Widget _buildResultsData() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "PERFORMANCE METRICS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.watch_later,
                        color: Colors.lightBlueAccent,
                        size: 48,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Response Time",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "< 5 seconds",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Time to detect water quality changes",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlueAccent.withOpacity(0.7),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.battery_charging_full,
                        color: Colors.lightBlueAccent,
                        size: 48,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Battery Life",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "72+ hours",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "On battery power with standard monitoring",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlueAccent.withOpacity(0.7),
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
                    border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.ac_unit,
                        color: Colors.lightBlueAccent,
                        size: 48,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Detection Accuracy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "97.5%",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "For key contaminants vs. lab testing",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlueAccent.withOpacity(0.7),
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

  Widget _buildFutureImprovements() {
    final List<Map<String, String>> improvements = [
      {
        'title': 'Additional Sensors',
        'description':
            'Add sensors for bacterial contamination, heavy metals, and pesticides for more comprehensive monitoring.',
      },
      {
        'title': 'Machine Learning Analysis',
        'description':
            'Implement algorithms to predict water quality trends and detect anomalies before they become critical.',
      },
      {
        'title': 'Energy Efficiency',
        'description':
            'Optimize power consumption for longer battery life and potential solar power integration.',
      },
      {
        'title': 'Network Connectivity',
        'description':
            'Incorporate 4G/5G capability for remote areas without Wi-Fi access, enabling wider deployment.',
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
            border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                improvement['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                improvement['description']!,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.lightBlueAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResourceLinks() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PROJECT RESOURCES",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Want to build your own water quality monitor or learn more about this project? Check out these resources:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://github.com/your-username/raspberry-pi-water-filter'),
                  label: "SOURCE CODE",
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
