import 'package:flutter/material.dart';

/// Styled button with tech-inspired design
class TechButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const TechButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: widget.padding,
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
                  fontSize: widget.fontSize,
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
