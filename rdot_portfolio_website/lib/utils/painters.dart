import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Painter for tech-themed background grid and particles
class TechBackgroundPainter extends CustomPainter {
  final double animationValue;

  TechBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final spacing = 30.0;
    final hCount = (size.height / spacing).ceil();
    final wCount = (size.width / spacing).ceil();

    // Draw horizontal grid lines
    for (int i = 0; i < hCount; i++) {
      final y = i * spacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Draw vertical grid lines
    for (int i = 0; i < wCount; i++) {
      final x = i * spacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Draw animated particles
    final particlePaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 1.0;

    final particleCount = 50;
    for (int i = 0; i < particleCount; i++) {
      final offset = animationValue * math.pi * 2;
      final phase = i / particleCount * math.pi * 2;
      final x = (i % wCount) * spacing + math.sin(phase + offset) * 10;
      final y =
          (i ~/ wCount % hCount) * spacing + math.cos(phase + offset) * 10;

      final size = 1.0 + math.sin(phase + offset).abs() * 1.5;
      canvas.drawCircle(Offset(x, y), size, particlePaint);
    }

    // Draw binary text effects
    final textStyle = TextStyle(
      color: Colors.cyanAccent.withOpacity(0.1),
      fontSize: 12,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final random = math.Random(animationValue.toInt() * 1000);
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      String binaryText = '';
      for (int j = 0; j < 8; j++) {
        binaryText += random.nextBool() ? '1' : '0';
      }

      textPainter.text = TextSpan(
        text: binaryText,
        style: textStyle,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Painter for glitch effect overlay
class GlitchPainter extends CustomPainter {
  final double animationValue;
  final math.Random random = math.Random();

  GlitchPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final int glitchCount = (10 * animationValue).ceil();

    for (int i = 0; i < glitchCount; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double width = random.nextDouble() * 100 + 50;
      final double height = random.nextDouble() * 10 + 5;

      final Paint paint = Paint()
        ..color = Colors.cyanAccent.withOpacity(random.nextDouble() * 0.2);

      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
