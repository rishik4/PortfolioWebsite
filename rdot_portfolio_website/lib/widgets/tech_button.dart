import 'package:flutter/material.dart';

/// Styled button with tech-inspired design
class TechButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const TechButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<TechButton> createState() => _TechButtonState();
}

class _TechButtonState extends State<TechButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.cyanAccent : Colors.transparent,
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code,
                size: 18,
                color: _isHovering ? Colors.black : Colors.cyanAccent,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: _isHovering ? Colors.black : Colors.cyanAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
