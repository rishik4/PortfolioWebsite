import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class ClickSpeedProDetailPage extends StatefulWidget {
  const ClickSpeedProDetailPage({super.key});

  @override
  State<ClickSpeedProDetailPage> createState() =>
      _ClickSpeedProDetailPageState();
}

class _ClickSpeedProDetailPageState extends State<ClickSpeedProDetailPage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  final List<String> _tabs = [
    'Overview',
    'Problem',
    'Solution',
    'Innovation',
    'Technology',
    'Impact',
    'Downloads'
  ];

  // Animation controllers for sequential animations
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Number of elements to animate in each tab
  final Map<int, int> _elementsCount = {
    0: 2, // Overview tab (about, project highlights)
    1: 2, // Problem tab (challenge, barriers)
    2: 2, // Solution tab (description, features)
    3: 2, // Innovation tab (intro, features)
    4: 2, // Technology tab (tech details, implementation)
    5: 2, // Impact tab (current impact, benefits)
    6: 2, // Downloads tab (links, metrics)
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
    _initializeAnimations(3); // Max of 3 elements in any tab

    // Start the animation for the initial tab
    _animationController.forward();
  }

  void _initializeAnimations(int maxElements) {
    _fadeAnimations = List.generate(maxElements, (index) {
      // Calculate staggered intervals (0-0.33, 0.33-0.66, 0.66-1.0)
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
                        "Click Speed Pro",
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
                        // Content with app icon
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // App Icon (placeholder - you may want to replace with actual app icon)
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Colors.cyanAccent.withOpacity(0.5)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.touch_app,
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
                                      "Android Speed Clicking App",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Dynamic click speed testing app developed in just a few hours",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 1,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Google Play Store link button
                                    OutlinedButton(
                                      onPressed: () => launchUrlExternal(
                                          'https://play.google.com/store/apps/details?id=com.rdotapps.click_speed_pro&hl=en_US'),
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
                                            "Google Play Store",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        border: Border.all(
                                          color: Colors.cyanAccent
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.speed,
                                            color: Colors.cyanAccent,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Developed in just a few hours",
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
        return _buildInnovationTab();
      case 4:
        return _buildTechnologyTab();
      case 5:
        return _buildImpactTab();
      case 6:
        return _buildDownloadsTab();
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
                "ABOUT CLICK SPEED PRO",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Click Speed Pro is a dynamic mobile application designed to measure and enhance users' clicking speed. "
                "It offers various time-based challenges, allowing users to compete globally and analyze their performance "
                "through comprehensive tools.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "This project was completed in just a few hours to test and demonstrate my skills in Flutter development. "
                "Despite the short development timeline, it includes a comprehensive feature set including global leaderboards, "
                "analytics, and multiple challenge modes.",
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
              _buildProjectHighlights(),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
                "Click Speed Pro addresses several key challenges faced by users seeking to improve their clicking speed and "
                "performance. These challenges represent gaps in the market that this application aims to fill.",
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
              _buildProblemCards(),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
                "Click Speed Pro offers a comprehensive solution to the challenges faced by users looking to "
                "measure and improve their clicking speed. Through innovative features and a user-centric design, "
                "the app provides tools for both casual users and competitive clickers.",
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
                "Key Features",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              _buildSolutionFeatures(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  // Innovation Tab
  Widget _buildInnovationTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
          0,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "INNOVATION",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "While click speed testing apps exist, Click Speed Pro introduces several innovative elements "
                "that distinguish it from competitors. These innovations enhance user experience and provide "
                "more comprehensive functionality despite being developed in a short timeframe.",
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
              _buildInnovationCards(),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
                "Click Speed Pro leverages modern development technologies to deliver a responsive, reliable, "
                "and feature-rich application. Despite the rapid development timeline, the app incorporates "
                "professional-grade technologies and best practices.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
              _buildTechnologyCards(),
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
          ),
        ),
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
                "Click Speed Pro provides tangible benefits to users looking to enhance their clicking ability. "
                "The application's comprehensive features contribute to skill development and community building "
                "among enthusiasts.",
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
                    _buildUserBenefits(),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Development Takeaways",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDevelopmentTakeaways(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Downloads Tab
  Widget _buildDownloadsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedSection(
          0,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AVAILABILITY",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Click Speed Pro is publicly available for Android devices through the Google Play Store. "
                "The application continues to receive updates and improvements based on user feedback.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 40),
              _buildDownloadSection(),
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
                "Future Improvements",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),
              _buildFutureImprovements(),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widgets for Overview Tab
  Widget _buildProjectHighlights() {
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
          _buildHighlightRow('Platform', 'Android'),
          const SizedBox(height: 15),
          _buildHighlightRow('Development Time', 'A few hours'),
          const SizedBox(height: 15),
          _buildHighlightRow('Status', 'Published on Google Play Store'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Solo Developer'),
          const SizedBox(height: 15),
          _buildHighlightRow('Technologies', 'Flutter, Dart, Firebase'),
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

  // Helper widgets for Problem Tab
  Widget _buildProblemCards() {
    final List<Map<String, String>> problems = [
      {
        'title': 'Lack of Benchmarking Tools',
        'description':
            'Users seeking to improve their clicking speed often lack reliable platforms to measure and compare their performance.',
      },
      {
        'title': 'Limited Analytical Insights',
        'description':
            'Existing applications may not provide detailed analytics on clicking patterns and progress over time.',
      },
      {
        'title': 'Absence of Competitive Platforms',
        'description':
            'Enthusiasts lack a centralized platform to compete and benchmark their clicking speeds against a global user base.',
      }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                problem['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                problem['description']!,
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

  // Helper widgets for Solution Tab
  Widget _buildSolutionFeatures() {
    final List<Map<String, String>> features = [
      {
        'title': 'Diverse Time Formats',
        'description':
            'Offers multiple time-based challenges, enabling users to test their clicking speed over various durations.',
      },
      {
        'title': 'Global Leaderboards',
        'description':
            'Facilitates competition by allowing users to compare their scores with players worldwide.',
      },
      {
        'title': 'Comprehensive Analytics',
        'description':
            'Provides detailed insights into users\' clicking patterns, helping them track improvements and identify areas for enhancement.',
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

  // Helper widgets for Innovation Tab
  Widget _buildInnovationCards() {
    final List<Map<String, String>> innovations = [
      {
        'title': 'User-Centric Design',
        'description':
            'Intuitive interface ensures users can easily navigate and engage with the app\'s features.',
      },
      {
        'title': 'Real-Time Feedback',
        'description':
            'Immediate display of results post-challenge, allowing users to quickly assess their performance.',
      },
      {
        'title': 'Adaptive Challenges',
        'description':
            'Varying difficulty levels cater to both novices and seasoned clickers, promoting continuous engagement.',
      },
    ];

    return Column(
      children: List.generate(
        (innovations.length / 2).ceil(),
        (rowIndex) {
          final startIndex = rowIndex * 2;
          final endIndex = startIndex + 2 > innovations.length
              ? innovations.length
              : startIndex + 2;

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
                      padding: EdgeInsets.only(
                        right: colIndex == 0 ? 10 : 0,
                        left: colIndex == 1 ? 10 : 0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              innovations[index]['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              innovations[index]['description']!,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.cyanAccent.withOpacity(0.8),
                              ),
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

  // Helper widgets for Technology Tab
  Widget _buildTechnologyCards() {
    final List<Map<String, dynamic>> technologies = [
      {
        'icon': Icons.android,
        'title': 'Cross-Platform Availability',
        'description':
            'Developed for Android devices, ensuring broad accessibility.',
      },
      {
        'icon': Icons.speed,
        'title': 'Optimized Performance',
        'description':
            'Lightweight design ensures smooth operation without significant battery consumption.',
      },
      {
        'icon': Icons.update,
        'title': 'Regular Updates',
        'description':
            'Commitment to continuous improvement based on user feedback and technological advancements.',
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
                "Front-End Development",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint(
                'Flutter framework for cross-platform development',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Responsive UI that adapts to different screen sizes',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Custom animations for enhanced user experience',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Material Design principles for intuitive navigation',
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
                "Back-End Implementation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint(
                'Efficient state management for real-time tracking',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Local data storage for offline functionality',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Firebase integration for leaderboards and analytics',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Optimized calculations for accurate timing and scoring',
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
  Widget _buildUserBenefits() {
    final List<String> benefits = [
      'Skill Enhancement: Users can systematically improve their clicking speed, beneficial for gaming and other applications requiring rapid clicking.',
      'Community Building: Fosters a global community of enthusiasts who can challenge and motivate each other.',
      'Recognition and Motivation: Leaderboards and achievements provide users with goals, encouraging consistent engagement and improvement.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
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
            child: Text(
              benefit,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.cyanAccent.withOpacity(0.8),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDevelopmentTakeaways() {
    final List<Map<String, String>> takeaways = [
      {
        'title': 'Rapid Prototyping',
        'description':
            'Demonstrated ability to quickly develop a functional, polished application in a limited timeframe.',
      },
      {
        'title': 'Flutter Proficiency',
        'description':
            'Showcased expertise in Flutter development, including UI design, state management, and performance optimization.',
      },
      {
        'title': 'End-to-End Development',
        'description':
            'Successfully managed the entire development process from concept to publication on the Google Play Store.',
      }
    ];

    return Column(
      children: takeaways.map((takeaway) {
        return Container(
          width: double.infinity,
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
                takeaway['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                takeaway['description']!,
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

  // Helper widgets for Downloads Tab
  Widget _buildDownloadSection() {
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
            "GET CLICK SPEED PRO",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Click Speed Pro is available on the Google Play Store for Android devices.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TechButton(
                      onPressed: () => launchUrlExternal(
                          'https://play.google.com/store/apps/details?id=com.rdotapps.click_speed_pro&hl=en_US'),
                      label: "DOWNLOAD ON GOOGLE PLAY",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.touch_app,
                    color: Colors.cyanAccent,
                    size: 80,
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
    final List<String> improvements = [
      'iOS Version: Expand availability to iOS devices for broader reach.',
      'Advanced Analytics: Implement more detailed performance metrics and visualizations.',
      'Custom Challenges: Allow users to create and share custom challenge modes.',
      'Social Features: Add friend challenges and direct competition functionality.',
      'Achievement System: Develop a comprehensive achievement system for long-term engagement.'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: improvements.map((improvement) {
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
                  improvement,
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
}
