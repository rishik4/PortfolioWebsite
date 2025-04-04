import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class ESP32BreakoutDetailPage extends StatefulWidget {
  const ESP32BreakoutDetailPage({super.key});

  @override
  State<ESP32BreakoutDetailPage> createState() =>
      _ESP32BreakoutDetailPageState();
}

class _ESP32BreakoutDetailPageState extends State<ESP32BreakoutDetailPage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  final List<String> _tabs = [
    'Overview',
    'Design',
    'Schematic',
    'PCB Layout',
    'Assembly',
    'Features',
    'Applications'
  ];

  // Animation controllers for sequential animations
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Number of elements to animate in each tab
  final Map<int, int> _elementsCount = {
    0: 3, // Overview tab (about, project highlights, tech stack)
    1: 2, // Design tab (requirements, decisions)
    2: 2, // Schematic tab (circuit diagrams, component selection)
    3: 3, // PCB Layout tab (layers, routing, special considerations)
    4: 3, // Assembly tab (fabrication, soldering, testing)
    5: 2, // Features tab (capabilities, specifications)
    6: 2, // Applications tab (use cases, examples)
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
                        "ESP32 Custom Breakout Board",
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
                              // PCB Image placeholder
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                      color:
                                          Colors.cyanAccent.withOpacity(0.7)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.memory,
                                    color: Colors.cyanAccent,
                                    size: 80,
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
                                      "Custom Hardware Design",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "ESP32-based breakout board with enhanced I/O, power management, and specialized connectivity",
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
                                                Icons.developer_board,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Custom PCB Design",
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
                                                Icons.electric_bolt,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Enhanced Power System",
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
        return _buildDesignTab();
      case 2:
        return _buildSchematicTab();
      case 3:
        return _buildPCBLayoutTab();
      case 4:
        return _buildAssemblyTab();
      case 5:
        return _buildFeaturesTab();
      case 6:
        return _buildApplicationsTab();
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
                  "This custom ESP32 breakout board addresses the limitations of standard development boards by providing enhanced power management, expanded GPIO capabilities, and specialized connectors for rapid prototyping.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The board was designed from scratch using EasyEDA/Altium Designer, with a focus on reliability, noise immunity, and ease of integration into larger systems. All components were carefully selected for performance and availability to ensure reproducibility.",
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
                  "KEY SPECIFICATIONS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSpecificationsTable(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // Design Tab
  Widget _buildDesignTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DESIGN PHILOSOPHY",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The design of this ESP32 breakout board was guided by several key principles that informed every decision, from component selection to trace routing. These principles ensure the board meets its intended use cases while maintaining reliability and performance.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildDesignPrinciples(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DESIGN DECISIONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDesignDecisions(),
                const SizedBox(height: 40),
                _buildComponentSelection(),
              ],
            )),
      ],
    );
  }

  // Schematic Tab
  Widget _buildSchematicTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CIRCUIT SCHEMATIC",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The schematic for this ESP32 breakout board is organized into several functional blocks for clarity and modular design. Each section addresses a specific aspect of the board's functionality, ensuring clean signal paths and proper power distribution.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSchematicBlocks(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DETAILED CIRCUIT SECTIONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCircuitSections(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // PCB Layout Tab
  Widget _buildPCBLayoutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PCB LAYOUT & ROUTING",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Translating the schematic into a physical PCB layout required careful consideration of component placement, signal integrity, and manufacturing constraints. The board uses a 2-layer design with careful ground plane management for optimal performance.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildPCBLayerViews(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DESIGN CONSIDERATIONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPCBDesignConsiderations(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "3D VISUALIZATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _build3DRendering(),
                const SizedBox(height: 40),
              ],
            )),
      ],
    );
  }

  // Assembly Tab
  Widget _buildAssemblyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FABRICATION PROCESS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "After finalizing the PCB design, Gerber files were generated and sent to a professional PCB fabrication service. This ensured high-quality production with proper solder masks, silkscreen layers, and through-hole plating.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildFabricationProcess(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SOLDERING & ASSEMBLY",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAssemblySteps(),
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
                const SizedBox(height: 40),
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
                  "KEY FEATURES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This custom ESP32 breakout board offers several advantages over standard development boards, with features specifically designed to address common challenges in IoT and embedded systems development.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildKeyFeatures(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "COMPARISONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildComparisonTable(),
                const SizedBox(height: 40),
                _buildFinalProduct(),
              ],
            )),
      ],
    );
  }

  // Applications Tab
  Widget _buildApplicationsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "IDEAL USE CASES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The ESP32 custom breakout board was designed with specific applications in mind, where standard development boards would be inadequate. Its unique features make it particularly well-suited for the following use cases.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildUseCaseCards(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PROJECT EXAMPLES",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildProjectExamples(),
                const SizedBox(height: 40),
                _buildNextSteps(),
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
          _buildHighlightRow('Status', 'Production Ready'),
          const SizedBox(height: 15),
          _buildHighlightRow('Timeline', 'Feb 2024 - May 2024'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Hardware Designer & Engineer'),
          const SizedBox(height: 15),
          _buildHighlightRow('Tools', 'EasyEDA/Altium Designer, Arduino'),
          const SizedBox(height: 15),
          _buildHighlightRow('Manufacturer', 'JLCPCB'),
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

  Widget _buildSpecificationsTable() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Feature",
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
                  "Specification",
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
          _buildSpecificationRow(
            "Microcontroller",
            "ESP32-WROOM-32D with 4MB Flash",
          ),
          const SizedBox(height: 15),
          _buildSpecificationRow(
            "Power Input",
            "5-12V DC (barrel jack) / USB-C / 3.3V direct",
          ),
          const SizedBox(height: 15),
          _buildSpecificationRow(
            "GPIO Pins",
            "All ESP32 GPIO pins accessible, with level-shifted outputs",
          ),
          const SizedBox(height: 15),
          _buildSpecificationRow(
            "Dimensions",
            "80mm x 60mm (2-layer PCB)",
          ),
          const SizedBox(height: 15),
          _buildSpecificationRow(
            "Special Features",
            "Onboard LiPo battery management, programmable status LEDs",
          ),
          const SizedBox(height: 15),
          _buildSpecificationRow(
            "Connectivity",
            "Wi-Fi, Bluetooth, I2C, SPI, UART with hardware flow control",
          ),
          const SizedBox(height: 15),
          _buildSpecificationRow(
            "Reset Protection",
            "Supervisor IC for clean resets and brownout protection",
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            color: Colors.cyanAccent.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationRow(String feature, String specification) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            feature,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            specification,
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widgets for Design Tab
  Widget _buildDesignPrinciples() {
    final List<Map<String, dynamic>> principles = [
      {
        'title': 'Reliability First',
        'description':
            'Robust power regulation, brownout protection, and ESD safeguards to ensure stable operation in various environments.',
        'icon': Icons.security,
      },
      {
        'title': 'Flexibility & Expandability',
        'description':
            'All GPIO pins broken out with standardized headers and additional expansion connections for sensors and peripherals.',
        'icon': Icons.devices_other,
      },
      {
        'title': 'Ease of Integration',
        'description':
            'Multiple power input options, logical pin grouping, and clear silkscreen labeling to simplify incorporation into larger systems.',
        'icon': Icons.integration_instructions,
      },
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: principles.map((principle) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  principle['icon'],
                  color: Colors.cyanAccent,
                  size: 32,
                ),
                const SizedBox(height: 15),
                Text(
                  principle['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  principle['description'],
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

  Widget _buildDesignDecisions() {
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
            "KEY DESIGN CHOICES",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildDesignDecisionRow(
            "Power Regulation",
            "Separate low-noise 3.3V regulators for digital and analog circuitry to minimize noise coupling.",
          ),
          const SizedBox(height: 15),
          _buildDesignDecisionRow(
            "I/O Protection",
            "All GPIO pins include series resistors and ESD protection diodes to prevent damage from static discharge.",
          ),
          const SizedBox(height: 15),
          _buildDesignDecisionRow(
            "Battery Management",
            "Integrated LiPo charging circuit with charge status indication and automatic power switching.",
          ),
          const SizedBox(height: 15),
          _buildDesignDecisionRow(
            "Programming Interface",
            "USB-to-UART bridge with auto-reset circuitry for seamless programming without manual reset sequence.",
          ),
          const SizedBox(height: 15),
          _buildDesignDecisionRow(
            "Signal Integrity",
            "Ground plane partitioning and strategic bypass capacitor placement to minimize interference.",
          ),
        ],
      ),
    );
  }

  Widget _buildDesignDecisionRow(String area, String decision) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyanAccent),
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(top: 3, right: 12),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                area,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                decision,
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

  Widget _buildComponentSelection() {
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
            "COMPONENT SELECTION",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Each component was carefully selected based on performance, reliability, and availability considerations:",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Power System",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildComponentItem(
                        "TPS563231: Buck converter for 5V to 3.3V conversion"),
                    _buildComponentItem("MCP73831: LiPo charge management IC"),
                    _buildComponentItem(
                        "AMS1117-3.3: Low-dropout regulator for analog rail"),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Signal & Protection",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildComponentItem(
                        "CP2102N: USB-to-UART bridge controller"),
                    _buildComponentItem("TPD4E05U06: 4-channel ESD protection"),
                    _buildComponentItem(
                        "PMEG2010: Schottky diodes for reverse polarity protection"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComponentItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: TextStyle(
              color: Colors.cyanAccent.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.cyanAccent.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Schematic Tab
  Widget _buildSchematicBlocks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FULL SCHEMATIC",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.schema,
                    color: Colors.cyanAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "ESP32 Breakout Board Full Schematic",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Complete circuit diagram showing all components and connections",
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
          const SizedBox(height: 20),
          const Text(
            "The schematic is organized into the following functional blocks:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 15),
          _buildSchematicBlocksList(),
        ],
      ),
    );
  }

  Widget _buildSchematicBlocksList() {
    final List<Map<String, String>> blocks = [
      {
        'name': 'Power Supply Section',
        'description':
            'Multiple input sources, voltage regulation, and power sequencing circuits',
      },
      {
        'name': 'ESP32 Core',
        'description':
            'Microcontroller and supporting components including crystal and reset circuitry',
      },
      {
        'name': 'USB Interface',
        'description':
            'USB-C connector, protection, and USB-to-UART bridge circuits',
      },
      {
        'name': 'GPIO Expansion',
        'description':
            'Pin headers, protection components, and level-shifting circuitry',
      },
      {
        'name': 'Battery Management',
        'description':
            'LiPo charging circuit, battery protection, and power switching logic',
      },
    ];

    return Column(
      children: blocks
          .map((block) =>
              _buildSchematicBlockItem(block['name']!, block['description']!))
          .toList(),
    );
  }

  Widget _buildSchematicBlockItem(String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 5, right: 15),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
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
  }

  Widget _buildCircuitSections() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCircuitSectionCard(
                "Power Regulation Circuit",
                "This section provides stable 3.3V and 5V power rails from various input sources.",
                Icons.electrical_services,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCircuitSectionCard(
                "Reset & Boot Circuit",
                "Clean reset generation and boot mode selection circuitry for reliable operation.",
                Icons.restart_alt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCircuitSectionCard(
                "USB Interface",
                "USB-C connector with CP2102N bridge for programming and serial communication.",
                Icons.usb,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCircuitSectionCard(
                "Battery Management",
                "LiPo charging and protection with automatic power source switching.",
                Icons.battery_charging_full,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircuitSectionCard(
      String title, String description, IconData icon) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                "Circuit Schematic Detail",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.cyanAccent.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for PCB Layout Tab
  Widget _buildPCBLayerViews() {
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
              "PCB LAYERS",
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
                          Icons.layers,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Top Layer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Components and signal routing",
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
                          Icons.layers_outlined,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Bottom Layer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Ground plane and additional routing",
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
                          Icons.text_fields,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Silkscreen Layer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Labels, component outlines, and board markings",
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
                          Icons.grid_3x3,
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
                          "Arranged for optimal signal integrity and ease of assembly",
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

  Widget _buildPCBDesignConsiderations() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Signal Integrity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "• Sensitive analog traces kept short and isolated\n"
                      "• Power and ground traces sized appropriately for current\n"
                      "• Strategic via placement for clean return paths\n"
                      "• Component grouping to minimize interference",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
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
                      "Manufacturability",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "• Minimum trace width of 8 mils for reliable production\n"
                      "• Standard drill sizes for all vias and through-holes\n"
                      "• Adequate clearances for hand soldering\n"
                      "• Optimized for standard PCB fabrication processes",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
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
              const Text(
                "Special Routing Considerations",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoutingConsideration(
                          "Power Distribution",
                          "Wide traces for power rails with multiple connection points to ground plane",
                        ),
                        const SizedBox(height: 10),
                        _buildRoutingConsideration(
                          "High-Speed Signals",
                          "Controlled impedance traces for USB data lines with minimal layer transitions",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoutingConsideration(
                          "RF Considerations",
                          "Keepout area around antenna with solid ground plane beneath",
                        ),
                        const SizedBox(height: 10),
                        _buildRoutingConsideration(
                          "Thermal Management",
                          "Additional vias near power components for improved heat dissipation",
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
    );
  }

  Widget _buildRoutingConsideration(String title, String description) {
    return Column(
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
            height: 1.5,
            color: Colors.cyanAccent.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _build3DRendering() {
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
            "3D MODEL RENDERS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "3D visualization of the PCB helps verify component clearances, connector accessibility, and mounting hole placement before manufacturing:",
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
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
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
                          "Top View with Components",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "3D render showing all components mounted on the PCB",
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
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.rotate_90_degrees_ccw,
                          color: Colors.cyanAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Angled View",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Perspective view showing board dimensions and component heights",
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

  // Helper widgets for Assembly Tab
  Widget _buildFabricationProcess() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.precision_manufacturing,
                  color: Colors.cyanAccent,
                  size: 64,
                ),
                const SizedBox(height: 20),
                const Text(
                  "PCB Fabrication",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Manufactured PCB panels before separation",
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
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PCB MANUFACTURING SPECIFICATIONS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              _buildFabSpecRow("Layers", "2 Layer PCB"),
              const SizedBox(height: 10),
              _buildFabSpecRow("Board Thickness", "1.6mm FR4"),
              const SizedBox(height: 10),
              _buildFabSpecRow("Copper Weight", "1oz (35μm)"),
              const SizedBox(height: 10),
              _buildFabSpecRow("Minimum Trace/Space", "8/8 mil"),
              const SizedBox(height: 10),
              _buildFabSpecRow(
                  "Surface Finish", "HASL (Hot Air Solder Leveling)"),
              const SizedBox(height: 10),
              _buildFabSpecRow("Solder Mask", "Green"),
              const SizedBox(height: 10),
              _buildFabSpecRow("Silkscreen", "White, top and bottom"),
              const SizedBox(height: 10),
              _buildFabSpecRow("Manufacturer", "JLCPCB"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFabSpecRow(String property, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            property,
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssemblySteps() {
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
              "ASSEMBLY PROCESS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ),
          _buildAssemblyStepRow([
            _buildAssemblyStep(
              "1. Component Organization",
              "Sorting and preparing all components",
              Icons.grid_view,
            ),
            _buildAssemblyStep(
              "2. SMD Soldering",
              "Surface-mount components first",
              Icons.iron,
            ),
            _buildAssemblyStep(
              "3. Through-Hole Components",
              "Headers, connectors, and larger parts",
              Icons.settings_input_component,
            ),
          ]),
          _buildAssemblyStepRow([
            _buildAssemblyStep(
              "4. Flux Cleaning",
              "Removing flux residue",
              Icons.cleaning_services,
            ),
            _buildAssemblyStep(
              "5. Visual Inspection",
              "Checking for solder joints and bridges",
              Icons.visibility,
            ),
            _buildAssemblyStep(
              "6. Final Assembly",
              "Adding any non-soldered components",
              Icons.inventory_2,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAssemblyStepRow(List<Widget> steps) {
    return Row(
      children: steps.map((step) => Expanded(child: step)).toList(),
    );
  }

  Widget _buildAssemblyStep(String title, String description, IconData icon) {
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
            "TESTING & VALIDATION",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "After assembly, each board underwent a comprehensive testing procedure:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildTestProcedure(
            "1. Initial Power-On Test",
            "Checking for proper power rail voltages and current consumption",
          ),
          const SizedBox(height: 15),
          _buildTestProcedure(
            "2. Communication Test",
            "Verifying USB connectivity and successful programming",
          ),
          const SizedBox(height: 15),
          _buildTestProcedure(
            "3. GPIO Verification",
            "Testing each I/O pin for proper function in input and output modes",
          ),
          const SizedBox(height: 15),
          _buildTestProcedure(
            "4. Wi-Fi & Bluetooth Test",
            "Confirming wireless connectivity and signal strength",
          ),
          const SizedBox(height: 15),
          _buildTestProcedure(
            "5. Battery Management Test",
            "Verifying charging circuit and power switching functionality",
          ),
          const SizedBox(height: 15),
          _buildTestProcedure(
            "6. Thermal Imaging",
            "Checking for hotspots during extended operation",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.developer_board,
                          color: Colors.cyanAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Fully Assembled & Tested Board",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Final product ready for deployment",
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

  Widget _buildTestProcedure(String step, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyanAccent),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              size: 16,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step,
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

  // Helper widgets for Features Tab
  Widget _buildKeyFeatures() {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Enhanced Power Management',
        'description':
            'Multiple power input options (USB-C, barrel jack, battery) with automatic source selection and clean power delivery.',
        'icon': Icons.electric_bolt,
      },
      {
        'title': 'Expanded I/O Capabilities',
        'description':
            'All ESP32 GPIO pins accessible with protection circuitry and standardized headers for easy connection.',
        'icon': Icons.settings_input_component,
      },
      {
        'title': 'Integrated Battery Management',
        'description':
            'LiPo battery charging and protection with automatic switchover during power loss.',
        'icon': Icons.battery_charging_full,
      },
      {
        'title': 'Robust Reset & Programming',
        'description':
            'Automatic reset circuit for seamless programming and brownout protection for reliable operation.',
        'icon': Icons.refresh,
      },
    ];

    return Column(
      children: features.map((feature) {
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
                  feature['icon'],
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
                      feature['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      feature['description'],
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

  Widget _buildComparisonTable() {
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
            "COMPARISON WITH STANDARD BOARDS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.black),
              dataRowColor: MaterialStateProperty.all(Colors.black),
              columnSpacing: 30,
              columns: const [
                DataColumn(
                  label: Text(
                    'Feature',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Standard ESP32 DevKit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Custom ESP32 Breakout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
              ],
              rows: [
                _buildComparisonRow(
                  'Power Options',
                  'USB only',
                  'USB-C, DC Jack, Battery',
                ),
                _buildComparisonRow(
                  'Power Regulation',
                  'Basic LDO regulator',
                  'High-efficiency buck converter with separate analog rail',
                ),
                _buildComparisonRow(
                  'I/O Protection',
                  'Minimal/None',
                  'Full ESD protection and current limiting',
                ),
                _buildComparisonRow(
                  'Battery Support',
                  'None',
                  'Integrated charging and protection',
                ),
                _buildComparisonRow(
                  'Reset Circuit',
                  'Basic manual reset',
                  'Auto-reset and brownout protection',
                ),
                _buildComparisonRow(
                  'Pin Access',
                  'Limited pins available',
                  'All GPIO pins accessible with standardized headers',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildComparisonRow(String feature, String standard, String custom) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            feature,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        DataCell(
          Text(
            standard,
            style: TextStyle(
              color: Colors.cyanAccent.withOpacity(0.7),
            ),
          ),
        ),
        DataCell(
          Text(
            custom,
            style: const TextStyle(
              color: Colors.cyanAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalProduct() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.memory,
                    color: Colors.cyanAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Final Assembled Board",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Completed ESP32 breakout board ready for use",
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
    );
  }

  // Helper widgets for Applications Tab
  Widget _buildUseCaseCards() {
    final List<Map<String, dynamic>> useCases = [
      {
        'title': 'IoT Development',
        'description':
            'Ideal for prototyping Internet of Things devices with its robust power management and wireless capabilities.',
        'icon': Icons.wifi,
      },
      {
        'title': 'Battery-Powered Projects',
        'description':
            'Perfect for portable applications requiring battery power with integrated charging and power management.',
        'icon': Icons.battery_full,
      },
      {
        'title': 'Sensor Networks',
        'description':
            'Excellent platform for connecting multiple sensors with extensive I/O options and communication interfaces.',
        'icon': Icons.sensors,
      },
      {
        'title': 'Home Automation',
        'description':
            'Reliable foundation for smart home devices with multi-power options and connectivity features.',
        'icon': Icons.home,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: useCases.length,
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
                useCases[index]['icon'],
                color: Colors.cyanAccent,
                size: 40,
              ),
              const SizedBox(height: 15),
              Text(
                useCases[index]['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                useCases[index]['description'],
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectExamples() {
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
              "REAL-WORLD APPLICATIONS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ),
          Row(
            children: [
              _buildProjectExample(
                "Weather Station",
                "Environmental monitoring with multiple sensors",
                Icons.cloud,
              ),
              _buildProjectExample(
                "Smart Garden System",
                "Automated plant watering and monitoring",
                Icons.grass,
              ),
            ],
          ),
          Row(
            children: [
              _buildProjectExample(
                "Home Energy Monitor",
                "Power consumption tracking for appliances",
                Icons.bolt,
              ),
              _buildProjectExample(
                "Security System",
                "Motion detection and alert notifications",
                Icons.security,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectExample(String title, String description, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 200,
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
      ),
    );
  }

  Widget _buildNextSteps() {
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
            "The ESP32 breakout board project has several planned enhancements for future iterations:",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildNextStepItem(
            "Expansion Modules",
            "Creating plug-and-play add-on boards for specific applications",
          ),
          const SizedBox(height: 15),
          _buildNextStepItem(
            "Production Optimization",
            "Refining the design for automated assembly and cost reduction",
          ),
          const SizedBox(height: 15),
          _buildNextStepItem(
            "Documentation",
            "Comprehensive user guide and example projects",
          ),
          const SizedBox(height: 15),
          _buildNextStepItem(
            "Open Source Release",
            "Publishing design files and code for community contributions",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://github.com/yourusername/esp32-breakout'),
                  label: "VIEW GITHUB REPOSITORY",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TechButton(
                  onPressed: () =>
                      launchUrlExternal('mailto:your-email@example.com'),
                  label: "REQUEST BOARD DESIGN FILES",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String title, String description) {
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
