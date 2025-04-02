import 'package:flutter/material.dart';

class TimelineExperienceCard extends StatefulWidget {
  final Map<String, dynamic> experience;
  final bool isLast;
  final VoidCallback onTap;

  const TimelineExperienceCard({
    super.key,
    required this.experience,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<TimelineExperienceCard> createState() => _TimelineExperienceCardState();
}

class _TimelineExperienceCardState extends State<TimelineExperienceCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline vertical line with dot
          SizedBox(
            width: 50,
            child: Column(
              children: [
                // Timeline dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
                // Timeline vertical line (not shown for last item)
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.cyanAccent.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          // Experience card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 30.0),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: _isHovering
                            ? Colors.cyanAccent
                            : Colors.cyanAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row with icon
                        Row(
                          children: [
                            const Icon(Icons.work,
                                color: Colors.cyanAccent, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.experience['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward,
                                color: Colors.cyanAccent, size: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Organization
                        Text(
                          widget.experience['organization'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Duration
                        Text(
                          widget.experience['duration'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // First responsibility (truncated)
                        Text(
                          widget.experience['responsibilities'][0],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
