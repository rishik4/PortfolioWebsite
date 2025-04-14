import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rdot_portfolio_website/screens/project_transition_page.dart';
import '../widgets/glitch_text.dart';
import '../widgets/tech_button.dart';
import 'portfolio_home.dart';

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
                    'ELECTRICAL & COMPUTER ENGINEERING STUDENT',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    'CREATOR OF CINE MATCH PRO & ICOG',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.2,
                      fontFamily: 'monospace',
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    'FOUNDER OF RDOT APPS',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    '01010010 01001001 01010011 01001000 01001001 01001011 00100000 01010111 01000001 01010011 00100000 01001000 01000101 01010010 01000101',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
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
            const SizedBox(height: 50),
            TechButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProjectTransitionPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              label: "VIEW PROJECTS",
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
