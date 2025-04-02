import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/painters.dart';
import '../widgets/tech_button.dart';
import '../widgets/tech_project_card.dart';
import 'detail_page.dart';

class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
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

  @override
  Widget build(BuildContext context) {
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

                  // Projects grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: Project.projects
                        .map((project) => TechProjectCard(
                              title: project.title,
                              description: project.description,
                              technologies: project.technologies,
                              imageUrl: project.imageUrl,
                              onTap: () {
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
}
