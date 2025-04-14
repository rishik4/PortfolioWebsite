import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/project.dart';
import '../utils/painters.dart';
import '../widgets/tech_button.dart';
import '../widgets/tech_project_card.dart';
import 'detail_page.dart';
import 'projects_page.dart';

class AllProjectsPage extends StatefulWidget {
  final ProjectFilter initialFilter;
  final Animation<double>? entranceAnimation;

  const AllProjectsPage({
    super.key,
    this.initialFilter = ProjectFilter.all,
    this.entranceAnimation,
  });

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  late ProjectFilter _currentFilter;

  // Additional animation controller for elements inside the page
  late AnimationController _contentAnimationController;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _currentFilter = widget.initialFilter;

    // Setup internal animations for staggered entry of content
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutQuart,
    );

    // Start the content animation
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!mounted) return;
    setState(() {
      _showScrollToTop = _scrollController.offset > 300;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<Project> _getFilteredProjects() {
    switch (_currentFilter) {
      case ProjectFilter.hardware:
        return Project.projects.where((p) => p.type == 'hardware').toList();
      case ProjectFilter.software:
        return Project.projects.where((p) => p.type == 'software').toList();
      case ProjectFilter.all:
      default:
        return Project.projects;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _getFilteredProjects();
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive grid columns based on screen width
    int crossAxisCount = 2; // Default
    double aspectRatio = 1.5; // Default

    if (screenWidth > 1200) {
      crossAxisCount = 4; // 4 columns for large screens
      aspectRatio = 1.0; // More square-like for smaller boxes
    } else if (screenWidth > 800) {
      crossAxisCount = 3; // 3 columns for medium screens
      aspectRatio = 1.2;
    } else if (screenWidth <= 600) {
      crossAxisCount = 1; // 1 column for very small screens
      aspectRatio = 1.5;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Background
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

          // Content with enhanced animations
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button - animated entry
                  AnimatedBuilder(
                    animation: _contentAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _contentAnimation.value)),
                        child: Opacity(
                          opacity: _contentAnimation.value,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.cyanAccent),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                "ALL PROJECTS",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Filter buttons - staggered animation
                  AnimatedBuilder(
                    animation: _contentAnimation,
                    builder: (context, child) {
                      // Delay the filters appearance slightly
                      final delayedAnimation = _contentAnimation.value < 0.2
                          ? 0.0
                          : (_contentAnimation.value - 0.2) / 0.8;

                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - delayedAnimation)),
                        child: Opacity(
                          opacity: delayedAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildFilterChip(ProjectFilter.all, "All"),
                              const SizedBox(width: 10),
                              _buildFilterChip(
                                  ProjectFilter.hardware, "Hardware"),
                              const SizedBox(width: 10),
                              _buildFilterChip(
                                  ProjectFilter.software, "Software"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // Projects grid - staggered animation for each item
                  AnimatedBuilder(
                    animation: _contentAnimation,
                    builder: (context, child) {
                      // Delay the grid appearance even more
                      final delayedAnimation = _contentAnimation.value < 0.3
                          ? 0.0
                          : (_contentAnimation.value - 0.3) / 0.7;

                      return Opacity(
                        opacity: delayedAnimation,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - delayedAnimation)),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            children: List.generate(
                              filteredProjects.length,
                              (index) {
                                // Calculate staggered animation for each grid item
                                final itemDelay =
                                    math.min(0.8, 0.4 + (index * 0.05));
                                final itemAnimation = _contentAnimation.value <
                                        itemDelay
                                    ? 0.0
                                    : (_contentAnimation.value - itemDelay) /
                                        (1.0 - itemDelay);

                                final project = filteredProjects[index];

                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001) // Add perspective
                                    ..translate(0.0, 20 * (1.0 - itemAnimation))
                                    ..scale(0.9 + (0.1 * itemAnimation)),
                                  child: Opacity(
                                    opacity: itemAnimation,
                                    child: TechProjectCard(
                                      title: project.title,
                                      description: project.description,
                                      technologies: project.technologies,
                                      imageUrl: project.imageUrl,
                                      onTap: () {
                                        // Use custom detail page if available
                                        if (project.isCustom &&
                                            project.detailPageBuilder != null) {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  project.detailPageBuilder!(
                                                      context),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                    opacity: animation,
                                                    child: child);
                                              },
                                            ),
                                          );
                                        } else {
                                          // Regular detail page for normal projects
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  DetailPage(
                                                title: project.title,
                                                content: ProjectDetailContent(
                                                    project: {
                                                      'title': project.title,
                                                      'longDescription': project
                                                          .longDescription,
                                                      'achievements':
                                                          project.achievements,
                                                      'technologies':
                                                          project.technologies,
                                                      'imageUrl':
                                                          project.imageUrl,
                                                    }),
                                              ),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                    opacity: animation,
                                                    child: child);
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Scroll to top button - keep existing code
          if (_showScrollToTop)
            Positioned(
              right: 20,
              bottom: 20,
              child: AnimatedOpacity(
                opacity: _showScrollToTop ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: TechButton(
                  onPressed: _scrollToTop,
                  label: "SCROLL TO TOP",
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ProjectFilter filter, String label) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: _currentFilter == filter ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: _currentFilter == filter,
      selectedColor: Colors.cyanAccent,
      checkmarkColor: Colors.black,
      backgroundColor: Colors.grey[800],
      onSelected: (bool selected) {
        setState(() {
          _currentFilter = filter;
        });
      },
    );
  }
}
