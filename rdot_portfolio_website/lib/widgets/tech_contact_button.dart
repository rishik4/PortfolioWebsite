import 'package:flutter/material.dart';

class TechContactButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const TechContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<TechContactButton> createState() => _TechContactButtonState();
}

class _TechContactButtonState extends State<TechContactButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.cyanAccent : Colors.transparent,
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: _isHovering ? Colors.black : Colors.cyanAccent,
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
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
