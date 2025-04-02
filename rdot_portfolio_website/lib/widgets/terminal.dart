import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

/// A terminal-like widget that types out text with typewriter effect
class Terminal extends StatelessWidget {
  final String prompt;
  final String command;
  final String response;

  const Terminal({
    super.key,
    required this.prompt,
    required this.command,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          // First animation: Typing the command
          TypewriterAnimatedText(
            '$prompt $command',
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.cyanAccent,
            ),
            speed: const Duration(milliseconds: 100),
          ),
          // Second animation: Command + response
          TypewriterAnimatedText(
            '$prompt $command\n$response',
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.cyanAccent,
            ),
            speed: const Duration(milliseconds: 50),
          ),
        ],
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 500),
      ),
    );
  }
}
