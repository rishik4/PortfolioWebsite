import 'package:flutter/material.dart';

class TechInfoCard extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;

  const TechInfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  State<TechInfoCard> createState() => _TechInfoCardState();
}

class _TechInfoCardState extends State<TechInfoCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        width: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: _isHovering
                ? Colors.cyanAccent
                : Colors.cyanAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: Colors.cyanAccent, size: 20),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.cyanAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: 30,
              height: 1,
              color: Colors.cyanAccent.withOpacity(0.5),
            ),
            const SizedBox(height: 15),
            Text(
              widget.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
