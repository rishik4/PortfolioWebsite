import 'package:flutter/material.dart';

class TechSkillBadge extends StatefulWidget {
  final String skill;

  const TechSkillBadge({super.key, required this.skill});

  @override
  State<TechSkillBadge> createState() => _TechSkillBadgeState();
}

class _TechSkillBadgeState extends State<TechSkillBadge> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovering ? Colors.cyanAccent : Colors.transparent,
          border: Border.all(color: Colors.cyanAccent),
        ),
        child: Text(
          widget.skill,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: _isHovering ? Colors.black : Colors.cyanAccent,
          ),
        ),
      ),
    );
  }
}
