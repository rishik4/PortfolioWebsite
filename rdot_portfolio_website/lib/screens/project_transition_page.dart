import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rdot_portfolio_website/models/project.dart';
import 'package:rdot_portfolio_website/screens/all_projects_page.dart';
import 'package:rdot_portfolio_website/widgets/tech_button.dart';

import 'projects_page.dart';

class ProjectTransitionPage extends StatefulWidget {
  final ProjectFilter initialFilter;

  const ProjectTransitionPage({
    super.key,
    this.initialFilter = ProjectFilter.all,
  });

  @override
  State<ProjectTransitionPage> createState() => _ProjectTransitionPageState();
}

class _ProjectTransitionPageState extends State<ProjectTransitionPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _circuitController;
  late AnimationController _pulseController;
  late AnimationController _projectsController;
  late AnimationController _fadeOutController;

  // Animation values
  late Animation<double> _circuitAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _projectsAnimation;
  late Animation<double> _fadeOutAnimation;

  // Track animation progress for navigation
  bool _navigating = false;

  // List of sample project thumbnails for the animation
  final List<String> _projectThumbnails =
      Project.projects.map((project) => project.imageUrl).take(8).toList();

  @override
  void initState() {
    super.initState();

    // First animation: circuit drawing from left to right
    _circuitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _circuitAnimation = CurvedAnimation(
      parent: _circuitController,
      curve: Curves.easeOut,
    );

    // Second animation: pulse traveling along the circuit
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Third animation: projects appearing
    _projectsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Longer for smoother effect
    );
    _projectsAnimation = CurvedAnimation(
      parent: _projectsController,
      curve: Curves.easeOutQuart, // More dramatic curve for better zoom-in
    );

    // Final animation: fade out for navigation
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeOutController,
        curve: Curves.easeOut,
      ),
    );

    // Chain the animations in sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // First draw the circuit
    _circuitController.forward().then((_) {
      // Then run the pulse along the circuit
      _pulseController.forward().then((_) {
        // Then show the projects
        _projectsController.forward().then((_) {
          // Then navigate to project page
          _navigateToProjectsPage();
        });
      });
    });
  }

  void _navigateToProjectsPage() {
    if (!_navigating) {
      setState(() {
        _navigating = true;
      });

      // Fade out before navigation
      _fadeOutController.forward().then((_) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => AllProjectsPage(
              initialFilter: widget.initialFilter,
              // Pass the animation to AllProjectsPage for coordinated entry animation
              entranceAnimation: animation,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Custom transition - fade in and slight zoom
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animation, curve: Curves.easeOutQuart),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      });
    }
  }

  void _skipAnimation() {
    _circuitController.stop();
    _pulseController.stop();
    _projectsController.stop();
    _navigateToProjectsPage();
  }

  @override
  void dispose() {
    _circuitController.dispose();
    _pulseController.dispose();
    _projectsController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeOutAnimation,
        child: Stack(
          children: [
            // Circuit and pulse animation
            AnimatedBuilder(
              animation: Listenable.merge([_circuitAnimation, _pulseAnimation]),
              builder: (context, _) {
                return CustomPaint(
                  painter: HorizontalCircuitPainter(
                    circuitProgress: _circuitAnimation.value,
                    pulseProgress: _pulseAnimation.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),

            // Project thumbnails grid animation - improved with zoom and staggered fade
            AnimatedBuilder(
              animation: _projectsAnimation,
              builder: (context, _) {
                return Opacity(
                  opacity: _projectsAnimation.value,
                  // Add a scaling effect to the entire grid
                  child: Transform.scale(
                    scale: 0.8 + (_projectsAnimation.value * 0.2),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 800,
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: _projectThumbnails.length,
                          itemBuilder: (context, index) {
                            // Enhanced staggered delay with better curve
                            final delay =
                                index * 0.08; // Slightly faster appearance
                            final itemAnimation =
                                _projectsAnimation.value > delay
                                    ? math
                                        .pow(
                                            (_projectsAnimation.value - delay) /
                                                (1 - delay),
                                            1.5)
                                        .toDouble() // More dramatic curve
                                    : 0.0;

                            return Transform(
                              // Add a 3D perspective effect
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // Perspective
                                ..scale(math.min(1.0, itemAnimation * 1.2))
                                ..translate(
                                    0.0,
                                    (1.0 - itemAnimation) *
                                        20), // Slide up slightly
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: math.min(1.0, itemAnimation * 1.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.cyanAccent.withOpacity(
                                        math.min(1.0, itemAnimation * 2),
                                      ),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyanAccent
                                            .withOpacity(0.3 * itemAnimation),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image:
                                          AssetImage(_projectThumbnails[index]),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.6),
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _circuitController,
                    _pulseController,
                    _projectsController,
                  ]),
                  builder: (context, _) {
                    // Calculate overall progress
                    final progress = (_circuitController.value * 0.33 +
                        _pulseAnimation.value * 0.33 +
                        _projectsAnimation.value * 0.34);

                    return Column(
                      children: [
                        // Progress text
                        Text(
                          "LOADING PROJECTS ${(progress * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 16,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Progress bar
                        Container(
                          width: 300,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Skip button
            Positioned(
              top: 40,
              right: 40,
              child: TechButton(
                onPressed: _skipAnimation,
                label: "SKIP",
                fontSize: 14,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalCircuitPainter extends CustomPainter {
  final double circuitProgress;
  final double pulseProgress;

  // Random generator with non-fixed seed for variation each time
  final math.Random _random =
      math.Random(DateTime.now().millisecondsSinceEpoch);

  // Store the main circuit path and its segments
  late final Path _mainCircuitPath;
  late final List<Path> _branchPaths;
  late final List<Path> _nodePaths;
  // Store branch pulse positions for mini-pulses
  late final List<double> _branchPulsePositions;

  HorizontalCircuitPainter({
    required this.circuitProgress,
    required this.pulseProgress,
  }) {
    _mainCircuitPath = Path();
    _branchPaths = List.generate(5, (_) => Path());
    _nodePaths = List.generate(8, (_) => Path());
    _branchPulsePositions =
        List.generate(5, (_) => 0.0); // Initialize pulse positions
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Generate the main circuit path if it's empty
    if (_mainCircuitPath.computeMetrics().isEmpty) {
      _generateMainCircuitPath(size);
      _generateBranchPaths(size);
      _generateNodePaths(size);
    }

    // Paint settings for the circuit
    final circuitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.cyanAccent.withOpacity(0.7)
      ..strokeCap = StrokeCap.round;

    // Draw the main circuit path with progress
    final mainPathMetrics = _mainCircuitPath.computeMetrics().first;
    final mainPathLength = mainPathMetrics.length;
    final mainPathExtract = mainPathMetrics.extractPath(
      0,
      mainPathLength * circuitProgress,
    );
    canvas.drawPath(mainPathExtract, circuitPaint);

    // Draw branch paths with a slight delay after main path progress
    if (circuitProgress > 0.3) {
      final branchProgress = (circuitProgress - 0.3) / 0.7; // Normalize to 0-1

      for (var i = 0; i < _branchPaths.length; i++) {
        final delayFactor =
            i / _branchPaths.length; // Stagger branch appearances
        final branchPathProgress = math.max(0, branchProgress - delayFactor);

        if (branchPathProgress > 0) {
          final metrics = _branchPaths[i].computeMetrics().first;
          final extractPath = metrics.extractPath(
            0,
            metrics.length * math.min(1.0, branchPathProgress * 3),
          );

          circuitPaint.color = Colors.cyanAccent.withOpacity(0.5);
          canvas.drawPath(extractPath, circuitPaint);
        }
      }
    }

    // Draw nodes with a "pop" effect as the circuit progresses
    for (var i = 0; i < _nodePaths.length; i++) {
      // Position each node along the path progress
      final nodePosition = i / (_nodePaths.length - 1);

      // Only show node if the circuit has reached it
      if (circuitProgress >= nodePosition) {
        final nodeProgress =
            math.min(1.0, (circuitProgress - nodePosition) * 8);

        // Scale effect for node appearance
        final scale = nodeProgress < 0.5 ? nodeProgress * 2 : 1.0;

        // Pulse effect for nodes
        final pulseFactor =
            1.0 + 0.2 * math.sin(nodePosition * 10 + circuitProgress * 5);

        // Draw node
        final nodePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.cyanAccent.withOpacity(0.8);

        // Draw node with scale
        canvas.save();

        // Get node path bounds
        final nodeBounds = _nodePaths[i].getBounds();
        final nodeCenter = Offset(nodeBounds.center.dx, nodeBounds.center.dy);

        // Apply scale transform
        canvas.translate(nodeCenter.dx, nodeCenter.dy);
        canvas.scale(scale * pulseFactor);
        canvas.translate(-nodeCenter.dx, -nodeCenter.dy);

        canvas.drawPath(_nodePaths[i], nodePaint);
        canvas.restore();
      }
    }

    // Calculate positions along the main path for branch connections
    final branchPositions = List.generate(_branchPaths.length,
        (i) => 0.2 + (i / (_branchPaths.length + 1)) * 0.6);

    // Draw pulse effect after circuit is complete
    if (pulseProgress > 0 && circuitProgress >= 0.95) {
      // Main pulse
      _drawPulseEffect(canvas, mainPathMetrics, mainPathLength, pulseProgress);

      // Trigger mini pulses when main pulse passes branch points
      for (var i = 0; i < _branchPaths.length; i++) {
        // Check if main pulse is near this branch point
        final branchPosition = branchPositions[i];
        final distanceFromBranch = (pulseProgress - branchPosition).abs();

        // Trigger mini pulse when main pulse passes nearby
        if (distanceFromBranch < 0.05 && _branchPulsePositions[i] == 0) {
          _branchPulsePositions[i] = 0.01; // Start the mini pulse
        }

        // Update existing mini pulse position
        if (_branchPulsePositions[i] > 0) {
          _branchPulsePositions[i] =
              math.min(1.0, _branchPulsePositions[i] + 0.07);

          // Draw mini pulse on branch
          if (_branchPaths[i].computeMetrics().isNotEmpty) {
            final branchMetrics = _branchPaths[i].computeMetrics().first;
            final branchLength = branchMetrics.length;

            _drawMiniPulseEffect(
                canvas, branchMetrics, branchLength, _branchPulsePositions[i]);
          }
        }
      }
    }
  }

  // Helper method for drawing the main pulse effect
  void _drawPulseEffect(
      Canvas canvas, PathMetric metrics, double pathLength, double position) {
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    // Create glow effect with shadow layers
    for (var i = 0; i < 3; i++) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0 - i * 1.2
        ..color = Colors.cyanAccent.withOpacity(0.7 - i * 0.2)
        ..strokeCap = StrokeCap.round;

      // Extract a small segment of the path where the pulse is
      final pulseStart = position * pathLength - 20;
      final pulseEnd = position * pathLength + 20;

      if (pulseStart >= 0 && pulseEnd <= pathLength) {
        final pulsePath = metrics.extractPath(pulseStart, pulseEnd);
        canvas.drawPath(pulsePath, glowPaint);
      }
    }

    // Draw white center of pulse
    final pulseCenterStart = position * pathLength - 8;
    final pulseCenterEnd = position * pathLength + 8;

    if (pulseCenterStart >= 0 && pulseCenterEnd <= pathLength) {
      final pulseCenterPath =
          metrics.extractPath(pulseCenterStart, pulseCenterEnd);
      canvas.drawPath(pulseCenterPath, pulsePaint);
    }
  }

  // Helper method for drawing mini pulse effects on branches
  void _drawMiniPulseEffect(
      Canvas canvas, PathMetric metrics, double pathLength, double position) {
    final miniPulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.white.withOpacity(0.8)
      ..strokeCap = StrokeCap.round;

    // Create smaller glow effect
    for (var i = 0; i < 2; i++) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5 - i * 1.0
        ..color = Colors.cyanAccent.withOpacity(0.6 - i * 0.2)
        ..strokeCap = StrokeCap.round;

      // Extract a small segment of the path where the pulse is
      final pulseStart = position * pathLength - 10;
      final pulseEnd = position * pathLength + 10;

      if (pulseStart >= 0 && pulseEnd <= pathLength) {
        final pulsePath = metrics.extractPath(pulseStart, pulseEnd);
        canvas.drawPath(pulsePath, glowPaint);
      }
    }

    // Draw white center of mini pulse
    final pulseCenterStart = position * pathLength - 5;
    final pulseCenterEnd = position * pathLength + 5;

    if (pulseCenterStart >= 0 && pulseCenterEnd <= pathLength) {
      final pulseCenterPath =
          metrics.extractPath(pulseCenterStart, pulseCenterEnd);
      canvas.drawPath(pulseCenterPath, miniPulsePaint);
    }
  }

  void _generateMainCircuitPath(Size size) {
    // Start from left edge
    final startY = size.height * 0.5;
    _mainCircuitPath.moveTo(0, startY);

    // Generate a straighter path with minimal vertical variation
    double currentX = 0;
    double currentY = startY;

    // Main segments - straighter horizontal movement
    final segmentCount = 6;
    final baseSegmentWidth = size.width / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      // Determine next horizontal position
      final nextX = currentX + baseSegmentWidth;

      // Add very minimal vertical variation for a mostly straight line
      final verticalVariation =
          size.height * 0.03 * (_random.nextDouble() - 0.5);
      final nextY = currentY + verticalVariation;

      // For a straighter line, use lineTo instead of quadraticBezierTo
      _mainCircuitPath.lineTo(nextX, nextY);

      // Move to next segment
      currentX = nextX;
      currentY = nextY;

      // Special case for last segment - make sure we reach the right edge
      if (i == segmentCount - 2) {
        currentX = size.width;
      }
    }
  }

  void _generateBranchPaths(Size size) {
    // Get metrics from main path to find points along it
    final metrics = _mainCircuitPath.computeMetrics().first;
    final mainPathLength = metrics.length;

    for (int i = 0; i < _branchPaths.length; i++) {
      // Pick a position along the main path
      final position = 0.2 + (i / (_branchPaths.length + 1)) * 0.6;
      final tangent = metrics.getTangentForOffset(mainPathLength * position);

      if (tangent != null) {
        final branchStart = tangent.position;

        // Create a branch that goes perpendicular to the main path
        final perpendicular =
            Offset(-tangent.vector.dy, tangent.vector.dx).normalized();

        // Branch direction (up or down)
        final branchDirection = _random.nextBool() ? 1.0 : -1.0;

        // Branch length
        final branchLength = size.height * (0.1 + _random.nextDouble() * 0.15);

        final branchEnd =
            branchStart + perpendicular * branchLength * branchDirection;

        // Draw the branch as a completely straight line
        _branchPaths[i].moveTo(branchStart.dx, branchStart.dy);
        _branchPaths[i].lineTo(branchEnd.dx, branchEnd.dy);
      }
    }
  }

  void _generateNodePaths(Size size) {
    // Get metrics from main path to find points along it
    final metrics = _mainCircuitPath.computeMetrics().first;
    final mainPathLength = metrics.length;

    for (int i = 0; i < _nodePaths.length; i++) {
      // Distribute nodes along the path
      final position = i / (_nodePaths.length - 1);
      final tangent = metrics.getTangentForOffset(mainPathLength * position);

      if (tangent != null) {
        final nodeCenter = tangent.position;
        final nodeSize = 4.0 + _random.nextDouble() * 3.0;

        // Create a node (small circle)
        _nodePaths[i].addOval(
          Rect.fromCenter(
            center: nodeCenter,
            width: nodeSize,
            height: nodeSize,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(HorizontalCircuitPainter oldDelegate) {
    return oldDelegate.circuitProgress != circuitProgress ||
        oldDelegate.pulseProgress != pulseProgress;
  }
}

extension OffsetExtension on Offset {
  Offset normalized() {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return this / magnitude;
  }
}
