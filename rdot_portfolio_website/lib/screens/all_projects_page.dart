import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/painters.dart';
import '../widgets/tech_button.dart';
import '../widgets/tech_project_card.dart';
import 'detail_page.dart';
import 'projects_page.dart'; // Import for ProjectFilter enum

class AllProjectsPage extends StatefulWidget {
  final ProjectFilter initialFilter;

  const AllProjectsPage({
    super.key,
    this.initialFilter = ProjectFilter.all,
  });

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  late ProjectFilter _currentFilter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _currentFilter = widget.initialFilter;
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

          // Content
          SingleChildScrollView(
            controller: _scrollController,
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
                  const SizedBox(height: 40),

                  // Filter buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildFilterChip(ProjectFilter.all, "All"),
                      const SizedBox(width: 10),
                      _buildFilterChip(ProjectFilter.hardware, "Hardware"),
                      const SizedBox(width: 10),
                      _buildFilterChip(ProjectFilter.software, "Software"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Projects grid - updated configuration
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 15, // Reduced spacing
                    mainAxisSpacing: 15, // Reduced spacing
                    children: filteredProjects
                        .map((project) => TechProjectCard(
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
                                          project.detailPageBuilder!(context),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                            opacity: animation, child: child);
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
                                        content: ProjectDetailContent(project: {
                                          'title': project.title,
                                          'longDescription':
                                              project.longDescription,
                                          'achievements': project.achievements,
                                          'technologies': project.technologies,
                                          'imageUrl': project.imageUrl,
                                        }),
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                            opacity: animation, child: child);
                                      },
                                    ),
                                  );
                                }
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          // Scroll to top button
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
