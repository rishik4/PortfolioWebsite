import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/responsive_layout.dart';
import '../widgets/tech_button.dart';
import '../widgets/tech_project_card.dart';
import 'detail_page.dart';
import 'all_projects_page.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 30),

            // Project grid with responsive layout
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: ResponsiveLayout.isMobile(context) ? 1 : 2,
              childAspectRatio: ResponsiveLayout.isMobile(context) ? 1.2 : 1.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: Project.projects
                  .take(4)
                  .map((project) => TechProjectCard(
                        title: project.title,
                        description: project.description,
                        technologies: project.technologies,
                        imageUrl: project.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      DetailPage(
                                title: project.title,
                                content: ProjectDetailContent(project: {
                                  'title': project.title,
                                  'longDescription': project.longDescription,
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
            const SizedBox(height: 40),

            // View all projects button
            Center(
              child: TechButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AllProjectsPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                      transitionDuration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                label: "VIEW ALL PROJECTS",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
