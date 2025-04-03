import 'package:flutter/material.dart';
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/tech_button.dart';

class ICogDetailPage extends StatefulWidget {
  const ICogDetailPage({super.key});

  @override
  State<ICogDetailPage> createState() => _ICogDetailPageState();
}

class _ICogDetailPageState extends State<ICogDetailPage>
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
    'Media'
  ];

  // Animation controllers for tab transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Create slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation for the initial tab
    _animationController.forward();
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
                        "iCog",
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

                  // Hero section
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
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Dementia Screening App",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.cyanAccent,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Early-stage dementia screening app used by over 13,000 users across 83 countries",
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
                                      color: Colors.black.withOpacity(0.5),
                                      border: Border.all(
                                        color:
                                            Colors.cyanAccent.withOpacity(0.5),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.cyanAccent,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Congressional App Challenge Winner",
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
                                      color: Colors.black.withOpacity(0.5),
                                      border: Border.all(
                                        color:
                                            Colors.cyanAccent.withOpacity(0.5),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.cyanAccent,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "NYEPC Winner",
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

                  // Tab content with animation
                  AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildTabContent(),
                          ),
                        );
                      }),
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
        return _buildMediaTab();
      default:
        return _buildOverviewTab();
    }
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ABOUT ICOG",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "iCog is an innovative app designed to administer early-stage cognitive screening tests for "
          "dementia, making healthcare more accessible to people worldwide. The app has been successfully "
          "adopted by over 13,000 users across 83 countries, demonstrating its global impact and usability.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "In partnership with Mini-Cog, a non-profit organization that creates screening tests for dementia "
          "in primary care, iCog brings medical-grade cognitive assessment tools to anyone with a smartphone "
          "or internet connection, breaking down barriers to early detection.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        _buildInfoCard(),
        const SizedBox(height: 40),
        const Text(
          "RECOGNITION",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildRecognitionList(),
        const SizedBox(height: 40),
        _buildLinksSection(),
      ],
    );
  }

  // Problem Tab
  Widget _buildProblemTab() {
    return Column(
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
          "According to the World Health Organization, around 55 million people have a Dementia-related illness. "
          "This number is rising rapidly and is expected to reach 139 million by 2050.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "There are an estimated 41 million cases of Dementia around the world that are undiagnosed, "
          "with over 90% of undiagnosed cases in low-middle-income countries.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        _buildStatisticsCards(),
        const SizedBox(height: 40),
        const Text(
          "Key Barriers to Diagnosis",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildBarrierCards(),
        const SizedBox(height: 40),
        const Text(
          "The Importance of Early Detection",
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
            "Early detection is crucial as it allows for earlier intervention and treatment, which can be more effective "
            "at mitigating the progression of the disease. Some types of cognitive impairment, such as those caused by "
            "head injuries, can be treated or mitigated with proper help. Taking action early is essential for planning "
            "and implementing support strategies before symptoms progress too far.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.cyanAccent,
            ),
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
          "iCog makes neurological tests doctors use to screen for Dementia available in the form of a mobile "
          "app and website. The goal is to expand accessibility of accurate screening by making it free and "
          "available through any smartphone or internet connection, so anyone can access it anywhere at any time.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          "Key Features",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildFeaturesList(),
        const SizedBox(height: 40),
        const Text(
          "Target Users",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildTargetUserCards(),
      ],
    );
  }

  // Innovation Tab
  Widget _buildInnovationTab() {
    return Column(
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
          "There are no easily accessible tools that can accurately screen for Dementia at its early stages. "
          "iCog stands out as the only accurate digital version of screening for Dementia, with several "
          "innovative aspects that make it unique in the healthcare landscape.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        _buildInnovationCards(),
        const SizedBox(height: 40),
        const Text(
          "Partnerships",
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
                      Icons.handshake,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Partnership with Dr. Soo Borson, creator of the Mini-Cog",
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
                "The partnership with Dr. Soo Borson, creator of the Mini-Cog, ensures that iCog is always up-to-date "
                "with the newest research and practices in cognitive screening. This collaboration increases the app's "
                "credibility and recognition, facilitating adoption by both healthcare professionals and users worldwide, "
                "ultimately leading to more accurate screenings and better outcomes for those affected by dementia.",
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
    );
  }

  // Technology Tab
  Widget _buildTechnologyTab() {
    return Column(
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
          "iCog leverages cutting-edge technologies to deliver a reliable, accessible, and user-friendly "
          "dementia screening platform. The core technologies powering the solution include:",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        _buildTechnologyCards(),
        const SizedBox(height: 40),
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
    );
  }

  // Impact Tab
  Widget _buildImpactTab() {
    return Column(
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
          "iCog has already made a significant impact in dementia screening accessibility, but our vision extends "
          "much further. Here's how we're making a difference and our plans for the future:",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Impact",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildImpactMetrics(),
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
                    "Future Goals",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFutureGoals(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Media Tab
  Widget _buildMediaTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MEDIA & RESOURCES",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Explore videos, presentations, and additional resources about the iCog project.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 40),
        _buildVideoSection(),
        const SizedBox(height: 40),
        const Text(
          "News Coverage",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildNewsVideosSection(),
        const SizedBox(height: 40),
        const Text(
          "Recognition & Press Coverage",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildRecognitionCards(),
        const SizedBox(height: 40),
        const Text(
          "Try iCog",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 20),
        _buildResourceLinks(),
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
            "PROJECT HIGHLIGHTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildHighlightRow('Users', '13,000+ across 83 countries'),
          const SizedBox(height: 15),
          _buildHighlightRow('Status', 'Active Development'),
          const SizedBox(height: 15),
          _buildHighlightRow('Timeline', 'June 2022 - Present'),
          const SizedBox(height: 15),
          _buildHighlightRow('Role', 'Creator & Lead Developer'),
          const SizedBox(height: 15),
          _buildHighlightRow(
              'Technologies', 'Flutter, Firebase, AI/ML, Cloud Computing'),
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

  Widget _buildRecognitionList() {
    final List<String> recognitions = [
      'Winner of the Congressional App Challenge',
      'Winner of National Young Entrepreneurship Pitch Challenge',
      'Received recognition from Congressman Michael McCaul',
      'Currently working with Dr. Soo Borson (USC) on publishing research',
      'Featured in multiple news outlets and tech publications',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recognitions.map((item) {
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

  Widget _buildLinksSection() {
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
            "LINKS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => launchUrlExternal('https://mini-cog.com/'),
            child: Row(
              children: [
                const Icon(
                  Icons.link,
                  color: Colors.cyanAccent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Mini-Cog Official Website',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => launchUrlExternal('https://rishik4.github.io/webcog'),
            child: Row(
              children: [
                const Icon(
                  Icons.language,
                  color: Colors.cyanAccent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'iCog Web Version',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => launchUrlExternal(
                'https://www.congressionalappchallenge.us/22-tx10/'),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.cyanAccent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Congressional App Challenge Project Page',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyanAccent.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for Problem Tab
  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('55M', 'People with dementia worldwide'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard('41M', 'Undiagnosed cases globally'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard('139M', 'Projected cases by 2050'),
        ),
      ],
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarrierCards() {
    return Row(
      children: [
        Expanded(
          child: _buildBarrierCard(
            'Limited Access',
            'Many people lack access to medical facilities due to prohibitive costs and limited availability, especially in developing areas.',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildBarrierCard(
            'Overwhelmed Healthcare',
            'Available medical facilities are often overwhelmed, causing significant delays that discourage people from seeking the medical help they need.',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildBarrierCard(
            'Social Stigma',
            "There's significant stigma associated with seeking medical help for cognitive issues. About 1 in 3 people believe nothing can be done about Dementia.",
          ),
        ),
      ],
    );
  }

  Widget _buildBarrierCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 10),
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
    );
  }

  // Helper widgets for Solution Tab
  Widget _buildFeaturesList() {
    final List<Map<String, String>> features = [
      {
        'title': 'Medical-Grade Tests',
        'description':
            'Includes validated tests like the Mini-Cog that can effectively screen for dementia in its early stages',
      },
      {
        'title': 'Progress Tracking',
        'description':
            'Displays user scores on a graph to show the rate of change over time, facilitating early detection of decline',
      },
      {
        'title': 'Secure Data Storage',
        'description':
            'All data is stored anonymously in a secure cloud database, personalizing the experience while maintaining privacy',
      },
      {
        'title': 'Accessibility Features',
        'description':
            'Text-to-speech capabilities, multiple language support, and customizable interface for users with various impairments',
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

  Widget _buildTargetUserCards() {
    final List<Map<String, String>> users = [
      {
        'title': 'Primary Users',
        'description':
            'Elderly individuals concerned about cognitive health, especially those with limited access to healthcare',
      },
      {
        'title': 'Secondary Users',
        'description':
            'Family members and caregivers who support seniors with potential cognitive impairment',
      },
      {
        'title': 'Healthcare Partners',
        'description':
            'Medical professionals who can utilize the data and results to make informed diagnostic decisions',
      },
    ];

    return Column(
      children: users.map((user) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user['description']!,
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

  // Helper widgets for Innovation Tab
  Widget _buildInnovationCards() {
    final List<Map<String, String>> innovations = [
      {
        'title': 'Exclusive Digital Adaptation',
        'description':
            'iCog is the only app given permission to digitalize the Mini-Cog test for dementia screening, providing a validated and trusted assessment tool in digital format.',
      },
      {
        'title': 'Accessibility Without Barriers',
        'description':
            'Removes language and location barriers through multi-language support and availability on both web and mobile platforms, even working offline in areas with limited connectivity.',
      },
      {
        'title': 'Privacy-First Approach',
        'description':
            'Complete anonymity addresses the social stigma associated with getting help for dementia, encouraging more people to take the screening test without fear of judgment.',
      },
      {
        'title': 'Research Integration',
        'description':
            'Anonymous data collection enables further research and analysis, contributing to a better understanding of dementia patterns and potentially leading to improved screening methods.',
      },
      {
        'title': 'AI-Powered Assessment',
        'description':
            'Uses artificial intelligence to analyze user-drawn clocks, a critical component of the Mini-Cog test, providing consistent and objective evaluation.',
      },
      {
        'title': 'Adaptive Interface',
        'description':
            'Features like adjustable text size, contrast filters, volume settings, and family member assistance accommodate various disabilities and needs of elderly users.',
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
        'icon': Icons.phone_android,
        'title': 'Flutter Framework',
        'description':
            'Used to create a cross-platform app that works on multiple devices (iOS, Android, web) from a single codebase, ensuring consistent experience across platforms.',
      },
      {
        'icon': Icons.cloud,
        'title': 'Firebase/Cloud Services',
        'description':
            'Provides secure data storage, authentication, and hosting capabilities, allowing users to access their information across devices while maintaining privacy.',
      },
      {
        'icon': Icons.psychology,
        'title': 'AI/Machine Learning',
        'description':
            'Neural networks analyze user-drawn clocks as part of the Mini-Cog test, providing consistent and objective evaluation of this critical diagnostic element.',
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
                'Responsive UI that adapts to different screen sizes and device capabilities',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Custom drawing canvas for the clock-drawing test with precise input capture',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Accessibility features including screen reader support, high contrast modes, and text size adjustment',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Multi-language support with localization for global accessibility',
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
                'Secure data encryption for sensitive health information',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Anonymous data collection pipeline for research while maintaining user privacy',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Offline functionality with data synchronization when connectivity is restored',
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                'Scalable architecture designed to handle millions of users worldwide',
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
  Widget _buildImpactMetrics() {
    final List<Map<String, String>> metrics = [
      {'value': '13,000+', 'label': 'Active Users'},
      {'value': '83', 'label': 'Countries Reached'},
      {'value': 'Multiple', 'label': 'Awards & Recognition'},
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

  Widget _buildUserBenefits() {
    final List<String> benefits = [
      'Early detection of cognitive impairment',
      'Increased healthcare accessibility',
      'Reduced stigma through anonymous testing',
      'Earlier medical intervention',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "User Benefits",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: benefits.map((benefit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFutureGoals() {
    final List<Map<String, String>> goals = [
      {
        'title': 'Scale & Reach',
        'description':
            'Expand to serve tens of millions of users globally in the next year, focusing on regions with limited healthcare infrastructure.',
      },
      {
        'title': 'Research Publication',
        'description':
            "Complete and publish research with Dr. Soo Borson to scientifically validate the app's efficacy and document its global impact.",
      },
      {
        'title': 'Healthcare Integration',
        'description':
            'Develop secure pathways for users to share results with healthcare providers, bridging the gap between self-screening and professional diagnosis.',
      },
      {
        'title': 'Technical Enhancements',
        'description':
            'Implement cloud infrastructure scaling to support millions of users and enhance security measures to maintain data privacy and compliance with healthcare regulations.',
      },
    ];

    return Column(
      children: goals.map((goal) {
        return Container(
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
                goal['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                goal['description']!,
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

  // Helper widgets for Media Tab
  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "iCog Demonstration",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: TechButton(
                        onPressed: () => launchUrlExternal(
                            'https://www.youtube.com/watch?v=wGpsfhuHGIs'),
                        label: "WATCH VIDEO",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "A comprehensive demonstration of the iCog app and its features",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
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
                    "Project Presentation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: TechButton(
                        onPressed: () => launchUrlExternal(
                            'https://www.youtube.com/watch?v=1PrdqEceBt0'),
                        label: "WATCH VIDEO",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Presentation explaining the project's goals, implementation, and impact",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // News videos section for Media tab
  Widget _buildNewsVideosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CBS Austin News Coverage",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: TechButton(
                        onPressed: () => launchUrlExternal(
                            'https://www.youtube.com/watch?v=6Y4QOJyGtJc'),
                        label: "WATCH NEWS CLIP",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "CBS Austin news coverage about the iCog app and its impact",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
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
                    "KVUE News Feature",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: TechButton(
                        onPressed: () => launchUrlExternal(
                            'https://www.youtube.com/watch?v=3D-XUG3nF6Q'),
                        label: "WATCH NEWS FEATURE",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "KVUE's feature story on how the iCog app is helping screen for dementia",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecognitionCards() {
    final List<Map<String, String>> recognitions = [
      {
        'title': 'Congressional App Challenge',
        'description':
            'Winner in the annual coding competition hosted by Members of Congress',
      },
      {
        'title': 'National Young Entrepreneurship Pitch Challenge',
        'description':
            'Recognized for innovation and entrepreneurial potential',
      },
      {
        'title': 'Congressman Michael McCaul',
        'description':
            "Received official recognition for the app's potential impact on healthcare",
      },
    ];

    return Row(
      children: recognitions.map((recognition) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recognition['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recognition['description']!,
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
      }).toList(),
    );
  }

  Widget _buildResourceLinks() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => launchUrlExternal('https://rishik4.github.io/webcog'),
            child: Container(
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
                          Icons.language,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "Web Version",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Access the iCog web application from any browser, no installation required.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Try the web version",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.cyanAccent,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: GestureDetector(
            onTap: () => launchUrlExternal('https://mini-cog.com/'),
            child: Container(
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
                          Icons.psychology,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "Mini-Cog",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Learn more about the Mini-Cog test and its applications in dementia screening.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Visit Mini-Cog website",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.cyanAccent,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
