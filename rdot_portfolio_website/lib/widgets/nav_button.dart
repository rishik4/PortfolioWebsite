import 'package:flutter/material.dart';

/// Navigation button for the sidebar
class NavButton extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: widget.isSelected
                    ? Colors.cyanAccent
                    : _isHovering
                        ? Colors.cyanAccent.withOpacity(0.5)
                        : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 2,
              color: widget.isSelected || _isHovering
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
