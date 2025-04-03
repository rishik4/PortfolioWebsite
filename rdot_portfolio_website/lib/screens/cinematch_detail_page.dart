import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class CineMatchDetailPage extends StatefulWidget {
  const CineMatchDetailPage({super.key});

  @override
  State<CineMatchDetailPage> createState() => _CineMatchDetailPageState();
}

class _CineMatchDetailPageState extends State<CineMatchDetailPage>
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
    1: 2, // Problem tab (pain points, market gaps)
    2: 2, // Solution tab (description, unique value)
    3: 3, // Features tab (main features, screenshots, interface)
    4: 2, // Technology tab (tech stack, implementation)
    5: 2, // Impact tab (user impact, revenue model)
    6: 2, // Download tab (app store links, pricing)
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
                        "CineMatchPro (BETA)",
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
                        // Content with app icon and movie theater background
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // App Icon
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.black,
                                  child: const Center(
                                    child: Icon(
                                      Icons.movie,
                                      color: Colors.cyanAccent,
                                      size: 60,
                                    ),
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
                                      "Movie Seat Finder & Auto-Booking",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Never settle for bad movie seats again. One-tap best seat selection and automatic booking.",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                        letterSpacing: 1,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Web app link button
                                    OutlinedButton(
                                      onPressed: () => launchUrlExternal(
                                          'https://cineemoviepro.web.app/'),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.cyanAccent),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.language,
                                              color: Colors.cyanAccent,
                                              size: 16),
                                          SizedBox(width: 8),
                                          Text(
                                            "Try the Web App",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                                Icons.people,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "9,000+ Total Rdot Users",
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
                                                Icons.auto_awesome,
                                                color: Colors.cyanAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Exclusive Auto-Booking",
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
                  "ABOUT CINEMATCHPRO",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "CineMatchPro is a breakthrough movie app designed to help users find the best movie theater seats "
                  "and book them automatically. Say goodbye to the hassle of manually checking every showtime and theater "
                  "— our app does the work for you, finding optimal seats based on your preferences.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "With real-time seat availability tracking, a custom seat-scoring algorithm, and seamless booking integration, "
                  "CineMatchPro offers a smooth, user-centric experience that revolutionizes how you book movie tickets. "
                  "It's part of Rdot Apps, with 9,000+ total users across all apps.",
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
                  "VALUE PROPOSITION",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildValuePropositionList(),
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
                  "THE PROBLEM",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Movie enthusiasts face several challenges when trying to secure the best possible seats, "
                  "especially for high-demand releases like Marvel movies or anime premieres.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildPainPointsCards(),
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
                              "No existing solutions provide automated optimal seat selection",
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
                        "While platforms like Fandango and AMC offer seat selection, they don't guide users "
                        "to the best available options or offer auto-booking for anticipated releases. "
                        "Additionally, no current service aggregates all theaters in an area to find the "
                        "optimal screening based on both time and seat quality preferences.",
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
                  "CineMatchPro eliminates the frustration of manually searching for movie tickets by automatically "
                  "identifying and booking the best available seats. Our solution focuses on saving users time and "
                  "ensuring the best possible movie-watching experience.",
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
                  "PREMIUM FEATURES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "CineMatchPro comes packed with innovative features designed to transform how you book movie tickets. "
                  "Our platform focuses on convenience, customization, and securing the best possible seats.",
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
                  "CineMatchPro leverages cutting-edge technologies to deliver a seamless movie ticket booking experience. "
                  "Our tech stack is designed for speed, reliability, and real-time data processing.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 40),
                _buildTechnologyCards(),
                const SizedBox(height: 40),
                // Backend Architecture Diagram
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Backend Architecture",
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
                            'assets/diagram.png',
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "System architecture showing how data flows through the CineMatchPro platform",
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
                  "IMPACT & GROWTH",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "CineMatchPro is transforming how people book movie tickets, creating measurable improvements in user experience "
                  "while building a sustainable business model.",
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
                        "User Impact",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildUserImpactSection(),
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
                        "Business Model",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildBusinessModel(),
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
                  "GET CINEMATCHPRO",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ready to transform your movie ticket booking experience? CineMatchPro is available on multiple platforms.",
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
                  "Pricing Plans",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPricingPlans(),
                const SizedBox(height: 40),
                const Text(
                  "Contact Us",
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
          _buildHighlightRow('Platform', 'iOS, Android, Web (Beta)'),
          const SizedBox(height: 15),
          _buildHighlightRow('Status', 'Available Now'),
          const SizedBox(height: 15),
          _buildHighlightRow('Theater Coverage', 'All major US theaters'),
          const SizedBox(height: 15),
          _buildHighlightRow(
              'Revenue Model', 'Affiliate commissions, Premium subscriptions'),
          const SizedBox(height: 15),
          _buildHighlightRow('Technologies',
              'Flutter, Selenium, Playwright, Firebase, Google Cloud'),
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

  Widget _buildValuePropositionList() {
    final List<String> values = [
      'Save time by automatically finding and booking the best available movie seats',
      'Secure premium seats for high-demand releases with auto-booking on ticket release',
      'Compare theaters and showtimes in one place to find your optimal viewing experience',
      'Customize your experience with saved preferences for theater, seating style, and time windows',
      'Monetize your booking through our affiliate program - free app, real value',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values.map((item) {
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
            "READY TO ELEVATE YOUR MOVIE EXPERIENCE?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          TechButton(
            onPressed: () =>
                launchUrlExternal('https://cineemoviepro.web.app/'),
            label: "TRY CINEMATCHPRO NOW",
          ),
          const SizedBox(height: 15),
          Text(
            'iOS and Android apps coming soon',
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
  Widget _buildPainPointsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildPainPointCard(
            'Inefficient Seat Booking',
            'Moviegoers struggle to find good seats, especially for high-demand releases like Marvel movies or anime premieres.',
            Icons.event_seat,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildPainPointCard(
            'Manual Searching Required',
            'Current ticketing platforms require users to check every theater and time slot individually — wasting time and often leading to subpar booking experiences.',
            Icons.search,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildPainPointCard(
            'Poor Seat Optimization',
            'Even when good seats are available, users may not know which to choose. Many apps show only availability, not seat quality or viewing experience.',
            Icons.thumbs_up_down,
          ),
        ),
      ],
    );
  }

  Widget _buildPainPointCard(String title, String description, IconData icon) {
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
        'title': 'Automated Seat Selection',
        'description':
            'The app pre-selects the best available seats based on custom scoring — balancing distance from screen, centeredness, and seat spacing.',
      },
      {
        'title': 'Pre-Booking Engine',
        'description':
            'For unreleased movies, users can opt in to automatically book as soon as tickets drop, guaranteeing prime seats for anticipated blockbusters.',
      },
      {
        'title': 'Multi-Theater Support',
        'description':
            'Search across every theater in a region to find the optimal screening in one tap, comparing both seat quality and preferred showtimes.',
      },
      {
        'title': 'User Preferences',
        'description':
            'Supports favorite theaters, seat preferences (aisle, middle, front/back), and time windows to personalize every booking experience.',
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
            "Unlike standard ticketing apps that simply show seat availability, CineMatchPro intelligently analyzes "
            "theater layouts to recommend the absolute best viewing experience. Our proprietary seat scoring algorithm "
            "considers factors that cinema enthusiasts care about: ideal viewing angle, not too close to others, "
            "perfect distance from the screen, and center alignment.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Plus, our unique auto-booking system for anticipated releases means you'll never miss out on opening night "
            "tickets again — the app handles the refresh-and-book process automatically when tickets become available.",
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
        'icon': Icons.calculate,
        'title': 'Seat Score Algorithm',
        'description':
            'A custom formula calculates a score for every available seat based on visibility, symmetry, and proximity to other seats.',
      },
      {
        'icon': Icons.notification_important,
        'title': 'Auto Booking',
        'description':
            'Uses notification-based triggers to auto-purchase tickets for anticipated releases — a feature not available on competitor platforms.',
      },
      {
        'icon': Icons.security,
        'title': 'Secure Checkout',
        'description':
            'Your payment information is securely stored and processed through industry-standard encryption methods.',
      },
      {
        'icon': Icons.dashboard,
        'title': 'Minimal Interface',
        'description':
            'Strips away clutter and gives users only the necessary info to make the fastest and smartest decision.',
      },
      {
        'icon': Icons.group,
        'title': 'Group Booking',
        'description':
            'Easily coordinate tickets for groups, ensuring everyone gets seated together in the optimal arrangement.',
      },
      {
        'icon': Icons.movie_filter,
        'title': 'Preview Integration',
        'description':
            'Watch trailers, read reviews, and check movie details directly within the app before making your booking decision.',
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

  Widget _buildInterfacePreview() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
                    Icons.phone_android,
                    color: Colors.cyanAccent,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "App Screenshots",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Coming Soon",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TechButton(
                    onPressed: () =>
                        launchUrlExternal('https://cineemoviepro.web.app/'),
                    label: "TRY THE WEB VERSION",
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "HOW IT WORKS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "1. Select a movie you want to watch",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.cyanAccent.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    "2. Enter your preferred theaters and time window",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.cyanAccent.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    "3. The app scans all available options",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.cyanAccent.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    "4. Review the top recommended seats",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.cyanAccent.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    "5. One-tap checkout through our partner sites",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.cyanAccent.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
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
        'title': 'Flutter/Dart',
        'description':
            'For building cross-platform apps that run smoothly on Android, iOS, and Web from a single codebase.',
      },
      {
        'icon': Icons.storage,
        'title': 'Google Cloud Run',
        'description':
            'Handles backend API calls, enabling fast and scalable seat lookups with on-demand computing resources.',
      },
      {
        'icon': Icons.analytics,
        'title': 'Firebase Analytics',
        'description':
            'Tracks user behavior to improve app features and optimize the booking experience.',
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
                "Data Collection & Processing",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint(
                'Selenium & Playwright for real-time web scraping of theater seat maps and availability',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Custom API connections to major ticketing providers for secure data access',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Proprietary seat-scoring algorithm to calculate optimal viewing positions',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Efficient data caching to minimize API calls and improve performance',
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
                "User Experience & Security",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint(
                'Responsive UI built with Flutter for consistent experience across devices',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'OAuth 2.0 authentication for secure third-party checkout integration',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Secure API token management for user authentication and preference storing',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Real-time notification system for ticket availability alerts',
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
  Widget _buildUserImpactSection() {
    final List<Map<String, String>> metrics = [
      {'value': 'Minutes Saved', 'label': '10-15 Per Booking'},
      {'value': 'Seat Quality', 'label': '85% Improvement'},
      {'value': 'User Satisfaction', 'label': '92% Positive'},
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
                          "Saved the groupchat from last-minute chaos when planning our Marvel night.",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: Colors.cyanAccent.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "— Alex K., Early User",
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
                          "It booked better seats than I ever could and saved me from constantly refreshing the ticketing site.",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: Colors.cyanAccent.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "— Jamie T., Premium User",
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

  Widget _buildBusinessModel() {
    final List<Map<String, String>> features = [
      {
        'title': 'Affiliate Revenue',
        'description':
            'Earns \$0.10 per ticket sold through Fandango integration, with plans to expand to additional ticketing services',
      },
      {
        'title': 'Premium Subscription',
        'description':
            'Optional premium tier (\$3.99/month) provides advanced features like auto-booking, priority processing, and exclusive deals',
      },
      {
        'title': 'Theater Partnerships',
        'description':
            'In development: Direct partnerships with theater chains for enhanced functionality and additional revenue streams',
      },
      {
        'title': 'Future Expansion',
        'description':
            'Planned international rollout and integration with additional entertainment venues (concerts, sporting events)',
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
                  Icons.language,
                  color: Colors.cyanAccent,
                  size: 60,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Web Version",
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
                  onPressed: () =>
                      launchUrlExternal('https://cineemoviepro.web.app/'),
                  label: "TRY WEB VERSION",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
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
                  Icons.phone_iphone,
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
                  "Coming Soon",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                TechButton(
                  onPressed: () {},
                  label: "JOIN WAITLIST",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
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
                  "Coming Soon",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                TechButton(
                  onPressed: () {},
                  label: "JOIN WAITLIST",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingPlans() {
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
                const Text(
                  "FREE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "\$0",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                _buildPricingFeature("Seat optimization"),
                _buildPricingFeature("Theater comparison"),
                _buildPricingFeature("Basic recommendations"),
                _buildPricingFeature("Standard support"),
                const SizedBox(height: 30),
                TechButton(
                  onPressed: () =>
                      launchUrlExternal('https://cineemoviepro.web.app/'),
                  label: "GET STARTED",
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
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "RECOMMENDED",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "PREMIUM",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      "3.99",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      "/mo",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.cyanAccent.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPricingFeature("Everything in Free"),
                _buildPricingFeature("Auto-booking for new releases"),
                _buildPricingFeature("Priority processing"),
                _buildPricingFeature("Advanced preferences"),
                _buildPricingFeature("Premium support"),
                const SizedBox(height: 30),
                TechButton(
                  onPressed: () =>
                      launchUrlExternal('https://cineemoviepro.web.app/'),
                  label: "UPGRADE NOW",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.cyanAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            feature,
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.9),
            ),
          ),
        ],
      ),
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
                "support@cinematchpro.com",
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
                Icons.chat,
                color: Colors.cyanAccent,
                size: 40,
              ),
              const SizedBox(height: 10),
              const Text(
                "Live Chat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Available 9am-5pm EST",
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
        ],
      ),
    );
  }
}
