import 'package:flutter/material.dart';
import '../widgets/tech_skill_badge.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = {
      "PROGRAMMING_LANGUAGES": [
        "Dart",
        "Python",
        "Java",
        "C/C++",
        "C#",
        "LabVIEW",
        "ARM Assembly"
      ],
      "FRAMEWORKS_LIBRARIES": ["Flutter", "Angular"],
      "TOOLS_PLATFORMS": ["Git", "VS Code", "Eclipse", "Figma", "Adobe XD"],
      "DATABASES": ["Firebase Firestore"],
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SKILLS",
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
            const SizedBox(height: 60), // Increased spacing
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final category = skills.keys.elementAt(index);
                final skillsList = skills[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 50,
                      height: 1,
                      color: Colors.cyanAccent.withOpacity(0.5),
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: skillsList
                          .map((skill) => TechSkillBadge(skill: skill))
                          .toList(),
                    ),
                    const SizedBox(
                        height: 40), // Increased spacing between categories
                  ],
                );
              },
            ),
            const SizedBox(height: 40), // Added bottom padding
          ],
        ),
      ),
    );
  }
}
