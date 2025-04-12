import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/responsive_layout.dart';
import '../widgets/tech_button.dart';
import '../widgets/tech_project_card.dart';
import 'detail_page.dart';
import 'all_projects_page.dart';

enum ProjectFilter {
  all,
  hardware,
  software,
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  ProjectFilter _currentFilter = ProjectFilter.all;

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
    final shouldShowFade = filteredProjects.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "PROJECTS",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 100,
            height: 2,
            color: Colors.cyanAccent,
          ),
          const SizedBox(height: 20),

          // Filter buttons
          Row(
            mainAxisAlignment: ResponsiveLayout.isMobile(context)
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              _buildFilterChip(ProjectFilter.all, "All"),
              const SizedBox(width: 10),
              _buildFilterChip(ProjectFilter.hardware, "Hardware"),
              const SizedBox(width: 10),
              _buildFilterChip(ProjectFilter.software, "Software"),
            ],
          ),

          const SizedBox(height: 20),

          // Project grid with fade overlay and button on top
          Stack(
            children: [
              // Project grid
              ConstrainedBox(
                constraints: BoxConstraints(
                  // Set max height based on number of rows and device size
                  maxHeight: (ResponsiveLayout.isMobile(context)
                      ? filteredProjects.take(4).length * 270.0
                      : (filteredProjects.take(4).length / 2).ceil() * 220.0),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: ResponsiveLayout.isMobile(context) ? 1 : 2,
                  childAspectRatio:
                      ResponsiveLayout.isMobile(context) ? 1.2 : 1.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: filteredProjects
                      .take(4)
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
              ),

              // Gradient fade overlay (show for all sections with projects)
              if (shouldShowFade)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height:
                      180, // Increased from 100 to 180 for longer fade effect
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0),
                          Theme.of(context).colorScheme.background,
                        ],
                      ),
                    ),
                  ),
                ),

              // Button positioned on top of the fade (always show if there are projects)
              if (shouldShowFade)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        top: 80.0,
                        bottom:
                            20.0), // Increased top padding from 50 to 80, and bottom from 10 to 20
                    child: Center(
                      child: TechButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      AllProjectsPage(
                                          initialFilter: _currentFilter),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOutCubic;
                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 800),
                            ),
                          );
                        },
                        label: "VIEW ALL PROJECTS",
                      ),
                    ),
                  ),
                ),
            ],
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
