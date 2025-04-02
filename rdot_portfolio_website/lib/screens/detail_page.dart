import 'package:flutter/material.dart';
import '../utils/painters.dart';

/// Generic detail page for displaying project or experience details
class DetailPage extends StatelessWidget {
  final String title;
  final Widget content;

  const DetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Background effect
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Detail content passed in from caller
                  content,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Content widget for displaying project details
class ProjectDetailContent extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailContent({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              image: DecorationImage(
                image: NetworkImage(project['imageUrl']),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Project description
          Text(
            project['longDescription'],
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 30),

          // Achievements section
          const Text(
            "Key Achievements",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          ...project['achievements'].map<Widget>((achievement) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "•",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      achievement,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 30),

          // Technologies section
          const Text(
            "Technologies Used",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: (project['technologies'] as List<String>).map((tech) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Text(
                  tech,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.cyanAccent,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Content widget for displaying experience details
class ExperienceDetailContent extends StatelessWidget {
  final Map<String, dynamic> experience;

  const ExperienceDetailContent({
    super.key,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job title with icon
          Row(
            children: [
              const Icon(Icons.work, color: Colors.cyanAccent, size: 24),
              const SizedBox(width: 15),
              Text(
                experience['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Organization
          Text(
            experience['organization'],
            style: TextStyle(
              fontSize: 20,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 10),

          // Duration
          Text(
            experience['duration'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 30),

          // Responsibilities
          ...experience['responsibilities'].map<Widget>((responsibility) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "•",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      responsibility,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          // Technologies (if available)
          if (experience['technologies'] != null) ...[
            const SizedBox(height: 30),
            const Text(
              "Technologies Used",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  (experience['technologies'] as List<String>).map((tech) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
