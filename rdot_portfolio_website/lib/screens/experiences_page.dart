import 'package:flutter/material.dart';
import '../models/expierences.dart';
import '../widgets/tech_button.dart';
import '../widgets/timeline_expierence_card.dart';
import 'all_expierences_page.dart';
import 'detail_page.dart';

class ExperiencesPage extends StatelessWidget {
  const ExperiencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "EXPERIENCES",
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
            const SizedBox(height: 50),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Experience.experiences.take(3).length,
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
                  isLast: index == 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DetailPage(
                          title: experience.title,
                          content: ExperienceDetailContent(
                            experience: {
                              'title': experience.title,
                              'organization': experience.organization,
                              'duration': experience.duration,
                              'responsibilities': experience.responsibilities,
                              'technologies': experience.technologies,
                            },
                          ),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 60),
            Center(
              child: TechButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AllExperiencesPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                label: "VIEW FULL TIMELINE",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
