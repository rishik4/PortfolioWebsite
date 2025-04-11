import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/painters.dart';
import '../utils/url_launcher_utils.dart';
import '../utils/responsive_layout.dart';
import '../widgets/terminal.dart';
import '../widgets/nav_button.dart';
import '../widgets/glitch_text.dart';
import '../widgets/mobile_drawer.dart';
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
  // Expose this state to child widgets for navigation
  static _PortfolioHomeState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PortfolioHomeState>();

  // Animation controllers
  late AnimationController _terminalController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _backgroundAnimationController;
  late AnimationController _glitchController;

  // Terminal animation specific controllers
  late AnimationController _terminalEntranceController;
  late Animation<double> _terminalWidthAnimation;
  late Animation<double> _terminalHeightAnimation;

  // Command typing animation (inside terminal)
  late AnimationController _commandTypingController;

  // Automated cursor animation
  late AnimationController _cursorController;
  late Animation<Offset> _cursorPositionAnimation;
  Offset _cursorPosition = Offset(0, 0);

  // Terminal state
  bool _terminalReady = false;
  bool _terminalClosed = false;
  bool _showSplitTerminal = false;

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

    // Terminal entrance animation (rectangle appearing and expanding)
    _terminalEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _terminalWidthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _terminalEntranceController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _terminalHeightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _terminalEntranceController,
        curve: Interval(0.3, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Command typing animation - happens inside the terminal after it opens
    _commandTypingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Terminal content animation (output after command)
    _terminalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Automated cursor animation
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Define cursor path animation
    _cursorPositionAnimation = TweenSequence<Offset>([
      // Start position (center-ish)
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(0, 0),
          end: Offset(0, -30), // Move up a bit
        ),
        weight: 10,
      ),
      // Move to typing area
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(0, -30),
          end: Offset(-100, 0), // Move to command area
        ),
        weight: 15,
      ),
      // Small pause at typing area
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(-100, 0),
          end: Offset(-105, 5), // Slight movement while "typing"
        ),
        weight: 25,
      ),
      // After typing, move to close button
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(-105, 5),
          end: Offset(100, -95), // Move to close button position
        ),
        weight: 30,
      ),
      // Hover around close button
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(100, -95),
          end: Offset(103, -94), // Small hover movement near close button
        ),
        weight: 10,
      ),
      // "Click" motion - slight push
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(103, -94),
          end: Offset(102, -93), // Slight push motion to simulate click
        ),
        weight: 5,
      ),
      // Hold at click position
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(102, -93),
          end: Offset(102, -93), // Stay in place
        ),
        weight: 5,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _cursorController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to cursor animation to show split terminal and auto-close
    _cursorController.addListener(() {
      // Show split terminal when cursor is near typing area
      if (_cursorController.value > 0.2 &&
          _cursorController.value < 0.4 &&
          !_showSplitTerminal &&
          _terminalReady) {
        setState(() {
          _showSplitTerminal = true;
        });
      }

      // Auto-close when animation reaches the "click" part
      if (_cursorController.value >= 0.9 && !_terminalClosed) {
        _closeTerminal();
      }

      // Update cursor position for rendering
      setState(() {
        _cursorPosition = _cursorPositionAnimation.value;
      });
    });

    // Start the animation sequence
    _terminalEntranceController.forward().then((_) {
      // After terminal is open, start typing the command
      _commandTypingController.forward().then((_) {
        _terminalController.forward().then((_) {
          setState(() {
            _terminalReady = true;
          });
          // Start automated cursor movement
          _cursorController.forward();
        });
      });
    });

    // Fade-in animation for main content
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

  // Function to handle terminal close button click
  void _closeTerminal() {
    setState(() {
      _terminalClosed = true;
      _cursorController.stop(); // Stop cursor animation
    });

    // After a short delay to show the close animation, show the main content
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showMainContent = true;
      });
      _fadeController.forward();
    });
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
    _commandTypingController.dispose();
    _terminalController.dispose();
    _fadeController.dispose();
    _backgroundAnimationController.dispose();
    _glitchController.dispose();
    _terminalEntranceController.dispose();
    _cursorController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // Add app bar for mobile view
      appBar: isMobile && _showMainContent
          ? AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: GlitchText(
                text: 'RDOT',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.cyanAccent,
                ),
                glitchEnabled: _showGlitch,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.cyanAccent),
                  onPressed: () =>
                      launchUrlExternal('mailto:rishikb@utexas.edu'),
                ),
              ],
            )
          : null,
      // Add drawer for mobile view
      drawer: isMobile && _showMainContent
          ? MobileDrawer(
              sectionTitles: _sectionTitles,
              currentSection: _currentSection,
              onSectionSelected: _scrollToSection,
              showGlitch: _showGlitch,
            )
          : null,
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

          // Grid texture overlay - now using asset
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/grid_texture.png'),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ),

          // Terminal animation
          if (!_showMainContent)
            Center(
              child: Stack(
                alignment: Alignment.center, // Ensure the terminal is centered
                children: [
                  // Terminal window
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_terminalEntranceController, _terminalController]),
                    builder: (context, child) {
                      // Calculate terminal size based on screen size
                      final baseWidth = ResponsiveLayout.value(
                        context: context,
                        mobile: 300.0,
                        desktop: 500.0,
                      );
                      final baseHeight =
                          300.0; // Taller to accommodate split terminal

                      // Apply entrance animations
                      final width = baseWidth * _terminalWidthAnimation.value;
                      final height =
                          baseHeight * _terminalHeightAnimation.value;

                      // Apply exit animation if terminal is being closed
                      final scale = _terminalClosed ? 0.0 : 1.0;

                      return AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInBack,
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.7),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _terminalEntranceController.value < 1.0
                              ? Container() // Still opening the terminal
                              : Stack(
                                  children: [
                                    // Terminal header
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.cyanAccent
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "RDOT:// SYSTEM TERMINAL",
                                              style: TextStyle(
                                                color: Colors.cyanAccent,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Close button
                                            GestureDetector(
                                              onTap: _closeTerminal,
                                              child: Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  color: _cursorPosition
                                                              .distanceTo(
                                                                  Offset(100,
                                                                      -95)) <
                                                          20
                                                      ? Colors.redAccent
                                                      : Colors.redAccent
                                                          .withOpacity(0.7),
                                                  shape: BoxShape.circle,
                                                  boxShadow:
                                                      _cursorController.value >=
                                                              0.9
                                                          ? [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .redAccent
                                                                    .withOpacity(
                                                                        0.6),
                                                                spreadRadius: 2,
                                                                blurRadius: 4,
                                                              )
                                                            ]
                                                          : null,
                                                  border: _cursorPosition
                                                              .distanceTo(
                                                                  Offset(100,
                                                                      -95)) <
                                                          20
                                                      ? Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          width: 1,
                                                        )
                                                      : null,
                                                ),
                                                child: _cursorPosition
                                                            .distanceTo(Offset(
                                                                100, -95)) <
                                                        20
                                                    ? Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 8,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Main terminal content area (command typing happens after terminal opens)
                                    Positioned(
                                      top: 35,
                                      left: 15,
                                      right: 15,
                                      bottom: _showSplitTerminal ? 130 : 15,
                                      child: Container(
                                        decoration: _showSplitTerminal
                                            ? BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.cyanAccent
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                              )
                                            : null,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Animated command typing
                                            AnimatedBuilder(
                                              animation:
                                                  _commandTypingController,
                                              builder: (context, child) {
                                                final textValue =
                                                    _commandTypingController
                                                        .value;
                                                final command =
                                                    'load user.profile';
                                                final visibleChars =
                                                    (command.length * textValue)
                                                        .round();
                                                final visibleText = command
                                                    .substring(0, visibleChars);

                                                return Text(
                                                  '~/user > $visibleText${textValue < 1.0 ? '|' : ''}',
                                                  style: const TextStyle(
                                                    color: Colors.cyanAccent,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Split terminal output area (appears after command is typed)
                                    if (_showSplitTerminal)
                                      Positioned(
                                        left: 15,
                                        right: 15,
                                        bottom: 15,
                                        height: 100,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Output header
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.cyanAccent
                                                        .withOpacity(0.7),
                                                    size: 12,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "SYSTEM OUTPUT",
                                                    style: TextStyle(
                                                      color: Colors.cyanAccent
                                                          .withOpacity(0.7),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              // Animated system output
                                              TweenAnimationBuilder<int>(
                                                tween: IntTween(
                                                    begin: 0,
                                                    end: _systemOutputLines
                                                        .length),
                                                duration: const Duration(
                                                    milliseconds: 800),
                                                builder:
                                                    (context, value, child) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      for (int i = 0;
                                                          i < value;
                                                          i++)
                                                        Text(
                                                          _systemOutputLines[i],
                                                          style: TextStyle(
                                                            color: i == 0
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .cyanAccent,
                                                            fontSize: 12,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
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

                  // Automated animated cursor
                  if (!_terminalClosed &&
                      _terminalEntranceController.value >= 1.0)
                    AnimatedBuilder(
                      animation: _cursorController,
                      builder: (context, child) {
                        // Calculate how close the cursor is to the close button
                        final isNearCloseButton =
                            _cursorPosition.distanceTo(Offset(100, -95)) < 20;
                        final isClicking = _cursorController.value >= 0.9;

                        return Transform.translate(
                          offset: _cursorPosition,
                          child: Container(
                            width: isClicking
                                ? 18
                                : 20, // Slightly smaller when "clicking"
                            height: isClicking ? 18 : 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.cyanAccent,
                                width: isClicking
                                    ? 3
                                    : 2, // Thicker border when clicking
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

          // Main content
          if (_showMainContent)
            FadeTransition(
              opacity: _fadeAnimation,
              child: ResponsiveWidget(
                // Mobile layout
                mobile: NotificationListener<ScrollNotification>(
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
                        const SizedBox(height: 100),

                        // About section
                        Container(
                          key: _sectionKeys[1],
                          child: const AboutPage(),
                        ),
                        const SizedBox(height: 100),

                        // Projects section
                        Container(
                          key: _sectionKeys[2],
                          child: const ProjectsPage(),
                        ),
                        const SizedBox(height: 150),

                        // Experiences section
                        Container(
                          key: _sectionKeys[3],
                          child: const ExperiencesPage(),
                        ),
                        const SizedBox(height: 100),

                        // Skills section
                        Container(
                          key: _sectionKeys[4],
                          child: const SkillsPage(),
                        ),
                        const SizedBox(height: 100),

                        // Contact section
                        Container(
                          key: _sectionKeys[5],
                          child: const ContactPage(),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),

                // Desktop layout
                desktop: Row(
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

                          // Add copyright footer to desktop version
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: Colors.cyanAccent.withOpacity(0.3)),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.copyright,
                                    color: Colors.cyanAccent, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  "2024 RDOT",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.cyanAccent,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
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
                              const SizedBox(height: 250),

                              // Experiences section
                              Container(
                                key: _sectionKeys[3],
                                height:
                                    MediaQuery.of(context).size.height + 200,
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

  // System output lines for the split terminal
  final List<String> _systemOutputLines = [
    "[SUCCESS] Profile loaded successfully.",
    "> Initializing portfolio components...",
    "> Loading project data...",
    "> System ready.",
  ];
}

// Extension for calculating distance between offsets
extension OffsetExtension on Offset {
  double distanceTo(Offset other) {
    return (this - other).distance;
  }
}
