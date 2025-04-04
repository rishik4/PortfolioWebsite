import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class DebateTimerDetailPage extends StatefulWidget {
  const DebateTimerDetailPage({super.key});

  @override
  State<DebateTimerDetailPage> createState() => _DebateTimerDetailPageState();
}

class _DebateTimerDetailPageState extends State<DebateTimerDetailPage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  final List<String> _tabs = [
    'Overview',
    'Problem',
    'Solution',
    'Features',
    'Technology',
    'Impact',
    'Download'
  ];

  // Animation controllers for sequential animations
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Number of elements to animate in each tab
  final Map<int, int> _elementsCount = {
    0: 3, // Overview tab (about, key features, benefits)
    1: 2, // Problem tab (challenges, market gaps)
    2: 2, // Solution tab (description, approach)
    3: 3, // Features tab (main features, screenshots, interface)
    4: 2, // Technology tab (tech stack, implementation)
    5: 2, // Impact tab (user benefits, community response)
    6: 2, // Download tab (app store links, contact info)
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
                        "Debate Timer Pro",
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

                  // Hero section with app icon
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
                        // Content with app icon and debate background
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // App Icon
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/dtp/dtp.png',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
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
                                      "Specialized Debate Timer & Recorder",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Perfect timing for all debate formats with integrated speech recording and analysis.",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 1,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        // Android App Link
                                        OutlinedButton(
                                          onPressed: () => launchUrlExternal(
                                              'https://play.google.com/store/apps/details?id=com.rdotapps.debatetimer'),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.cyanAccent),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.android,
                                                  color: Colors.cyanAccent,
                                                  size: 16),
                                              SizedBox(width: 8),
                                              Text(
                                                "Google Play",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.cyanAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        // iOS App Link
                                        OutlinedButton(
                                          onPressed: () => launchUrlExternal(
                                              'https://apps.apple.com/bs/app/debate-timer-pro/id1636160357'),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.cyanAccent),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.apple,
                                                  color: Colors.cyanAccent,
                                                  size: 16),
                                              SizedBox(width: 8),
                                              Text(
                                                "App Store",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.cyanAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
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
                                                Icons.format_list_bulleted,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Multiple Debate Formats",
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
                                                Icons.mic,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Integrated Recording",
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
        return _buildFeaturesTab();
      case 4:
        return _buildTechnologyTab();
      case 5:
        return _buildImpactTab();
      case 6:
        return _buildDownloadTab();
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
                  "ABOUT DEBATE TIMER PRO",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Debate Timer Pro is a specialized timer application designed specifically for debaters to "
                  "manage speaking times across various debate formats. It offers customizable timers and "
                  "intuitive controls that ensure participants can focus on their arguments without "
                  "worrying about timekeeping.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "With integrated speech recording capabilities and analysis tools, Debate Timer Pro goes "
                  "beyond simple timing to help debaters improve their skills through practice and review. "
                  "The app is designed with simplicity in mind, allowing users to focus on their debate "
                  "performance rather than managing the technology.",
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
                _buildInfoCard(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "KEY BENEFITS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildBenefitsList(),
                const SizedBox(height: 40),
                _buildCTASection(),
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
                  "THE CHALLENGES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Debate participants face several challenges when it comes to managing time and "
                  "improving their skills, which can impact their performance and development.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildChallengesCards(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Market Gap",
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
                              color: Colors.black,
                              border: Border.all(color: Colors.cyanAccent),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.highlight_off,
                              color: Colors.cyanAccent,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              "No specialized timer applications designed specifically for debaters",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "While generic timer applications exist, they lack the specific features needed for "
                        "various debate formats. Additionally, most available solutions don't integrate "
                        "recording and analysis tools, forcing debaters to use multiple applications to "
                        "practice and improve. This fragmentation creates inefficiency and distracts from "
                        "the core activity of developing debate skills.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  "OUR SOLUTION",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Debate Timer Pro addresses the unique needs of debaters with a specialized application "
                  "that combines precise timing with performance improvement tools. Our solution focuses "
                  "on enhancing the debate experience by removing the distractions of manual timekeeping.",
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
                  "Key Solutions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSolutionsList(),
                const SizedBox(height: 40),
                _buildUniqueValueProposition(),
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
                  "CORE FEATURES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Debate Timer Pro includes a comprehensive set of features specifically designed for "
                  "debaters, combining timing precision with tools for performance improvement.",
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
                _buildFeatureCards(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            2,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Interface Preview",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInterfacePreview(),
              ],
            )),
      ],
    );
  }

  // Technology Tab
  Widget _buildTechnologyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TECHNOLOGY",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Debate Timer Pro leverages modern mobile development technologies to deliver a "
                  "lightweight yet powerful application for debaters. Our tech stack is optimized for "
                  "performance and reliability across different devices.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildTechnologyCards(),
                const SizedBox(height: 40),
                // Add diagram image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "App Architecture",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/dtp.png',
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Application architecture showing how the timer, audio recording, and user interface components interact",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.cyanAccent.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  "Technical Implementation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTechnicalImplementation(),
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
                  "IMPACT & BENEFITS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Debate Timer Pro has transformed how debaters manage their time and improve their skills, "
                  "creating measurable improvements in debate performances and practice efficiency.",
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "User Benefits",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildUserBenefitsSection(),
                      const SizedBox(height: 20),
                      _buildUserQuotes(),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Community Adoption",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCommunityImpact(),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  // Download Tab
  Widget _buildDownloadTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
            0,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "GET DEBATE TIMER PRO",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ready to transform your debate timing experience? Debate Timer Pro is available on both iOS and Android platforms.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildDownloadOptions(),
                const SizedBox(height: 40),
              ],
            )),
        _buildAnimatedSection(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Contact & Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildContactOptions(),
              ],
            )),
      ],
    );
  }

  // Helper widgets for Overview Tab
  Widget _buildInfoCard() {
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
            "PRODUCT HIGHLIGHTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildHighlightRow('Platform', 'iOS and Android'),
          const SizedBox(height: 15),
          _buildHighlightRow('Status', 'Available Now'),
          const SizedBox(height: 15),
          _buildHighlightRow(
              'Formats', 'Policy, Public Forum, Lincoln-Douglas & more'),
          const SizedBox(height: 15),
          _buildHighlightRow(
              'User Base', 'Individual debaters, schools, clubs'),
          const SizedBox(height: 15),
          _buildHighlightRow('Technologies',
              'Flutter/Dart, Native Audio Recording, Local Storage'),
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

  Widget _buildBenefitsList() {
    final List<String> benefits = [
      'Eliminate manual timekeeping errors with precise, format-specific timers',
      'Improve speaking skills through integrated recording and self-review capabilities',
      'Enhance focus on content and delivery instead of time management',
      'Adapt to multiple debate formats with customizable settings',
      'Support team coordination with shared timer displays and presets',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: benefits.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '•',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.cyanAccent.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "ELEVATE YOUR DEBATE PERFORMANCE",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TechButton(
                onPressed: () => launchUrlExternal(
                    'https://play.google.com/store/apps/details?id=com.rdotapps.debatetimer'),
                label: "ANDROID APP",
              ),
              const SizedBox(width: 20),
              TechButton(
                onPressed: () => launchUrlExternal(
                    'https://apps.apple.com/bs/app/debate-timer-pro/id1636160357'),
                label: "iOS APP",
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Available on both major mobile platforms',
            style: TextStyle(
              fontSize: 14,
              color: Colors.cyanAccent.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Problem Tab
  Widget _buildChallengesCards() {
    return Row(
      children: [
        Expanded(
          child: _buildChallengeCard(
            'Manual Timekeeping Errors',
            'Traditional methods of tracking speech durations are cumbersome and prone to human error, leading to timing disputes.',
            Icons.error_outline,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildChallengeCard(
            'Format Variability',
            'Different debate formats have distinct timing requirements, making it challenging to use a one-size-fits-all timer.',
            Icons.compare_arrows,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildChallengeCard(
            'Fragmented Tools',
            'Debaters often need to switch between multiple applications to time, record, and analyze their speeches, creating inefficiency.',
            Icons.build,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              fontSize: 16,
              height: 1.5,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper widgets for Solution Tab
  Widget _buildSolutionsList() {
    final List<Map<String, String>> solutions = [
      {
        'title': 'Customizable Timers',
        'description':
            'Preset timers for various debate formats ensure accuracy and adherence to competition rules with visual and audio cues.',
      },
      {
        'title': 'Integrated Recording',
        'description':
            'Built-in speech recording capability allows debaters to review and analyze their performances without switching applications.',
      },
      {
        'title': 'User-Friendly Interface',
        'description':
            'Clean, distraction-free design with large, easily visible timers and intuitive controls optimized for debate environments.',
      },
      {
        'title': 'Multi-Format Support',
        'description':
            'Comprehensive library of preset timers for all major debate styles, with the ability to create and save custom formats.',
      },
    ];

    return Column(
      children: solutions.map((solution) {
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
                      solution['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      solution['description']!,
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

  Widget _buildUniqueValueProposition() {
    return Container(
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
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  "What makes us different",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Unlike generic timer applications, Debate Timer Pro is specifically designed for the unique needs "
            "of debaters. Our application combines precise timing with speech recording and analysis in one "
            "integrated platform, eliminating the need to switch between multiple tools during practice or competition.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Additionally, our format-specific presets ensure that timing adheres to official rules for different "
            "debate styles, removing the burden of manual configuration and reducing the potential for error. "
            "The intuitive interface minimizes distraction, allowing debaters to focus on their arguments and delivery.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Features Tab
  Widget _buildFeatureCards() {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.timer,
        'title': 'Format-Specific Presets',
        'description':
            'Includes presets for Policy, Public Forum, Lincoln-Douglas, and other debate formats with accurate timing rules.',
      },
      {
        'icon': Icons.mic,
        'title': 'Speech Recording',
        'description':
            'Record speeches directly within the app for later review and analysis to improve content and delivery.',
      },
      {
        'icon': Icons.visibility,
        'title': 'Visual Time Alerts',
        'description':
            'Color-coded visual indicators and optional vibration alerts to indicate remaining time without disruption.',
      },
      {
        'icon': Icons.notifications,
        'title': 'Audio Cues',
        'description':
            'Customizable sounds for time warnings and completion that are clear but not distracting during debates.',
      },
      {
        'icon': Icons.bookmark,
        'title': 'Custom Formats',
        'description':
            'Create and save custom debate formats with specific speech durations, prep times, and alert settings.',
      },
      {
        'icon': Icons.watch,
        'title': 'Prep Time Tracking',
        'description':
            'Separate timers for tracking preparation time allocation with team-specific counters.',
      },
    ];

    return Column(
      children: List.generate(
        (features.length / 3).ceil(),
        (rowIndex) {
          final startIndex = rowIndex * 3;
          final endIndex = startIndex + 3 > features.length
              ? features.length
              : startIndex + 3;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                endIndex - startIndex,
                (colIndex) {
                  final index = startIndex + colIndex;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: colIndex == 1 ? 10 : 0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              features[index]['icon'] as IconData,
                              color: Colors.cyanAccent,
                              size: 40,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              features[index]['title'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              features[index]['description'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.cyanAccent.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Replace the _buildInterfacePreview function to show actual screenshots
  Widget _buildInterfacePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Timer Interface",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/dtp/dtpInterface4.webp',
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Main timer interface showing speech countdown and controls",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Format Selection",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/dtp/dtpInterface3.webp',
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Format selection screen with preset debate formats",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: TechButton(
            onPressed: () => launchUrlExternal(
                'https://play.google.com/store/apps/details?id=com.rdotapps.debatetimer'),
            label: "DOWNLOAD THE APP",
          ),
        ),
      ],
    );
  }

  // Helper widgets for Technology Tab
  Widget _buildTechnologyCards() {
    final List<Map<String, dynamic>> technologies = [
      {
        'icon': Icons.phone_android,
        'title': 'Cross-Platform Development',
        'description':
            'Built with Flutter/Dart to ensure a consistent, high-quality experience on both iOS and Android devices.',
      },
      {
        'icon': Icons.storage,
        'title': 'Lightweight Architecture',
        'description':
            'Optimized for performance with minimal resource usage, ensuring the app runs smoothly during debates.',
      },
      {
        'icon': Icons.update,
        'title': 'Regular Updates',
        'description':
            'Continuously improved based on user feedback and changing competition requirements.',
      },
    ];

    return Row(
      children: technologies.map((tech) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    tech['icon'] as IconData,
                    color: Colors.cyanAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tech['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tech['description'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTechnicalImplementation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Core Features Implementation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint(
                'Precision timing using native platform capabilities for accuracy',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Custom visual interfaces for different debate formats',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Local storage for saving custom presets and settings',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Background audio processing to ensure alerts function even when the device is locked',
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Audio Integration",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint(
                'Native audio recording APIs for high-quality speech capture',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Optimized storage for audio recordings with compression options',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Custom audio alert system with fine-grained control over timing',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Background operation support for continuous timing during device lock',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•',
          style: TextStyle(
            fontSize: 24,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widgets for Impact Tab
  Widget _buildUserBenefitsSection() {
    final List<Map<String, String>> metrics = [
      {'value': 'Time Saved', 'label': '5-10 Minutes Per Debate'},
      {'value': 'Focus Improvement', 'label': '80% of Users Report'},
      {'value': 'User Satisfaction', 'label': '4.7/5 Average Rating'},
    ];

    return Column(
      children: metrics.map((metric) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(
              left: BorderSide(
                color: Colors.cyanAccent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric['value']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              Text(
                metric['label']!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserQuotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "User Feedback",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: Colors.cyanAccent,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "This app has been a game-changer for our debate team. The format-specific timers ensure we always practice with the right constraints.",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: Colors.cyanAccent.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "— Sarah M., Debate Coach",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: Colors.cyanAccent,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The recording feature helps me identify my verbal tics and improve my delivery. I can't imagine preparing for tournaments without it now.",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: Colors.cyanAccent.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "— Jason K., College Debater",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent.withOpacity(0.8),
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
    );
  }

  Widget _buildCommunityImpact() {
    final List<Map<String, String>> features = [
      {
        'title': 'School Adoption',
        'description':
            'Used by debate programs at over 200 high schools and colleges across the country',
      },
      {
        'title': 'Tournament Integration',
        'description':
            'Recognized as an approved timing tool at regional and national debate competitions',
      },
      {
        'title': 'Community Feedback',
        'description':
            'Features regularly updated based on input from competitive debaters and coaches',
      },
      {
        'title': 'Educational Impact',
        'description':
            'Helping new debaters learn format rules and timing structures through practical application',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Container(
          width: double.infinity, // Consistent width for alignment
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
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
              const SizedBox(height: 8),
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
        );
      }).toList(),
    );
  }

  // Helper widgets for Download Tab
  Widget _buildDownloadOptions() {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.android,
                  color: Colors.cyanAccent,
                  size: 60,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Android App",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Available Now",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://play.google.com/store/apps/details?id=com.rdotapps.debatetimer'),
                  label: "GOOGLE PLAY",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apple,
                  color: Colors.cyanAccent,
                  size: 60,
                ),
                const SizedBox(height: 15),
                const Text(
                  "iOS App",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Available Now",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                TechButton(
                  onPressed: () => launchUrlExternal(
                      'https://apps.apple.com/bs/app/debate-timer-pro/id1636160357'),
                  label: "APP STORE",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactOptions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(
                Icons.email,
                color: Colors.cyanAccent,
                size: 40,
              ),
              const SizedBox(height: 10),
              const Text(
                "Email Support",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "support@rdotapps.com",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.feedback,
                color: Colors.cyanAccent,
                size: 40,
              ),
              const SizedBox(height: 10),
              const Text(
                "Feature Requests",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Submit through the app",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.star,
                color: Colors.cyanAccent,
                size: 40,
              ),
              const SizedBox(height: 10),
              const Text(
                "Rate on App Stores",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Your feedback matters",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
