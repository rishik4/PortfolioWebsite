import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';
import '../utils/image_utils.dart';

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
                        // Image of final PCB (img10)
                        Image.asset(
                          'assets/scada/img10.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
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
                              // PCB Image or Logo
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    'assets/scada/img3.png',
                                    fit: BoxFit.cover,
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
                  "The goal is to tackle the growing problem of 'vampire power' - the 5-10% of household energy consumed by idle devices "
                  "that costs U.S. consumers up to \$200 annually. By providing detailed monitoring and control capabilities, "
                  "this system helps homeowners reduce waste and save money while enhancing safety.",
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
                  "The average U.S. home consumes around 10,600 kWh per year, with a growing number of always-on "
                  "devices drawing power 24/7. This 'standby' or 'vampire' power accounts for 5-10% of a home's usage, "
                  "adding \$100-\$200 to the yearly bill.",
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
                  "and control. Studies show that households given smart monitoring tools used about 5% less electricity simply "
                  "due to awareness and control. Our system combines hardware and software to provide comprehensive energy "
                  "management at the device level.",
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
                  "compactness, safety, and ease of installation to fit inside or near standard outlets.",
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
                  "PROTOTYPING & DEVELOPMENT",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPrototypingSection(),
                const SizedBox(height: 40),
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
                  "HARDWARE DEVELOPMENT TIMELINE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildHardwareTimeline(),
                const SizedBox(height: 40),
                _buildPhysicalImplementation(),
              ],
            )),
      ],
    );
  }

  // New method for prototyping section
  Widget _buildPrototypingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description
          const Text(
            "From Concept to Prototype",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Before finalizing the PCB design, extensive prototyping was conducted to validate the circuit concepts, "
            "test sensor accuracy, and optimize power management. This iterative process ensured the final product "
            "would meet all design requirements.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 25),

          // Prototyping stages with images
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildPrototypeStage(
                  "1. Breadboard Prototyping",
                  "Initial circuit testing using breadboard to validate component compatibility and basic functionality",
                  'assets/scada/img1.png',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildPrototypeStage(
                  "2. Circuit Analysis",
                  "Measuring voltage/current characteristics and optimizing power consumption",
                  'assets/scada/img12.png',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Key findings from prototyping
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.cyanAccent.withOpacity(0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Key Findings from Prototyping",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildPrototypeFinding(
                  "ACS712 calibration required compensation for temperature drift",
                ),
                _buildPrototypeFinding(
                  "ESP32 deep sleep mode reduced standby power by 80%",
                ),
                _buildPrototypeFinding(
                  "Added extra filtering capacitors to improve sensor reading stability",
                ),
                _buildPrototypeFinding(
                  "Relay switching timing needed 20ms delay to prevent EMI issues",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for prototype stages with image
  Widget _buildPrototypeStage(
      String title, String description, String imagePath) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(imagePath, title),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with fullscreen indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.black,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.cyanAccent,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Text content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for prototype findings
  Widget _buildPrototypeFinding(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.cyanAccent.withOpacity(0.8),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Physical Implementation section showing the final hardware in use
  Widget _buildPhysicalImplementation() {
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
            "PHYSICAL IMPLEMENTATION",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/scada/img10.png',
                          fit: BoxFit.contain,
                          height: 180,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Final assembled PCB with components",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.cyanAccent,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Implementation Specifications:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildSpecRow("Dimensions", "65mm × 45mm × 20mm"),
                    _buildSpecRow("Weight", "42g (assembled)"),
                    _buildSpecRow("Power Input", "120-240V AC"),
                    _buildSpecRow("Max Current", "10A (resistive load)"),
                    _buildSpecRow("Wi-Fi Range", "Up to 30m"),
                    _buildSpecRow("Operating Temp", "-10°C to 50°C"),
                    const SizedBox(height: 15),
                    const Text(
                      "The final implementation features a compact form factor designed to fit inside standard electrical boxes, with proper insulation and heat dissipation considerations for safety.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
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
    );
  }

  // Helper method for specification rows in the physical implementation
  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.cyanAccent.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ),
        ],
      ),
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
                  "data synchronization, enabling users to monitor energy usage and control devices remotely.",
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
                // const SizedBox(height: 40),
                // _buildCodeSnippets(),
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
                  "to ensure a high-quality product that meets the energy monitoring needs of modern households.",
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
                  "control capabilities, it empowers users to reduce waste and save money, while also contributing "
                  "to reduced carbon emissions.",
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
          _buildHighlightRow('Timeline', 'January 2025 - Present'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Lead Engineer & Designer'),
          const SizedBox(height: 15),
          _buildHighlightRow('Hardware', 'ESP32, ACS712, Relay Module'),
          const SizedBox(height: 15),
          _buildHighlightRow('Potential Savings', '\$100-\$200 per year'),
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
        'color': Colors.blue,
      },
      {
        'name': 'ACS712',
        'category': 'Current Sensor',
        'icon': Icons.electric_meter,
        'color': Colors.green,
      },
      {
        'name': 'Relay Module',
        'category': 'Switching',
        'icon': Icons.toggle_on,
        'color': Colors.amber,
      },
      {
        'name': 'PCB Design',
        'category': 'Hardware',
        'icon': Icons.memory,
        'color': Colors.red,
      },
      {
        'name': 'Flutter',
        'category': 'Mobile App',
        'icon': Icons.smartphone,
        'color': Colors.lightBlue,
      },
      {
        'name': 'Firebase',
        'category': 'Cloud Storage',
        'icon': Icons.cloud,
        'color': Colors.orange,
      },
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: techStack.map((tech) {
        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Colors.black.withBlue(30),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Decorative corner accent
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tech['color'].withOpacity(0.1),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon in circular container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          tech['icon'],
                          color: Colors.cyanAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Tech name and category
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tech['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.cyanAccent.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              tech['category'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.cyanAccent.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Horizontal line accent
                Positioned(
                  bottom: 75,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.cyanAccent.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper widgets for Problem Tab
  Widget _buildProblemCards() {
    final List<Map<String, dynamic>> problems = [
      {
        'title': 'Vampire Power',
        'description':
            'The Department of Energy notes that standby power usage can equal running a 75-watt light bulb continuously, costing U.S. consumers up to \$19 billion annually.',
        'icon': Icons.warning_amber,
      },
      {
        'title': 'Lack of Visibility',
        'description':
            'Without device-level monitoring, homeowners cannot identify which appliances are energy hogs, missing opportunities for significant savings.',
        'icon': Icons.visibility_off,
      },
      {
        'title': 'Inflexible Solutions',
        'description':
            'Existing smart plugs only work with plug-in devices and traditional whole-home monitors lack device-level control capabilities.',
        'icon': Icons.device_unknown,
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
      {
        'value': '5-10%',
        'label': 'of home energy is wasted on standby power (CNET)'
      },
      {
        'value': '46%',
        'label':
            'of U.S. homes have at least one smart device (Parks Associates)'
      },
      {
        'value': '82%',
        'label': 'of renters want at least one smart device (Exploding Topics)'
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
            "\$10-30",
            "Only works with plug-in devices, adds standby load of 0.5-1W",
          ),
          const SizedBox(height: 15),
          _buildCompetitorRow(
            "Smart Switches",
            "\$15-50",
            "Requires professional installation, may need neutral wire",
          ),
          const SizedBox(height: 15),
          _buildCompetitorRow(
            "Whole-Home Monitors",
            "\$100-300",
            "No device control, imperfect appliance detection algorithms",
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
            "Works with any wired appliance with detailed monitoring and control",
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
        'title': 'Real-Time Energy Monitoring',
        'description':
            'Measures current flow using an ACS712 sensor, providing detailed energy usage data at the device level.',
      },
      {
        'title': 'Remote Control & Automation',
        'description':
            'Users can remotely switch devices on/off via the ESP32-controlled relay, helping eliminate vampire power when appliances aren\'t in use.',
      },
      {
        'title': 'Compact Custom PCB',
        'description':
            'Designed to fit inside or near standard outlets while incorporating all necessary monitoring and control components.',
      },
      {
        'title': 'Safety Features',
        'description':
            'Built-in surge protection and overheating detection help prevent electrical fires, particularly for high-risk appliances like space heaters.',
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
                child: _buildSchematicImageCard(
                  'assets/scada/img2.png',
                  "Circuit Schematic",
                  "Preliminary electrical diagram showing component connections",
                ),
              ),
              Expanded(
                child: _buildSchematicImageCard(
                  'assets/scada/img3.png',
                  "PCB Layout",
                  "Component arrangement and traces for the custom board",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildSchematicImageCard(
                  'assets/scada/img4.png',
                  "Testing Configuration",
                  "Alternative angle of PCB during testing phase",
                ),
              ),
              Expanded(
                child: _buildSchematicImageCard(
                  'assets/scada/img5.png',
                  "Board Reverse Side",
                  "Back view showing connections and traces",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSchematicImageCard(
      String imagePath, String title, String description) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(imagePath, title),
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
            // Gradient overlay at the bottom for text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Full screen icon indicator
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.cyanAccent,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imagePath, String title) {
    showFullScreenImage(context, imagePath, title);
  }

  Widget _buildHardwareTimeline() {
    // Updated stages information
    final List<Map<String, dynamic>> stages = [
      {
        'image': 'assets/scada/img12.png',
        'title': 'Stage 1: Manual Assembly and Testing with Flutter App',
        'description':
            'Initial prototype testing with breadboard setup and mobile application integration',
      },
      {
        'image': 'assets/scada/img2.png',
        'title': 'Stage 2: PCB Test Board Design',
        'description':
            'Creating the schematic and initial PCB layout for testing core functionality',
      },
      {
        'image': 'assets/scada/img6.png',
        'title': 'Stage 3: Assemble Test Board and Test',
        'description':
            'Soldering components to the test board and conducting functional verification',
      },
      {
        'image': 'assets/scada/img11.png',
        'title': 'Stage 4: Final Board Design',
        'description':
            'Completed production-ready PCB with all components integrated and optimized',
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
            "HARDWARE DEVELOPMENT STAGES",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          // Image carousel
          SizedBox(
            height: 450, // Increased height for better visibility
            child: _buildImageCarousel(stages),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<Map<String, dynamic>> stages) {
    return StatefulBuilder(
      builder: (context, setState) {
        final PageController pageController = PageController();
        final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

        return Column(
          children: [
            // Main image carousel
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: stages.length,
                onPageChanged: (index) {
                  currentPageNotifier.value = index;
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showFullScreenImage(
                        stages[index]['image'], stages[index]['title']),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              stages[index]['image'],
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          // Full screen indicator
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.fullscreen,
                                color: Colors.cyanAccent,
                                size: 24,
                              ),
                            ),
                          ),
                          // Information overlay at the bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stages[index]['title'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    stages[index]['description'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.cyanAccent.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Navigation and page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.cyanAccent),
                  onPressed: () {
                    if (currentPageNotifier.value > 0) {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                ValueListenableBuilder<int>(
                  valueListenable: currentPageNotifier,
                  builder: (context, currentPage, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(stages.length, (index) {
                        return Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.cyanAccent
                                : Colors.cyanAccent.withOpacity(0.3),
                          ),
                        );
                      }),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,
                      color: Colors.cyanAccent),
                  onPressed: () {
                    if (currentPageNotifier.value < stages.length - 1) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Remove _buildTimelineImage as it's no longer needed

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
        'duration': 'January 2025',
        'icon': Icons.search,
      },
      {
        'phase': 'Prototyping',
        'description': 'Breadboard testing of components and circuit design',
        'duration': 'February 2025',
        'icon': Icons.science,
      },
      {
        'phase': 'PCB Design',
        'description': 'Creating schematic and PCB layout in EasyEDA/Altium',
        'duration': 'March 2025',
        'icon': Icons.design_services,
      },
      {
        'phase': 'Manufacturing',
        'description': 'PCB fabrication and component assembly',
        'duration': 'April 2025',
        'icon': Icons.precision_manufacturing,
      },
      {
        'phase': 'Testing & Refinement',
        'description': 'Functional testing, debugging, and optimization',
        'duration': 'May 2025',
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
                  "1. Separate PCB Testing",
                  "Individual testing of circuit components",
                  Icons.check_circle_outline,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "2. Schematic Design",
                  "Creating electrical diagrams",
                  Icons.electrical_services,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "3. Component Selection",
                  "Choosing optimal parts",
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
                  "Hand-assembly of all components",
                  Icons.whatshot,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "5. Testing & Debugging",
                  "Verifying functionality",
                  Icons.bug_report,
                ),
              ),
              Expanded(
                child: _buildProcessStep(
                  "6. Final Assembly",
                  "Completing the PCB production",
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
            'Studies show households given smart monitoring tools used about 5% less electricity. For an average U.S. home consuming 10,600 kWh per year, this means savings of 530 kWh annually.',
        'icon': Icons.eco,
      },
      {
        'title': 'Cost Effectiveness',
        'description':
            'With standby power costing up to \$165 per household annually, our system with an estimated production cost of \$35-60 can pay for itself within a year.',
        'icon': Icons.attach_money,
      },
      {
        'title': 'Safety Enhancement',
        'description':
            'Many smart plugs feature built-in surge protection and overheating shut-off features, helping prevent the nearly 50,000 home fires caused annually by electrical issues.',
        'icon': Icons.security,
      },
      {
        'title': 'Environmental Impact',
        'description':
            'Wasted vampire electricity in U.S. homes contributes roughly 44 million metric tons of CO₂ emissions annually - equivalent to 9 million cars on the road.',
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
        'timeline': 'Q3 2025',
      },
      {
        'phase': 'Phase 2: Smart Home Integration',
        'description':
            'With over half of U.S. consumers projected to adopt smart home technology by 2025, we\'ll ensure compatibility with major platforms',
        'timeline': 'Q4 2025',
      },
      {
        'phase': 'Phase 3: Commercial Launch',
        'description':
            'Target the growing market where 78% of potential home buyers would pay extra for smart features',
        'timeline': 'Q1 2026',
      },
      {
        'phase': 'Phase 4: Expanded Feature Set',
        'description':
            'Machine learning for pattern recognition and customized energy-saving recommendations',
        'timeline': 'Q2 2026',
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
            "With the smart home market projected to reach \$170 billion globally by 2025, there's never been a better time to be part of this growing industry. If you'd like to join this project or have any questions:",
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
