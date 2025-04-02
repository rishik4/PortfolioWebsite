import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../widgets/glitch_text.dart';
import '../widgets/tech_button.dart';

class HomePage extends StatelessWidget {
  final bool showGlitch;

  const HomePage({
    super.key,
    this.showGlitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "HELLO WORLD",
              style: TextStyle(
                fontSize: 16,
                color: Colors.cyanAccent.withOpacity(0.7),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 15),
            GlitchText(
              text: "RISHIK BODDETI",
              glitchEnabled: showGlitch,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 2,
              color: Colors.cyanAccent,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 600,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'ELECTRICAL & COMPUTER ENGINEERING STUDENT | APP DEVELOPER | INNOVATOR',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    '01010011 01000101 01000011 01010010 01000101 01010100',
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                      fontFamily: 'monospace',
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    'DECODING REALITY ONE BUG AT A TIME',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    '01001110 01001111 01010100 00100000 01000001 00100000 01000010 01010101 01000111',
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                      fontFamily: 'monospace',
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    'JUST A FEATURE IN DISGUISE',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    '01010000 01010010 01001111 01000111 01010010 01000001 01001101 01001101 01001001 01001110 01000111',
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                      fontFamily: 'monospace',
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    'TURNING COFFEE INTO CODE SINCE 2015',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 2000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
                onTap: () {
                  // Easter egg: Show a tooltip or snackbar with a hidden message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'You found a secret! But can you decode the binary?',
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                      backgroundColor: Colors.black.withOpacity(0.8),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80), // Increased spacing for the button
            Container(
              padding:
                  const EdgeInsets.all(15), // Add padding around the button
              // Add a subtle highlight to make the button more noticeable
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TechButton(
                onPressed: () {
                  // Get portfolio home state for navigation
                  final portfolioState =
                      context.findAncestorStateOfType<_PortfolioHomeState>();
                  if (portfolioState != null) {
                    portfolioState._scrollToSection(
                        2); // 2 is the index of the projects section
                  }
                },
                label: "VIEW PROJECTS",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Forward declaration for portfolio home state to enable navigation
class _PortfolioHomeState extends State<StatefulWidget> {
  void _scrollToSection(int index) {
    // This is a forward declaration - the actual implementation
    // is in portfolio_home.dart
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('This is a forward declaration');
  }
}
