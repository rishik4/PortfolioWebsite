import 'package:flutter/material.dart';

/// Card widget for displaying project information with hover effects
class TechProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final VoidCallback onTap;

  const TechProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<TechProjectCard> createState() => _TechProjectCardState();
}

class _TechProjectCardState extends State<TechProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: _isHovering
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.3),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            color: Colors.cyanAccent.withOpacity(0.1),
                            colorBlendMode: BlendMode.darken,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.black,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.cyanAccent,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Details section
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with icon
                        Row(
                          children: [
                            const Icon(Icons.code,
                                size: 16, color: Colors.cyanAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward,
                                size: 16, color: Colors.cyanAccent),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Description text
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),

                        // Technology tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.technologies
                              .map((tech) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Colors.cyanAccent.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Hover overlay with "View Details" text
              if (_isHovering)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility,
                              color: Colors.cyanAccent),
                          const SizedBox(width: 8),
                          const Text(
                            "VIEW DETAILS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
