import 'package:flutter/material.dart';

/// Widget that displays text with a glitch effect when enabled
class GlitchText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool glitchEnabled;

  const GlitchText({
    super.key,
    required this.text,
    this.style,
    this.glitchEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // If glitch is not enabled, just show normal text
    if (!glitchEnabled) {
      return Text(text, style: style);
    }

    // Show glitched text with offset colored layers
    return Stack(
      children: [
        // Red layer - slightly offset
        Opacity(
          opacity: 0.8,
          child: Transform.translate(
            offset: const Offset(2, 0),
            child: Text(
              text,
              style: style?.copyWith(
                color: Colors.redAccent.withOpacity(0.5),
              ),
            ),
          ),
        ),
        // Blue layer - slightly offset in opposite direction
        Opacity(
          opacity: 0.8,
          child: Transform.translate(
            offset: const Offset(-2, 0),
            child: Text(
              text,
              style: style?.copyWith(
                color: Colors.blueAccent.withOpacity(0.5),
              ),
            ),
          ),
        ),
        // Main text on top
        Text(text, style: style),
      ],
    );
  }
}
