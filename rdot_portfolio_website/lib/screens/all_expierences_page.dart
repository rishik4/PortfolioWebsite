import 'package:flutter/material.dart';
import '../models/expierences.dart';
import '../utils/painters.dart';
import '../widgets/timeline_expierence_card.dart';
import 'detail_page.dart';

class AllExperiencesPage extends StatelessWidget {
  const AllExperiencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Background animation
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
                        "FULL TIMELINE",
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

                  // Timeline of all experiences
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Experience.experiences.length,
                    itemBuilder: (context, index) {
                      final experience = Experience.experiences[index];
                      return TimelineExperienceCard(
                        experience: {
                          'title': experience.title,
                          'organization': experience.organization,
                          'duration': experience.duration,
                          'responsibilities': experience.responsibilities,
                          'technologies': experience.technologies,
                        },
                        isLast: index == Experience.experiences.length - 1,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      DetailPage(
                                title: experience.title,
                                content: ExperienceDetailContent(
                                  experience: {
                                    'title': experience.title,
                                    'organization': experience.organization,
                                    'duration': experience.duration,
                                    'responsibilities':
                                        experience.responsibilities,
                                    'technologies': experience.technologies,
                                  },
                                ),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
