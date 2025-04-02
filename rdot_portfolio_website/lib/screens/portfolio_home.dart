import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/terminal.dart';
import '../widgets/nav_button.dart';
import '../widgets/glitch_text.dart';
import 'home_page.dart';
import 'about_page.dart';
import 'projects_page.dart';
import 'experiences_page.dart';
import 'skills_page.dart';
import 'contact_page.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _terminalController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _backgroundAnimationController;
  late AnimationController _glitchController;

  // Scroll controller and state
  final ScrollController _scrollController = ScrollController();
  int _currentSection = 0;
  bool _showGlitch = false;
  bool _showMainContent = false;
  bool _isScrolling = false;

  // Section titles and keys for navigation
  final List<String> _sectionTitles = [
    'HOME',
    'ABOUT',
    'PROJECTS',
    'EXPERIENCES',
    'SKILLS',
    'CONTACT'
  ];

  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();

    // Terminal animation setup
    _terminalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward().then((_) {
        setState(() {
          _showMainContent = true;
        });
        _fadeController.forward();
      });

    // Fade-in animation for main content
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Background animation setup
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Glitch effect animation setup
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Trigger random glitch effects
    Future.delayed(const Duration(seconds: 2), () {
      _triggerRandomGlitch();
    });

    // Add scroll listener
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_isScrolling) {
      _updateCurrentSection();
    }
  }

  void _updateCurrentSection() {
    double offset = _scrollController.offset;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        if (position.dy <= 100 && position.dy + box.size.height > 0) {
          if (_currentSection != i) {
            setState(() {
              _currentSection = i;
            });
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      setState(() {
        _isScrolling = true;
      });

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      ).then((_) {
        setState(() {
          _isScrolling = false;
          _currentSection = index;
        });
      });
    }
  }

  void _snapToNearestSection() {
    if (_isScrolling) return;

    double minDistance = double.infinity;
    int targetIndex = _currentSection;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        final distance = position.dy.abs();
        if (distance < minDistance) {
          minDistance = distance;
          targetIndex = i;
        }
      }
    }

    if (targetIndex != _currentSection) {
      _scrollToSection(targetIndex);
    }
  }

  void _triggerRandomGlitch() {
    if (!mounted) return;

    Future.delayed(Duration(milliseconds: math.Random().nextInt(5000) + 1000),
        () {
      if (!mounted) return;

      setState(() {
        _showGlitch = true;
      });

      _glitchController.forward(from: 0).then((_) {
        if (!mounted) return;
        setState(() {
          _showGlitch = false;
        });
        _triggerRandomGlitch();
      });
    });
  }

  @override
  void dispose() {
    _terminalController.dispose();
    _fadeController.dispose();
    _backgroundAnimationController.dispose();
    _glitchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter:
                    TechBackgroundPainter(_backgroundAnimationController.value),
                child: Container(),
                size: Size.infinite,
              );
            },
          ),

          // Grid texture overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://i.imgur.com/vzePCxZ.png'),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ),

          // Initial loading terminal
          Center(
            child: AnimatedBuilder(
              animation: _terminalController,
              builder: (context, child) {
                return Opacity(
                  opacity: _terminalController.value < 0.8
                      ? 1.0
                      : 1.0 - (_terminalController.value - 0.8) * 5,
                  child: const Terminal(
                    prompt: '~/user >',
                    command: 'load user.profile',
                    response: 'Profile loaded successfully',
                  ),
                );
              },
            ),
          ),

          // Main content
          if (_showMainContent)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                children: [
                  // Sidebar navigation
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      border: Border(
                          right: BorderSide(
                              color: Colors.cyanAccent.withOpacity(0.3))),
                    ),
                    child: Column(
                      children: [
                        // Header with logo and social icons
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              GlitchText(
                                text: 'RDOT',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.cyanAccent,
                                ),
                                glitchEnabled: _showGlitch,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.email,
                                        color: Colors.cyanAccent),
                                    onPressed: () => launchUrlExternal(
                                        'mailto:rishikb@utexas.edu'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.code,
                                        color: Colors.cyanAccent),
                                    onPressed: () => launchUrlExternal(
                                        'https://github.com/rishik4'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.link,
                                        color: Colors.cyanAccent),
                                    onPressed: () => launchUrlExternal(
                                        'https://www.linkedin.com/in/rishik-boddeti-9773b5239/'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Navigation buttons
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _sectionTitles.length,
                              (index) => NavButton(
                                title: _sectionTitles[index],
                                isSelected: _currentSection == index,
                                onTap: () => _scrollToSection(index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content area with sections
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          _snapToNearestSection();
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            // Home section
                            Container(
                              key: _sectionKeys[0],
                              height: MediaQuery.of(context).size.height,
                              child: HomePage(showGlitch: _showGlitch),
                            ),
                            const SizedBox(height: 150),

                            // About section
                            Container(
                              key: _sectionKeys[1],
                              height: MediaQuery.of(context).size.height,
                              child: const AboutPage(),
                            ),
                            const SizedBox(height: 150),

                            // Projects section
                            Container(
                              key: _sectionKeys[2],
                              height: MediaQuery.of(context).size.height,
                              child: const ProjectsPage(),
                            ),
                            const SizedBox(height: 150),

                            // Experiences section
                            Container(
                              key: _sectionKeys[3],
                              height: MediaQuery.of(context).size.height + 200,
                              child: const ExperiencesPage(),
                            ),
                            const SizedBox(height: 150),

                            // Skills section
                            Container(
                              key: _sectionKeys[4],
                              height: MediaQuery.of(context).size.height,
                              child: const SkillsPage(),
                            ),
                            const SizedBox(height: 150),

                            // Contact section
                            Container(
                              key: _sectionKeys[5],
                              height: MediaQuery.of(context).size.height,
                              child: const ContactPage(),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Glitch effect overlay
          if (_showGlitch)
            Positioned.fill(
              child: AnimatedBuilder(
                  animation: _glitchController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: GlitchPainter(_glitchController.value),
                      size: Size.infinite,
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
