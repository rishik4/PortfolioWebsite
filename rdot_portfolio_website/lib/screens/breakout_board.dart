import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';
import '../utils/image_utils.dart';

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

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final Map<int, int> _elementsCount = {
    0: 3,
    1: 3, // Updated for older version and sketch
    2: 2,
    3: 3,
    4: 3,
    5: 2,
    6: 2,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initializeAnimations(4);
    _animationController.forward();
  }

  void _initializeAnimations(int maxElements) {
    _fadeAnimations = List.generate(maxElements, (index) {
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
    _animationController.reset();
    _animationController.forward();
  }

  // Fullscreen image dialog from SCADA
  void _showFullScreenImage(String imagePath, String title) {
    showFullScreenImage(context, imagePath, title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.cyanAccent),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "ESP32 Custom Breakout Board (Project)",
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
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _showFullScreenImage(
                                    'assets/breakoutboard/imgCover2.png',
                                    'ESP32 Breakout Board Cover'),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                        color:
                                            Colors.cyanAccent.withOpacity(0.7)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/breakoutboard/imgCover2.png',
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                ),
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Custom Hardware Project",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "A simple ESP32-based breakout board in black PCB color, featuring an AMS1117 regulator, CP2102 USB-to-UART, debug LEDs, and female pins for flexible prototyping.",
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
                                                Icons.usb,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "UART Programming",
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
                                                Icons.settings_input_component,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Easy Prototyping",
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

  Widget _buildAnimatedSection(int index, Widget child) {
    if (index >= _fadeAnimations.length) return child;
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  // Helper for image cards with fullscreen support
  Widget _buildImageCard(String imagePath, String title, String description) {
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
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
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
                "ABOUT THIS PROJECT",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "I created this ESP32 breakout board as a personal learning project—not a commercial product. I wanted to figure out how UART communication via USB actually works so I could flash firmware to my ESP32 directly. By exposing all pins, including SPI and other peripherals, I can easily experiment with breadboard circuits before eventually soldering everything onto a finalized PCB.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Additionally, I chose a black PCB color for the first time, which turned out looking really sleek. The board includes an AMS1117 3.3V regulator, a CP2102 USB-to-UART chip, several debug LEDs, and female pin headers to allow quick testing. No extra battery management or fancy features—just a straightforward, minimal design that accomplishes my goals.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectHighlightsCard(),
              const SizedBox(height: 40),
              const Text(
                "SOME QUICK SNAPS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildImageCard(
                      'assets/breakoutboard/img1.png',
                      'Old Setup',
                      'Initial prototype setup for testing',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildImageCard(
                      'assets/breakoutboard/img3.png',
                      'Board Next to Arduino',
                      'Comparing size with an Arduino board',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          2,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "WHY BUILD THIS?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "I wanted to learn how to bring up an ESP32 from scratch: from designing the PCB in EasyEDA, to soldering, to connecting over USB, to flashing the firmware, to blinking debug LEDs. Knowing how UART communication and the boot/reset pins work is especially critical for future hardware projects—this board is the perfect stepping stone.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

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
          _buildHighlightRow('Status', 'Fully Working Project'),
          const SizedBox(height: 15),
          _buildHighlightRow('Focus', 'Learning UART & ESP32 flashing'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Hobbyist / Hardware Learner'),
          const SizedBox(height: 15),
          _buildHighlightRow(
              'Tools Used', 'EasyEDA, Arduino IDE, CP2102 USB-to-UART'),
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
                "LEARNING GOALS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "My main motivation was to dig into how USB-to-UART bridging actually programs the ESP32. I wanted to understand the boot and reset pins, so I could incorporate them on my own board without relying on a large dev kit. Additionally, by exposing all pins, I could easily breadboard different SPI or I2C sensors before finalizing any additional circuitry on the PCB.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "OLDER VERSION",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
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
                      "Initial Prototype with Boot/Reset Buttons",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildImageCard(
                      'assets/breakoutboard/img5.png',
                      'Older PCB Version',
                      'Basic UART chip with boot/reset buttons for programming mode',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "The first iteration had a basic UART chip and separate boot/reset buttons to manually enter programming mode. This helped me grasp how the ESP32 boots and flashes firmware.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          2,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "DESIGN DECISIONS & SKETCH",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
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
                      "Boot/Reset Pin Configuration",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildImageCard(
                      'assets/breakoutboard/img5.png', // Placeholder; replace with actual sketch if available
                      'Boot/Reset Sketch',
                      'Diagram of boot/reset pin setup for programming',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "From the older version, I refined the design by adding an AMS1117 regulator, extra pin headers, and debug LEDs. The sketch above outlines the boot/reset pin connections critical for programming.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

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
                "PROJECT SCHEMATIC",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Below is a simple schematic showing the ESP32-WROOM module, CP2102 USB-to-UART interface, AMS1117 voltage regulator, and associated supporting components. Nothing too fancy—just enough to power the ESP32 at 3.3V, connect it over USB, and break out all the pins.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageCard(
                'assets/breakoutboard/img4.png',
                'Project Schematic',
                'Detailed circuit diagram of the breakout board',
              ),
              const SizedBox(height: 20),
              const Text(
                "Keeping it minimal was key so I could focus on learning the essentials of UART programming, flashing, and pin exposure for breadboard experiments.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

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
                "Only two layers were needed. I kept the top layer for major signal routing and the bottom layer mostly as a ground plane. The final board size is compact, with enough space to mount female headers and debug LEDs.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "BLACK PCB CHOICE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: const Text(
                  "I decided on a black solder mask because I'd never used that color before. It's purely aesthetic, but I’m happy with how polished the board looks. I typically used green in previous prototypes, so this was a fun change!",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          2,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ANY SPECIAL CONSIDERATIONS?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Not really—this is a straightforward layout. The CP2102 sits near the USB connector, the AMS1117 is placed to ensure minimal noise to the ESP32, and the rest of the pins are simply exposed via female headers. Some ESD protections are in place, and there are a couple of debug/status LEDs to confirm power and serial activity.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

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
                "ASSEMBLY PROCESS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "After receiving the boards from the fab, I hand-soldered the ESP32 module, CP2102, AMS1117 regulator, headers, and LEDs. I tested continuity for critical lines (3.3V, GND, TX, RX, etc.) before attempting to flash.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: const Text(
                  "I plugged it into USB, verified 3.3V was present, and used the Arduino IDE to flash a simple blink sketch on a GPIO pin connected to an LED. It all worked on the first try, which was super exciting! I also checked if I could toggle other pins on a breadboard—everything was accessible and working as expected.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          2,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "FINAL BOARD",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              _buildImageCard(
                'assets/breakoutboard/img2.png',
                'Final Assembled Board',
                'Completed breakout board ready for use',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

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
                "• AMS1117 3.3V regulator for stable power.\n"
                "• CP2102 USB-to-UART for easy flashing.\n"
                "• Female pin headers for breadboard-friendly prototyping.\n"
                "• Multiple debug/status LEDs.\n"
                "• Straightforward schematic and small 2-layer PCB in black.\n",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "COMPARISON WITH TYPICAL DEV BOARDS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: SingleChildScrollView(
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
                          'Typical DevKit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'My Breakout Project',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          const DataCell(
                            Text(
                              'Size & Layout',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Bulkier, integrated modules',
                              style: TextStyle(
                                color: Colors.cyanAccent.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const DataCell(
                            Text(
                              'Compact, minimal design',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text(
                              'Power Regulator',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Similar (AMS1117 or equivalent)',
                              style: TextStyle(
                                color: Colors.cyanAccent.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const DataCell(
                            Text(
                              'AMS1117 (3.3V)',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text(
                              'Pin Access',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Often break out all pins but cramped',
                              style: TextStyle(
                                color: Colors.cyanAccent.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const DataCell(
                            Text(
                              'Full pins with spaced headers',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text(
                              'USB-to-UART',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Usually integrated (CH340 or CP2102)',
                              style: TextStyle(
                                color: Colors.cyanAccent.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const DataCell(
                            Text(
                              'CP2102, clearly accessible',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

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
                "WHAT CAN I DO WITH IT?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "This board served as a foundational project that helped me understand how an ESP32 is architected and how to interface with it directly. I used it as a stepping stone for building more complex, finalized PCB boards in later projects. It gave me hands-on experience with UART communication, especially flashing firmware without relying on pre-made dev kits. That knowledge has been crucial for integrating ESP32s confidently into more advanced embedded systems.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        _buildAnimatedSection(
          1,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "NEXT STEPS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: const Text(
                  "I might add more sensors or build a custom shield to sit on top, but the core objective has already been fulfilled. This project taught me the essentials of ESP32 flashing, UART interfacing, and GPIO accessibility. With that understanding, I’m now equipped to design complete ESP32-based systems from the ground up, with confidence and clarity.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
