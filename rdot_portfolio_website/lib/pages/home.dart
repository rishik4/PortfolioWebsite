import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/tech_button.dart';
import '../home_page.dart';

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
                  // ...existing code...
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
            const SizedBox(height: 50),
            TechButton(
              onPressed: () {
                final targetContext = context
                    .findAncestorStateOfType<_PortfolioHomeState>()
                    ?._sectionKeys[2]
                    .currentContext;
                if (targetContext != null) {
                  Scrollable.ensureVisible(
                    targetContext,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  );
                }
              },
              label: "VIEW PROJECTS",
            ),
          ],
        ),
      ),
    );
  }
}
